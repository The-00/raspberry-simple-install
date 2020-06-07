#!/bin/bash


if [ "$EUID" -ne 0 ]
	  then echo "Please run as root"
		exit
fi

OFDEV="/dev/mmcblk0"
while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "flash the raspberry pi image"
      echo " "
      echo "./1-getimage.sh [options]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
			echo "-d, --device=OFDEV        specify the device to flash (default /dev/mmcblk0)"
      exit 0
      ;;
    -d)
      shift
      if test $# -gt 0; then
        export OFDEV=$1
      else
        echo "no url specified"
        exit 1
      fi
      shift
      ;;
    --device*)
      export OFDEV=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    *)
      break
      ;;
  esac
done

echo "Flashing sdcard on $OFDEV"
dd if=raspbian.img of=$OFDEV status=progress
sync
echo "done !"
