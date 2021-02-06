#!/bin/sh
#======================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Packaged OpenWrt for S9xxx-Boxs
# Function: Install and Upgrading openwrt to the emmc for S9xxx-Boxs
# Copyright (C) 2020 Flippy
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-openwrt
#======================================================================================

SKIP1=64
# you can change BOOT size ≥ 72
BOOT=256
# you can change ROOT1 size ≥ 320
ROOT1=1024
SKIP2=258
# you can change ROOT2 size ≥ 320
ROOT2=1024
# shared partition can be ext4, xfs, btrfs, f2fs
TARGET_SHARED_FSTYPE=btrfs

hasdrives=$(lsblk | grep -oE '(mmcblk[0-9])' | sort | uniq)
if [ "$hasdrives" = "" ]; then
    echo "No EMMC or SD devices were found in this system!!! "
    exit 1
fi

avail=$(lsblk | grep -oE '(mmcblk[0-9]|sda[0-9])' | sort | uniq)
if [ "$avail" = "" ]; then
    echo "The system did not find any available disk devices!!!"
    exit 1
fi

runfrom=$(lsblk | grep -e '/$' | grep -oE '(mmcblk[0-9]|sda[0-9])')
if [ "$runfrom" = "" ]; then
    echo "Root file system not found!!! "
    exit 1
fi

emmc=$(echo $avail | sed "s/$runfrom//" | sed "s/sd[a-z][0-9]//g" | sed "s/ //g")
if [ "$emmc" = "" ]; then
    echo "No idle EMMC equipment is found, or the system is already running on EMMC equipment!!!"
    exit 1
fi

if [ "$runfrom" = "$avail" ]; then
    echo "Your system is already running on the EMMC device!!! "
    exit 1
fi

if [ $runfrom = $emmc ]; then
    echo "Your system is already running on the EMMC device!!! "
    exit 1
fi

if [ "$(echo $emmc | grep mmcblk)" = "" ]; then
    echo "There seems to be no EMMC device on your system!!! "
    exit 1
fi

# EMMC DEVICE NAME
EMMC_NAME="$emmc"
EMMC_DEVPATH="/dev/$EMMC_NAME"
echo $EMMC_DEVPATH
EMMC_SIZE=$(lsblk -l -b -o NAME,SIZE | grep ${EMMC_NAME} | sort | uniq | head -n1 | awk '{print $2}')
echo "$EMMC_NAME : $EMMC_SIZE bytes"

ROOT_NAME=$(lsblk -l -o NAME,MAJ:MIN,MOUNTPOINT | grep -e '/$' | awk '{print $1}')
echo "ROOTFS: $ROOT_NAME"

BOOT_NAME=$(lsblk -l -o NAME,MAJ:MIN,MOUNTPOINT | grep -e '/boot$' | awk '{print $1}')
echo "BOOT: $BOOT_NAME"

FDTFILE="meson-sm1-x96-max-plus.dtb"
U_BOOT_EXT=0
cat <<EOF
---------------------------------------------------------------------
Please select s9xxx box model:
1. X96-Max+ ------------- [ S905x3 / NETWORK: 1000M / CPU: 2124Mtz ]
2. X96-Max+ ------------- [ S905x3 / NETWORK: 1000M / CPU: 2208Mtz ]
3. HK1-Box -------------- [ S905x3 / NETWORK: 1000M / CPU: 2124Mtz ]
4. HK1-Box -------------- [ S905x3 / NETWORK: 1000M / CPU: 2184Mtz ]
5. H96-Max-X3 ----------- [ S905x3 / NETWORK: 1000M / CPU: 2124Mtz ]
6. H96-Max-X3 ----------- [ S905x3 / NETWORK: 1000M / CPU: 2208Mtz ]
7. X96-Max-4G ----------- [ S905x2 / NETWORK: 1000M / CPU: 1944Mtz ]
8. X96-Max-2G ----------- [ S905x2 / NETWORK: 100M  / CPU: 1944Mtz ]
9. Octopus-Planet ------- [ S912   / NETWORK: 1000M / CPU: 2124Mtz ]
10. Belink-GT-King ------ [ S922x  / NETWORK: 1000M / CPU: 2124Mtz ]
11. Belink-GT-King-Pro -- [ S922x  / NETWORK: 1000M / CPU: 2124Mtz ]
12. UGOOS-AM6-Plus ------ [ S922x  / NETWORK: 1000M / CPU: 2124Mtz ]

0. Other ---------------- [ Enter the dtb file name of your box ]
---------------------------------------------------------------------
EOF
echo  "Please choose:"
read  boxtype
case  $boxtype in
      1) FDTFILE="meson-sm1-x96-max-plus.dtb"
         U_BOOT_EXT=1
         ;;
      2) FDTFILE="meson-sm1-x96-max-plus-oc.dtb"
         U_BOOT_EXT=1
         ;;
      3) FDTFILE="meson-sm1-hk1box-vontar-x3.dtb"
         U_BOOT_EXT=1
         ;;
      4) FDTFILE="meson-sm1-hk1box-vontar-x3-oc.dtb"
         U_BOOT_EXT=1
         ;;
      5) FDTFILE="meson-sm1-h96-max-x3.dtb"
         U_BOOT_EXT=1
         ;;
      6) FDTFILE="meson-sm1-h96-max-x3-oc.dtb"
         U_BOOT_EXT=1
         ;;
      7) FDTFILE="meson-g12a-x96-max.dtb"
         U_BOOT_EXT=0
         ;;
      8) FDTFILE="meson-g12a-x96-max-rmii.dtb"
         U_BOOT_EXT=0
         ;;
      9) FDTFILE="meson-gxm-octopus-planet.dtb"
         U_BOOT_EXT=1
         ;;
      10) FDTFILE="meson-g12b-gtking.dtb"
         U_BOOT_EXT=1
         ;;
      11) FDTFILE="meson-g12b-gtking-pro.dtb"
         U_BOOT_EXT=1
         ;;
      12) FDTFILE="meson-g12b-ugoos-am6.dtb"
         U_BOOT_EXT=1
         ;;	 
      0) cat <<EOF
Please enter the dtb file name of your box, do not include the path.
For example: $FDTFILE
EOF
         echo  "dtb File name:"
         read  CUST_FDTFILE
         FDTFILE=$CUST_FDTFILE
         ;;
      *) echo "Input error, exit!"
         exit 1
         ;;
esac

if [  ! -f "/boot/dtb/amlogic/${FDTFILE}" ]; then
    echo "/boot/dtb/amlogic/${FDTFILE} does not exist!"
    echo "You can download the .dtb file from [ https://github.com/ophub/amlogic-s9xxx-openwrt/tree/main/amlogic-s9xxx/amlogic-dtb ]"
    echo "Copy it to [ /boot/dtb/amlogic/ ]."
    echo "Then execute this installation command."
    exit 1
fi

# backup old bootloader
if [ ! -f /root/backup-bootloader.img ]; then
    echo "Backup bootloader -> [ backup-bootloader.img ] ... "
    dd if=/dev/$EMMC_NAME of=/root/backup-bootloader.img bs=1M count=4 conv=fsync
    echo "Backup bootloader complete."
    echo
fi

swapoff -a

# umount all other mount points
MOUNTS=$(lsblk -l -o MOUNTPOINT)
for mnt in $MOUNTS; do
    if [ "$mnt" == "MOUNTPOINT" ]; then
        continue
    fi

    if [ "$mnt" == "" ]; then
        continue
    fi

    if [ "$mnt" == "/" ]; then
        continue
    fi

    if [ "$mnt" == "/boot" ]; then
        continue
    fi

    if [ "$mnt" == "/opt" ]; then
        continue
    fi
    
    if [ "$mnt" == "[SWAP]" ]; then
        echo "swapoff -a"
        swapoff -a
        continue
    fi

    if echo $mnt | grep $EMMC_NAME; then
        echo "umount -f $mnt"
        umount -f $mnt
        if [ $? -ne 0 ]; then
            echo "$mnt Cannot be uninstalled, the installation process is aborted."
            exit 1
        fi
    fi
done

# Delete old partition if exists
p=$(lsblk -l | grep -e "${EMMC_NAME}p" | wc -l)
echo "A total of [ $p ] old partitions on EMMC will be deleted"
>/tmp/fdisk.script
while [ $p -ge 1 ]; do
    echo "d" >> /tmp/fdisk.script
    if [ $p -gt 1 ]; then
      echo "$p" >> /tmp/fdisk.script
    fi
    p=$((p-1))
done

# Create new partition
DST_TOTAL_MB=$((EMMC_SIZE/1024/1024))

start1=$(( SKIP1 * 2048 ))
end1=$(( start1 + (BOOT * 2048) - 1 ))

start2=$(( end1 + 1 ))
end2=$(( start2 + (ROOT1 * 2048) -1 ))

start3=$(( (SKIP2 * 2048) + end2 + 1 ))
end3=$(( start3 + (ROOT2 * 2048) -1 ))

start4=$((end3 + 1 ))
end4=$(( DST_TOTAL_MB * 2048 -1 ))

cat >> /tmp/fdisk.script <<EOF
n
p
1
$start1
$end1
n
p
2
$start2
$end2
n
p
3
$start3
$end3
n
p
$start4
$end4
t
1
c
t
2
83
t
3
83
t
4
83
w
EOF

fdisk /dev/$EMMC_NAME < /tmp/fdisk.script 2>/dev/null
if [ $? -ne 0 ]; then
    echo "The fdisk partition fails, the backup bootloader will be restored, and then exit."
    dd if=/root/backup-bootloader.img of=/dev/$EMMC_NAME conf=fsync
    exit 1
fi
echo "Partition complete."

# write some zero data to part begin
seek=$((start1 / 2048))
dd if=/dev/zero of=/dev/${EMMC_NAME} bs=1M count=1 seek=$seek conv=fsync

seek=$((start2 / 2048))
dd if=/dev/zero of=/dev/${EMMC_NAME} bs=1M count=1 seek=$seek conv=fsync

seek=$((start3 / 2048))
dd if=/dev/zero of=/dev/${EMMC_NAME} bs=1M count=1 seek=$seek conv=fsync

seek=$((start4 / 2048))
dd if=/dev/zero of=/dev/${EMMC_NAME} bs=1M count=1 seek=$seek conv=fsync

BLDR=/lib/u-boot/hk1box-bootloader.img
if [ -f "${BLDR}" ]; then
    if echo "${FDTFILE}" | grep meson-sm1-x96-max-plus >/dev/null; then
        echo "Write new bootloader: [ ${BLDR} ] ..."
        dd if=${BLDR} of="/dev/${EMMC_NAME}" conv=fsync bs=1 count=442
        dd if=${BLDR} of="/dev/${EMMC_NAME}" conv=fsync bs=512 skip=1 seek=1
        sync
        echo "Write complete."
    fi
fi

# fix wifi macaddr
if [ -x /usr/bin/fix_wifi_macaddr.sh ]; then
    /usr/bin/fix_wifi_macaddr.sh
fi

# mkfs
echo "Start creating file system ... "
echo "Create a boot file system ... "

echo "format boot partiton..."
mkfs.fat -n EMMC_BOOT -F 32 /dev/${EMMC_NAME}p1
mkdir -p /mnt/${EMMC_NAME}p1
sleep 2
umount -f /mnt/${EMMC_NAME}p1 2>/dev/null

echo "format rootfs1 partiton..."
ROOTFS1_UUID=$(/usr/bin/uuidgen)
mkfs.btrfs -f -U ${ROOTFS1_UUID} -L EMMC_ROOTFS1 -m single /dev/${EMMC_NAME}p2
mkdir -p /mnt/${EMMC_NAME}p2
sleep 2
umount -f /mnt/${EMMC_NAME}p2 2>/dev/null

echo "format rootfs2 partiton..."
ROOTFS2_UUID=$(/usr/bin/uuidgen)
mkfs.btrfs -f -U ${ROOTFS2_UUID} -L EMMC_ROOTFS2 -m single /dev/${EMMC_NAME}p3
mkdir -p /mnt/${EMMC_NAME}p3
sleep 2
umount -f /mnt/${EMMC_NAME}p3 2>/dev/null

# mount and copy
echo "Wait for the boot file system to mount ... "
i=1
max_try=10
while [ $i -le $max_try ]; do
    mount -t vfat /dev/${EMMC_NAME}p1 /mnt/${EMMC_NAME}p1 2>/dev/null
    sleep 2
    mnt=$(lsblk -l -o MOUNTPOINT | grep /mnt/${EMMC_NAME}p1)

    if [ "$mnt" == "" ]; then
        if [ $i -lt $max_try ]; then
            echo "Not mounted successfully, try again ..."
            i=$((i+1))
        else
            echo "Cannot mount the boot file system, give up!"
            exit 1
        fi
    else
        echo "Successfully mounted."
        echo "copy boot ..."
        cd /mnt/${EMMC_NAME}p1
        rm -rf /boot/'System Volume Information/'
        (cd /boot && tar cf - .) | tar xf -
        sync

        echo "Edit uEnv.txt ..."
        cat > uEnv.txt <<EOF
LINUX=/zImage
INITRD=/uInitrd
FDT=/dtb/amlogic/${FDTFILE}
APPEND=root=UUID=${ROOTFS1_UUID} rootfstype=btrfs rootflags=compress=zstd console=ttyAML0,115200n8 console=tty0 no_console_suspend consoleblank=0 fsck.fix=yes fsck.repair=yes net.ifnames=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1
EOF

        rm -f s905_autoscript* aml_autoscript*

        if  [ -f u-boot-510kernel.bin ]; then
            cp -f -v u-boot-510kernel.bin u-boot.emmc
        elif  [ $U_BOOT_EXT -eq 1 ]; then
            cp -f -v u-boot.sd u-boot.emmc
        fi

        sync
        echo "complete."
        cd /
        umount -f /mnt/${EMMC_NAME}p1
        break
    fi
done
echo "complete."

echo "Wait for the rootfs file system to mount ... "
i=1
while [ $i -le $max_try ]; do
    mount -t btrfs -o compress=zstd /dev/${EMMC_NAME}p2 /mnt/${EMMC_NAME}p2 2>/dev/null
    sleep 2
    mnt=$(lsblk -l -o MOUNTPOINT | grep /mnt/${EMMC_NAME}p2)
    if [ "$mnt" == "" ]; then
        if [ $i -lt $max_try ]; then
            echo "Not mounted successfully, try again ..."
            i=$((i+1))
        else
            echo "Cannot mount rootfs file system, give up!"
            exit 1
        fi
    else
        echo "Successfully mounted"
        echo "Create folder ... "
        cd /mnt/${EMMC_NAME}p2
        mkdir -p bin boot dev etc lib opt mnt overlay proc rom root run sbin sys tmp usr www
        ln -sf lib/ lib64
        ln -sf tmp/ var
        echo "complete."
		
        COPY_SRC="root etc bin sbin lib opt usr www"
        echo "Copy data ... "
        for src in $COPY_SRC; do
            echo "copy [ $src ] ..."
            (cd / && tar cf - $src) | tar xf -
            sync
        done
        rm -rf opt/docker && ln -sf /mnt/${EMMC_NAME}p4/docker/ opt/docker >/dev/null
        rm -rf usr/bin/AdGuardHome && ln -sf /mnt/${EMMC_NAME}p4/AdGuardHome usr/bin/ >/dev/null
        echo "Copy complete."
		
        echo "Edit configuration file ..."
        #cd /mnt/${EMMC_NAME}p2/usr/bin/
        #rm -f s9xxx-install.sh s9xxx-update.sh
        cd /mnt/${EMMC_NAME}p2/etc/rc.d
        ln -sf ../init.d/dockerd S99dockerd
        cd /mnt/${EMMC_NAME}p2/etc
        cat > fstab <<EOF
UUID=${ROOTFS1_UUID} / btrfs compress=zstd 0 1
LABEL=EMMC_BOOT /boot vfat defaults 0 2
#tmpfs /tmp tmpfs defaults,nosuid 0 0
EOF

        cd /mnt/${EMMC_NAME}p2/etc/config
        cat > fstab <<EOF
config  global
        option anon_swap '0'
        option anon_mount '1'
        option auto_swap '0'
        option auto_mount '1'
        option delay_root '5'
        option check_fs '0'

config  mount
        option target '/overlay'
        option uuid '${ROOTFS1_UUID}'
        option enabled '1'
        option enabled_fsck '1'
        option fstype 'btrfs'
        option options 'compress=zstd'

config  mount
        option target '/boot'
        option label 'EMMC_BOOT'
        option enabled '1'
        option enabled_fsck '0'
        option fstype 'vfat'

EOF
        cd /
        umount -f /mnt/${EMMC_NAME}p2
        break
    fi
done
echo "complete."

echo "Create a shared file system."
mkdir -p /mnt/${EMMC_NAME}p4
case $TARGET_SHARED_FSTYPE in
	xfs) mkfs.xfs -f -L EMMC_SHARED /dev/${EMMC_NAME}p4 >/dev/null
	     mount -t xfs /dev/${EMMC_NAME}p4 /mnt/${EMMC_NAME}p4
	     ;;
      btrfs) mkfs.btrfs -f -L EMMC_SHARED -m single /dev/${EMMC_NAME}p4 >/dev/null
	     mount -t btrfs /dev/${EMMC_NAME}p4 /mnt/${EMMC_NAME}p4
	     ;;
       f2fs) mkfs.f2fs -f -l EMMC_SHARED /dev/${EMMC_NAME}p4 >/dev/null
	     mount -t f2fs /dev/${EMMC_NAME}p4 /mnt/${EMMC_NAME}p4
	     ;;
	  *) mkfs.ext4 -F -L EMMC_SHARED  /dev/${EMMC_NAME}p4 >/dev/null
	     mount -t ext4 /dev/${EMMC_NAME}p4 /mnt/${EMMC_NAME}p4
	     ;;
esac
mkdir -p /mnt/${EMMC_NAME}p4/docker /mnt/${EMMC_NAME}p4/AdGuardHome
sync
echo "complete."

echo "Note: The original bootloader has been exported to [ /root/backup-bootloader.img ], please download and save!"
echo "Install completed, please [ reboot ] the system!"

