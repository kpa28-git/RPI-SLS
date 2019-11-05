#!/bin/sh
# Installs rootfs void linux image to a drive.

PIDRIVE='/dev/sda';
PIPART1=$PIDRIVE'1';
PIPART2=$PIDRIVE'2';
PIVER=$([ -n "$1" ] && echo "$1" || echo '3');
LIBC='-musl'; # '' for glibc, '-musl' for musl
IMGDATE='20181111';
URL='https://alpha.de.repo.voidlinux.org/live/current/';
IMG="void-rpi$PIVER$LIBC-PLATFORMFS-$IMGDATE.tar.xz";

if [ ! -f "$IMG" ]; then
	echo 'grab image...';
	wget "$URL$IMG";
fi;

echo 'making partitions...';
sudo parted -s $PIDRIVE 'mklabel msdos';
sudo parted -s $PIDRIVE 'mkpart primary fat32 2048s 256MB';
sudo parted -s $PIDRIVE 'toggle 1 boot';
sudo parted -s $PIDRIVE 'mkpart primary ext4 256MB -1';

echo 'making filesystem...';
sudo mkfs.vfat $PIPART1;
yes | sudo mkfs.ext4 -O '^has_journal' $PIPART2;

echo 'mounting...';
sudo mkdir rootfs;
sudo mount $PIPART2 rootfs/;
sudo mkdir rootfs/boot;
sudo mount $PIPART1 rootfs/boot/;

echo 'unpacking...';
sudo tar xvfJp "$IMG" -C rootfs/ > '/dev/null' && sync;

echo 'adding boot entry...';
echo "$PIPART1 /boot vfat defaults 0 0" | sudo tee -a rootfs/etc/fstab;

echo 'adding boot options...';
echo '
# Enable audio
dtparam=audio=on
' | sudo tee -a rootfs/boot/config.txt;

echo 'changing root partition from default...';
sed "s|/dev/mmcblk0p2|$PIPART2|" rootfs/boot/cmdline.txt | sudo tee rootfs/boot/cmdline.txt;

echo 'cleanup...';
sudo umount $PIPART1;
sudo umount $PIPART2;
sudo rm -rf rootfs/;
