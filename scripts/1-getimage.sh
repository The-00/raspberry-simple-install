#!/bin/bash

LATESTFULL=https://downloads.raspberrypi.org/raspios_full_armhf_latest
LATESTLIGHT=https://downloads.raspberrypi.org/raspios_lite_armhf_latest
URL=$LATESTFULL

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "get the raspberry pi image"
      echo "by default : latest full raspbian"
      echo " "
      echo "./1-getimage.sh [options]"
      echo " "
      echo "options:"
      echo "-h, --help                show brief help"
      echo "-l, --light               specify light raspbian (overide --url)"
      echo "-u, --url=URL             specify url to ziped image"
      exit 0
      ;;
    -u)
      shift
      if test $# -gt 0; then
        export URL=$1
      else
        echo "no url specified"
        exit 1
      fi
      shift
      ;;
    --url*)
      export URL=`echo $1 | sed -e 's/^[^=]*=//g'`
      shift
      ;;
    -l|--light)
      URL=$LATESTLIGHT
      shift
      ;;
    *)
      break
      ;;
  esac
done


wget $URL -O raspbian.zip

unzip raspbian.zip
# On supprime le zip pour gagner un peu de place puisqu'il ne sert plus à rien
rm raspbian.zip
mv *.img raspbian.img
