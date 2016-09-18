#!/bin/bash +x

# This build script by mcaserg (4PDA)
# For Note4 N910C custom kernel

clear
echo
echo

######################################## SETUP #########################################

# set variables
FIT=custom_defconfig
P=custom_defconfig_P
DTS=arch/arm/boot/dts
IMG=arch/arm/boot
DC=arch/arm/configs
BK=build_kernel
OUT=output
DT=exynos5433-tre_eur_open_16.dtb

# Cleanup old files from build environment
echo -n "Cleanup build environment.........................."
cd .. #move to source directory
rm -rf $BK/ramdisk/lib/modules/*.*
rm -rf $BK/ramdisk.cpio.gz
rm -rf $BK/zImage*
rm -rf $BK/boot*.img
rm -rf $BK/dt*.img
rm -rf $IMG/Image
rm -rf $DTS/.*.tmp
rm -rf $DTS/.*.cmd
rm -rf $DTS/*.dtb
rm -rf $OUT/skrn/*.img
rm -rf $OUT/*.zip
rm -rf $OUT/*.tar
rm -rf .config
echo "Done"

# Set build environment variables
echo -n "Set build variables................................"
export ARCH=arm
export SUBARCH=arm
export ccache=ccache
# export CROSS_COMPILE=/home/serg/arm-eabi-4.9/bin/arm-eabi-;
export CROSS_COMPILE=/home/serg/arm-eabi-6.0/bin/arm-eabi-;
export KCONFIG_NOTIMESTAMP=true
echo "Done"
echo

#################################### DEFCONFIG CHECKS #####################################

echo -n "Checking for FIT defconfig........................."
if [ -f "$DC/$FIT" ]; then
	echo "Found - FIT"
else
	echo "Not Found - Reset"
	cp $BK/$FIT $DC/$FIT
fi

# Ask if we want to xconfig or just compile
echo
read -p "Do you want to xconfig or just compile? (x/c)  > " xc
if [ "$xc" = "X" -o "$xc" = "x" ]; then
	echo
	# Make and xconfig our defconfig
	echo -n "Loading xconfig (FIT).............................."
	cp $DC/$FIT .config
	xterm -e make ARCH=arm xconfig
	echo "Done"
	mv .config $DC/$FIT
fi
echo

#################################### IMAGE COMPILATION #####################################

echo -n "Compiling Kernel (FIT)............................."
cp $DC/$FIT .config
xterm -e make ARCH=arm -j4
if [ -f "arch/arm/boot/zImage" ]; then
	echo "Done"
	# Copy the compiled image to the build_kernel directory
	mv $IMG/zImage $BK/zImage
else
	clear
	echo
	echo "Compilation failed on FIT kernel !"
	echo
	while true; do
    		read -p "Do you want to run a Make command to check the error?  (y/n) > " yn
    		case $yn in
        		[Yy]* ) make; echo ; exit;;
        		[Nn]* ) echo; exit;;
        	 	* ) echo "Please answer yes or no.";;
    		esac
	done
fi

# compile, depmod, then move all modules to the ramdisk
xterm -e make INSTALL_MOD_PATH=.. modules_install
xterm -e find -name '*.ko' -exec cp -av {} $BK/ramdisk/lib/modules/ \; 

###################################### DT.IMG GENERATION #####################################

echo -n "Build dt.img......................................."

./tools/dtbtool -o $BK/dt.img -s 2048 -p ./scripts/dtc/ $DTS/ | sleep 1
# get rid of the temps in dts directory
rm -rf $DTS/.*.tmp
rm -rf $DTS/.*.cmd
rm -rf $DTS/*.dtb

# Calculate DTS size for all images and display on terminal output
du -k "$BK/dt.img" | cut -f1 >sizT
sizT=$(head -n 1 sizT)
rm -rf sizT
echo "$sizT Kb"

###################################### RAMDISK GENERATION #####################################

echo -n "Make Ramdisk archive..............................."
cd $BK/ramdisk
find .| cpio -o -H newc | lzma > ../ramdisk.cpio.gz

##################################### BOOT.IMG GENERATION #####################################

echo -n "Make boot.img......................................"
cd ..
./mkbootimg --kernel zImage --cmdline "" --board SYSMAGIC000K --base 0x10000000 --kernel_offset 0x00008000 --ramdisk_offset 0x01000000 --tags_offset 0x00000100 --pagesize 2048 --ramdisk ramdisk.cpio.gz --dt dt.img -o boot.img
# copy the final boot.img's to output directory ready for zipping
cp boot*.img /home/serg/note4/$OUT/
echo "Done"

######################################## ZIP GENERATION #######################################

echo -n "Creating flashable zip............................."
cd /home/serg/note4/$OUT #move to output directory
xterm -e zip -r custom_Kernel.zip *
echo "Done"

###################################### OPTIONAL SOURCE CLEAN ###################################

echo
cd /home/serg/note4
read -p "Do you want to Clean the source? (y/n) > " mc
if [ "$mc" = "Y" -o "$mc" = "y" ]; then
	xterm -e make clean
	xterm -e make mrproper
fi

############################################# CLEANUP ##########################################

cd /home/serg/note4/$BK
rm -rf ramdisk.cpio.gz
rm -rf zImage*
rm -rf boot*.img
rm -rf dt*.img

echo
echo "Build completed"
echo
#build script ends



