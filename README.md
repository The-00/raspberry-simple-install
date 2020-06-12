# raspberry-simple-install
some scripts to pre-configure a simple raspberry pi

it get an image:
* latest
* light
* via url

It can set:
* pi password
* hostname
* wifi configuration
* fix ip
* ssh configuration
* ssh key
* motd (`src/motd`)
* timezone

It can execute a self-made script for your configuration (git clone etc...). **WARNING** This script is executed in the repository ! (see: `src/script_ex.sh`)

It flash on yout microSD card.

## requirement
* python (3)
* `kpartx`

## usage

1. insert your sdcard (`lsblk` may help to find the device name)
2. edit the `config.py`
3. run `creator.py`
4. put the sdcard in the raspberrypi
