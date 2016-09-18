#!/system/bin/sh

# interactive governor
chown -R system:system /sys/devices/system/cpu/cpu0/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu0/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu0/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu1/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu1/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu1/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu2/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu2/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu2/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu3/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu3/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu3/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu4/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu4/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu4/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu5/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu5/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu5/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu6/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu6/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu6/cpufreq/interactive
chown -R system:system /sys/devices/system/cpu/cpu7/cpufreq/interactive
chmod -R 0666 /sys/devices/system/cpu/cpu7/cpufreq/interactive
chmod 0755 /sys/devices/system/cpu/cpu7/cpufreq/interactive

mount -o remount,rw /
mount -o remount,rw /system /system

#
# Synapse
#
busybox mount -t rootfs -o remount,rw rootfs
busybox chmod -R 755 /res/synapse
busybox ln -fs /res/synapse/uci /sbin/uci
/sbin/uci

# e/frandom permissions
chmod 444 /dev/erandom
chmod 444 /dev/frandom

mkdir -p /mnt/ntfs
chmod 777 /mnt/ntfs
mount -o mode=0777,gid=1000 -t tmpfs tmpfs /mnt/ntfs


mount -o remount,rw /
mount -o rw,remount /system

iptables -t mangle -A POSTROUTING -o rmnet+ -j TTL --ttl-set 64

mount -t rootfs -o remount,ro rootfs
mount -o remount,ro /system /system
mount -o remount,rw /data
