#!/bin/bash

echo "***** Setting up Environment *****";

. ./env_setup.sh ${1} || exit 1;

echo "${bldcya}***** Cleaning in Progress *****${txtrst}";

make mrproper;
make clean;
rm -rf $INITRAMFS_TMP;
rm -f $KERNELDIR/r*.cpio
rm -f $KERNELDIR/ramdisk.gz
rm -f $KERNELDIR/zImage;
rm -f $KERNELDIR/out/zImage;
rm -f $KERNELDIR/out/boot.img;
rm -f $KERNELDIR/boot.img;
rm -f $KERNELDIR/dt.img;
rm -rf $KERNELDIR/out/system/lib/modules;
rm -rf $KERNELDIR/out/tmp_modules;
rm -f $KERNELDIR/out/Chaos-Kernel_*;
rm -rf $KERNELDIR/tmp;

find . -type f \( -iname \*.rej \
				-o -iname \*.orig \
				-o -iname \*.bkp \
				-o -iname \*.ko \
				-o -iname \*.c.BACKUP.[0-9]*.c \
				-o -iname \*.c.BASE.[0-9]*.c \
				-o -iname \*.c.LOCAL.[0-9]*.c \
				-o -iname \*.c.REMOTE.[0-9]*.c \
				-o -iname \*.org \) \
					| parallel rm -fv {};

echo "${bldcya}***** Cleaning Done *****${txtrst}";


