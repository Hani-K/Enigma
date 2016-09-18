#!/bin/bash

echo "***** Setting up Environment *****";

. ./env_setup1.sh ${1} || exit 1;

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
rm -rf $KERNELDIR/out;
rm -rf $KERNELDIR/output;

echo "";
echo "${bldcya}***** Removing Junk *****${txtrst}";
find . -name '*.orig' -delete
find . -name '*.rej' -delete
find . -name '*.bkp' -delete
find . -name '*.ko' -delete
find . -name '*.c.BACKUP.[0-9]*.c' -delete
find . -name '*.c.BASE.[0-9]*.c' -delete
find . -name '*.c.LOCAL.[0-9]*.c' -delete
find . -name '*.c.REMOTE.[0-9]*.c' -delete
find . -name '*.org' -delete
find . -name '*.*~' -delete
find . -name '*~' -delete
find . -name '*(копия)' -delete
find . -name 'clean-junk.sh' -delete
find . -name 'clean_kernel.sh' -delete
find . -name 'clean-kernel.sh' -delete
find . -name 'env_setup.sh' -delete
cp env_setup1.sh env_setup.sh

echo "${bldcya}***** Done *****${txtrst}";
