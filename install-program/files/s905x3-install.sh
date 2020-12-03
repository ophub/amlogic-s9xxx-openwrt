#!/bin/sh
#======================================================================================
# https://github.com/ophub/amlogic-s9xxx-kernel-for-openwrt
# Description: Automatically Packaged OpenWrt for S905x3-Boxs
# Function: Install and Upgrading openwrt to the emmc for S905x3-Boxs
# Copyright (C) 2020 Flippy's kernrl files for amlogic-s9xxx
# Copyright (C) 2020 https://github.com/tuanqing/mknop
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-kernel-for-openwrt
#======================================================================================

SKIP1=64
BOOT=256
ROOT1=1024
SKIP2=258
ROOT2=1024

TARGET_SHARED_FSTYPE=f2fs

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
-------------------------------------------------------------------------------------
Please select S905x3 box model:
1. X96-Max+        [Standard] [ S905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz ]
2. HK1-Box         [Standard] [ S905x3: NETWORK: 1000M / TF: 25Mtz / CPU: 2124Mtz ]
3. H96-Max-X3      [Standard] [ S905x3: NETWORK: 1000M / TF: 50Mtz / CPU: 2124Mtz ]
4. X96-Max-4G      [Standard] [ S905x2: NETWORK: 1000M / TF: 50Mtz / CPU: 1944Mtz ]
5. X96-Max-2G      [Standard] [ S905x2: NETWORK: 100M  / TF: 50Mtz / CPU: 1944Mtz ]
6. X96-Max+        [Beta]     [ S905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2244Mtz ]
7. HK1-Box         [Beta]     [ S905x3: NETWORK: 1000M / TF: 25Mtz / CPU: 2184Mtz ]
8. H96-Max-X3      [Beta]     [ S905x3: NETWORK: 1000M / TF: 50Mtz / CPU: 2208Mtz ]
9. Octopus-Planet  [Standard] [ S905x3: NETWORK: 1000M / TF: 30Mtz / CPU: 2124Mtz ]

0. Other           [ Enter the dtb file name ]
-------------------------------------------------------------------------------------
EOF
echo  "Please choose:"
read  boxtype
case  $boxtype in
      1) FDTFILE="meson-sm1-x96-max-plus.dtb"
         U_BOOT_EXT=1
         ;;
      2) FDTFILE="meson-sm1-hk1box-vontar-x3.dtb"
         U_BOOT_EXT=1
         ;;
      3) FDTFILE="meson-sm1-h96-max-x3.dtb"
         U_BOOT_EXT=1
         ;;
      4) FDTFILE="meson-g12a-x96-max.dtb"
         ;;
      5) FDTFILE="meson-g12a-x96-max-rmii.dtb"
         ;;
      6) FDTFILE="meson-sm1-x96-max-plus-oc.dtb"
         U_BOOT_EXT=1
         ;;
      7) FDTFILE="meson-sm1-hk1box-vontar-x3-oc.dtb"
         U_BOOT_EXT=1
         ;;
      8) FDTFILE="meson-sm1-h96-max-x3-oc.dtb"
         U_BOOT_EXT=1
         ;;
      9) FDTFILE="meson-gxm-octopus-planet.dtb"
         U_BOOT_EXT=1
         ;;
      0) cat <<EOF
Please enter the dtb file name, do not include the path.
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
    echo "You can download the .dtb file from [ https://github.com/ophub/op/tree/main/router/s905x3_phicomm-n1/armbian/dtb-amlogic ]"
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

fdisk /dev/$EMMC_NAME < /tmp/fdisk.script
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
mkfs.fat -F 32 -n "EMMC_BOOT" /dev/${EMMC_NAME}p1 >/dev/null
mkdir -p /mnt/${EMMC_NAME}p1
sleep 2
umount -f /mnt/${EMMC_NAME}p1 2>/dev/null

echo "format rootfs1 partiton..."
mkfs.ext4 -F -L "EMMC_ROOTFS1" -m 0 /dev/${EMMC_NAME}p2  >/dev/null
mkdir -p /mnt/${EMMC_NAME}p2
sleep 2
umount -f /mnt/${EMMC_NAME}p2 2>/dev/null

echo "format rootfs2 partiton..."
mkfs.ext4 -F -L "EMMC_ROOTFS2" -m 0 /dev/${EMMC_NAME}p3 >/dev/null
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
APPEND=root=LABEL=ROOTFS console=ttyAML0,115200n8 console=tty0 no_console_suspend consoleblank=0 fsck.fix=yes fsck.repair=yes net.ifnames=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1
EOF
	
        uuid=$(blkid /dev/${EMMC_NAME}p2 | awk '{ print $3 }' | cut -d '"' -f 2)
        echo "uuid is: [ $uuid ]"
        if [ "$uuid" ]; then
           sed -i "s/LABEL=ROOTFS/UUID=$uuid/" uEnv.txt
        else
           sed -i 's/ROOTFS/EMMC_ROOTFS1/' uEnv.txt
        fi

        rm -f s905_autoscript* aml_autoscript*
        if [ $U_BOOT_EXT -eq 1 ]; then
           [ -f u-boot.sd ] && cp u-boot.sd u-boot.emmc
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
    mount -t ext4 /dev/${EMMC_NAME}p2 /mnt/${EMMC_NAME}p2 2>/dev/null
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
	rm -rf opt/docker && ln -sf /mnt/${EMMC_NAME}p4/docker/ opt/docker
        echo "Copy complete."
		
        echo "Edit configuration file ..."

        cd /mnt/${EMMC_NAME}p2/etc/rc.d
        ln -sf ../init.d/dockerd S99dockerd

        cd /mnt/${EMMC_NAME}p2/etc/config
        cp fstab.bak fstab
        echo "edit fstab..."
        sed -i "s/'BOOT'/'EMMC_BOOT'/" fstab
        if [ "$uuid" ]; then
            sed -i -e '/ROOTFS/ s/label/uuid/' fstab
            sed -i "s/ROOTFS/$uuid/" fstab
        else
            sed -i 's/ROOTFS/EMMC_ROOTFS1/' fstab
        fi

        macaddr=$(uuidgen | md5sum | sed 's/^\(..\)\(..\)\(..\)\(..\)\(..\).*$/fc:\1:\2:\3:\4:\5/')
        [ "$macaddr" ] && {
            (
                cd /lib/firmware/brcm
                sdio="brcmfmac43455-sdio.phicomm,n1.txt"
                [ -f $sdio ] || ln -s brcmfmac43455-sdio.txt $sdio
                sed -i "s/macaddr=b8:27:eb:74:f2:6c/macaddr=$macaddr/" $sdio
            )
        }

        cd /
        umount -f /mnt/${EMMC_NAME}p2
        break
    fi
done
echo "complete."

echo "Create a shared file system: format to [ ext4 ] ... "
mkfs.ext4 -F -L "EMMC_SHARED"  -m 0 /dev/${EMMC_NAME}p4 >/dev/null
mount -t ext4 /dev/${EMMC_NAME}p4 /mnt/${EMMC_NAME}p4
mkdir -p /mnt/${EMMC_NAME}p4/docker
echo "complete."

echo "Note: The original bootloader has been exported to [ /root/backup-bootloader.img ], please download and save!"
echo "Install completed, please [ reboot ] the system!"
sync
exit 0

