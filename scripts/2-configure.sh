#!/bin/bash

if [ "$EUID" -ne 0 ]
	  then echo "Please run as root"
		    exit
fi

PIPASS=raspberry
WIFI=true
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "configure the raspberry pi image"
      echo " "
      echo "./2-configure.sh [-nw|(wifi options)]"
      echo " "
      echo "options:"
      echo "-h, --help                 show brief help"
      echo "-p, --password=PIPASS      set raspberrypi password"
      echo "-nw, --no-wifi             enable no-wifi"
      echo "-ws, --wifi-ssid=SSID      specify wifi SSID"
      echo "-wp, --wifi-password=PASS  specify wifi password"
      echo "-mip, --my-ip=MYIP         specify raspberrypi IP (optional)"
      echo "-rip, --router-ip=ROUTERIP specify default gateway IP (optional)"
      echo "--ssh=SSHPATH              specify ssh key position"
      exit 0
      ;;
    -nw|--no-wifi)
      WIFI=false
      break
      ;;
    -ws)
      shift
      if test $# -gt 0; then
        export SSID=$1
      else
        echo "no ssid specified"
        exit 1
      fi
      shift
      ;;
    --wifi-ssid*)
      export SSID=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    -wp)
      shift
      if test $# -gt 0; then
        export PASS=$1
      else
        echo "no password specified"
        exit 1
      fi
      shift
      ;;
    --wifi-password*)
      export PASS=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    -mip)
      shift
      if test $# -gt 0; then
        export MYIP=$1
      else
        echo "no password specified"
        exit 1
      fi
      shift
      ;;
    --my-ip*)
      export MYIP=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    -rip)
      shift
      if test $# -gt 0; then
        export ROUTERIP=$1
      else
        echo "no password specified"
        exit 1
      fi
      shift
      ;;
    --router-ip*)
      export ROUTERIP=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    --ssh*)
      export SSHPATH=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    -p)
      shift
      if test $# -gt 0; then
        export PIPASS=$1
      else
        echo "no password specified"
        exit 1
      fi
      shift
      ;;
    --password*)
      export PIPASS=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done

TEMPDIR=`mktemp -d`
echo "TEMPDIR is $TEMPDIR"

LOOPDEVBOOT=`kpartx -lsv raspbian.img | grep p1 | cut -d ' ' -f 1`
LOOPDEV=`kpartx -asv raspbian.img | grep p2 | cut -d ' ' -f 3`
echo "Loop devices are $LOOPDEVBOOT and $LOOPDEV"

mount /dev/mapper/$LOOPDEV $TEMPDIR
mount /dev/mapper/$LOOPDEVBOOT $TEMPDIR/boot
echo "Loop devices mounted in $TEMPDIR"

echo "Customizing the raspbian..."

if [ -z ${SSHPATH+x} ];
then
	echo "no ssh";
else
	mkdir $TEMPDIR/home/pi/.ssh
	SSHKEY=$( cat $SSHPATH )
	echo $SSHKEY > $TEMPDIR/home/pi/.ssh/authorized_keys
	chmod 600 $TEMPDIR/home/pi/.ssh/authorized_keys
	chown 1000:1000 $TEMPDIR/home/pi/.ssh/authorized_keys
	touch $TEMPDIR/boot/ssh
	echo "ssh and sshkey installed";
fi

if [ "$WIFI" = true ];
then
	if [ -z ${SSID+x} ] || [ -z ${PASS+x}   ];
	then
		echo "wifi information missing !"
		echo "no wifi"
	else
		echo "set wifi configuration"
		echo -e "country=fr\nupdate_config=1\nctrl_interface=/var/run/wpa_supplicant\n\nnetwork={\nscan_ssid=1\nssid=\"$SSID\"\npsk=\"$PASS\"\n}" > $TEMPDIR/boot/wpa_supplicant.conf;
	fi

	if [ -z ${MYIP+x} ] || [ -z ${ROUTERIP+x}   ];
	then
		echo "IP information missing !"
		echo "pass IP fix";
	else
		echo "set IP fix"
		echo -e "require dhcp_server_identifier\n\ninterface wlan0\nstatic ip_address=$MYIP\nstatic routers=$ROUTERIP\nstatic domain_name_servers=$ROUTERIP" > $TEMPDIR/etc/dhcpcd.conf;
	fi;
fi

#on set le mot de passe de l'utilisateur pi
HASHPASS=$( echo "$PIPASS" | openssl passwd -6 -salt pilog -stdin )
echo "new pass for user 'pi'"
echo "$PIPASS -> $HASHPASS"
PREPAREDHASHPASS=$( echo $HASHPASS | sed 's/\//\\\//g' )
sed -i -e "s/pi:[^:]*:/pi:$PREPAREDHASHPASS:/" $TEMPDIR/etc/shadow

echo "Cleaning..."

umount $TEMPDIR/boot
umount $TEMPDIR
echo "Loop devices unmounted"

kpartx -d raspbian.img
rmdir $TEMPDIR
echo "All cleaned !"
