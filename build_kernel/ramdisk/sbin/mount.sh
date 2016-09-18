#!/sbin/busybox sh

mkdir /dev
mkdir /dev/block
mknod /dev/block/mmcblk0p18 b 259 10
mknod /dev/block/mmcblk0p19 b 259 11
mknod /dev/block/mmcblk0p21 b 259 13

#Trying to partitions mounting etc

mount -t ext4 /dev/block/mmcblk0p19 /cache
if ! grep -q /cache /proc/mounts ; then
echo "mounting /cache with ext4 failed, trying f2fs..."
mount -t f2fs /dev/block/mmcblk0p19 /cache
fi
mount -t ext4 /dev/block/mmcblk0p18 /system
if ! grep -q /system /proc/mounts ; then
echo "mounting /system with ext4 failed, trying f2fs..."
mount -t f2fs /dev/block/mmcblk0p18 /system
fi
mount -t ext4 /dev/block/mmcblk0p21 /data
if ! grep -q /data /proc/mounts ; then
echo "mounting /data with ext4 failed, trying f2fs..."
mount -t f2fs /dev/block/mmcblk0p21 /data
fi

# remount partitions with noatime
for k in $(mount | grep relatime | cut -d " " -f3);
do
mount -o remount,noatime,nodiratime,noauto_da_alloc,barrier=0 $k
done;

