#!/bin/sh

PIDRIVE='/dev/sda';
PIPART1=$PIDRIVE'1';
IMGVER='3.10';
IMGREV='2';
IMGTYPE='armhf';
URL='http://dl-cdn.alpinelinux.org/alpine/';
IMG="alpine-rpi-$IMGVER.$IMGREV-$IMGTYPE.tar.gz";

echo 'grab image...';
wget "$URL""v$IMGVER/releases/$IMGTYPE/$IMG";

echo 'making partitions...';
sudo parted -s $PIDRIVE 'mktable msdos';
sudo parted -s $PIDRIVE 'mkpart primary fat32 2048s -1';
sudo parted -s $PIDRIVE 'toggle 1 boot';
sudo mkfs.vfat $PIPART1;

echo 'mounting...';
sudo mkdir 'alpine';
sudo mount $PIPART1 'alpine/';

echo 'unpacking...';
sudo tar -xzvf "$IMG" -C 'alpine/' > '/dev/null' && sync;

#echo 'adding drivers...'
#git clone --depth 1 'https://github.com/RPi-Distro/firmware-nonfree.git';
#cp -r 'firmware-nonfree/brcm' 'alpine/firmware/brcm';

echo 'cleanup...';
sudo umount $PIPART1;
sudo rm -rf alpine/;
rm "$IMG";
