#!/bin/sh
QEMU_MAKE_ROOT=`pwd`
IMG_NAME=$QEMU_MAKE_ROOT/test.img
KERNEL_VER=linux-2.6.38
KERNEL_IMG_NAME=$QEMU_MAKE_ROOT/$KERNEL_VER/arch/i386/boot/bzImage
HD_IMG_NAME=$QEMU_MAKE_ROOT/hd.img
GRUB_IMG_NAME=$QEMU_MAKE_ROOT/grub-0.97-i386-pc
MNT_DIR=/mnt/rootfs
LOOPDEV=$(losetup -f)
NOWTIME=`date -u`

CYLINDERS=32


HEADERS=16
SECTORS=63
SECTORSIZE=512
BLOCKSIZE=1024

COUNT=`expr $HEADERS \* $CYLINDERS \* $SECTORS \* $SECTORSIZE / $BLOCKSIZE`
MOUNTOFFSET=`expr $SECTORS \* $SECTORSIZE`

rm -fr $IMG_NAME

dd if=/dev/zero of=$IMG_NAME bs=$BLOCKSIZE count=$COUNT
losetup $LOOPDEV  $IMG_NAME
fdisk $IMG_NAME<<EOF
x
c
$CYLINDERS
h
$HEADERS
s
$SECTORS
r
n
p
1
1
$CYLINDERS
a
1
w
EOF
losetup -d $LOOPDEV


#make the  hd.img
dd if=/dev/zero of=$HD_IMG_NAME bs=$BLOCKSIZE count=10240
mke2fs -F  $HD_IMG_NAME
mount -o loop $HD_IMG_NAME $MNT_DIR
cp -fr rootfs/* $MNT_DIR
rm -fr $MNT_DIR/bin
rm -fr $MNT_DIR/sbin
cd $QEMU_MAKE_ROOT/busybox-1.18.4
make CONFIG_PREFIX=$MNT_DIR/ install
cd $QEMU_MAKE_ROOT
umount $MNT_DIR


losetup -o $MOUNTOFFSET $LOOPDEV $IMG_NAME
mke2fs $LOOPDEV
mount $LOOPDEV $MNT_DIR

cp $KERNEL_IMG_NAME $MNT_DIR
cp $HD_IMG_NAME  $MNT_DIR
mkdir $MNT_DIR/boot
mkdir $MNT_DIR/boot/grub
cp -fr $GRUB_IMG_NAME/boot/grub/* $MNT_DIR/boot/grub
touch $MNT_DIR/boot/grub/menu.lst
echo 'default 0' >> $MNT_DIR/boot/grub/menu.lst
echo 'timeout 0' >> $MNT_DIR/boot/grub/menu.lst
echo 'title linux by ramen '$NOWTIME >> $MNT_DIR/boot/grub/menu.lst
echo 'root (hd0,0)' >> $MNT_DIR/boot/grub/menu.lst
echo 'kernel (hd0,0)/bzImage root=/dev/ram rw load_ramdisk=1 init=linuxrc console=ttyS0,115200n8' >> $MNT_DIR/boot/grub/menu.lst
echo 'initrd (hd0,0)/hd.img' >> $MNT_DIR/boot/grub/menu.lst

umount $MNT_DIR

cat <<EOF | grub --batch --device-map=/dev/null
device (hd0) $IMG_NAME 
root (hd0,0)
setup (hd0)
quit
EOF


losetup -d $LOOPDEV
