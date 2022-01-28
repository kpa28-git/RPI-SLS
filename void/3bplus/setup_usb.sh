#!/bin/sh
# Distro: Void Linux
# Platform: Raspberry Pi 3BPlus
# Boot Media: USB Drive


[ -z "$PI_VOID_3BPLUS_USB" ] && echo "'PI_VOID_3BPLUS_USB' must be exported to the boot media device path, exiting..." && exit 1;
PIDRIVE=$PI_VOID_3BPLUS_USB;
PIDRIVEP1=$PIDRIVE'1';
PIDRIVEP2=$PIDRIVE'2';

PIVER='3';
LIBC='-musl'; # '' for glibc, '-musl' for musl
IMGDATE='20210930'; # set this to a more recent image if you want
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
sudo mkfs.vfat $PIDRIVEP1;
yes | sudo mkfs.ext4 -O '^has_journal' $PIDRIVEP2;

echo 'mounting...';
sudo mkdir rootfs;
sudo mount $PIDRIVEP2 rootfs/;
sudo mkdir rootfs/boot;
sudo mount $PIDRIVEP1 rootfs/boot/;

echo 'unpacking...';
sudo tar xvfJp "$IMG" -C rootfs/ > '/dev/null' && sync;

PIBOOT='/dev/sda';
PIBOOTP1=$PIBOOT'1';
PIBOOTP2=$PIBOOT'2';

echo 'adding boot entry...';
echo "$PIBOOTP1 /boot vfat defaults 0 0" | sudo tee -a rootfs/etc/fstab;

echo 'adding boot options...';
echo '
# Enable audio
dtparam=audio=on
' | sudo tee -a rootfs/boot/config.txt;

echo 'changing root partition from default...';
sed "s|/dev/mmcblk0p2|$PIBOOTP2|" rootfs/boot/cmdline.txt | sudo tee rootfs/boot/cmdline.txt;

echo 'cleanup...';
sudo umount $PIDRIVEP1;
sudo umount $PIDRIVEP2;
sudo rm -rf rootfs/;
