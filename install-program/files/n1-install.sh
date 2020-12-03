#!/bin/sh
#===================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for PHICOMM N1
# Function: Install the openwrt system to the emmc storage for PHICOMM N1
# Copyright (C) 2020 Flippy
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-openwrt
#===================================================================================

# you can change this size >= 72
TARGET_BOOT_SIZE_MB=256
# you can change this size >= 320
TARGET_ROOTFS_SIZE_MB=1024
# shared partition can be ext4, xfs, btrfs
TARGET_SHARED_FSTYPE=btrfs

# EMMC DEVICE MAJOR
DST_MAJ=179

DST_NAME=$(lsblk -l -b -I $DST_MAJ -o NAME,MAJ:MIN,SIZE | grep "${DST_MAJ}:0" | awk '{print $1}')
DST_SIZE=$(lsblk -l -b -I $DST_MAJ -o NAME,MAJ:MIN,SIZE | grep "${DST_MAJ}:0" | awk '{print $3}')
#echo $DST_NAME $DST_SIZE

ROOT_NAME=$(lsblk -l -o NAME,MAJ:MIN,MOUNTPOINT | grep -e '/$' | awk '{print $1}')
ROOT_MAJ=$(lsblk -l -o NAME,MAJ:MIN,MOUNTPOINT | grep -e '/$' | awk '{print $2}' | awk -F ':' '{print $1}')
#echo $ROOT_NAME $ROOT_MAJ

BOOT_NAME=$(lsblk -l -o NAME,MAJ:MIN,MOUNTPOINT | grep -e '/boot$' | awk '{print $1}')
BOOT_MAJ=$(lsblk -l -o NAME,MAJ:MIN,MOUNTPOINT | grep -e '/boot$' | awk '{print $2}' | awk -F ':' '{print $1}')
#echo $BOOT_NAME $BOOT_MAJ

if  [ "$BOOT_MAJ" == "$DST_MAJ" ]; then
    echo "the boot is on emmc, cannot install!"
    exit 1
else
    if  [ "$ROOT_MAJ" == "$DST_MAJ" ]; then
        echo "the rootfs is on emmc, cannot install!"
        exit 1
    fi
fi

echo "The following steps will overwrite the original data, please be sure to confirm!"
echo "Remind again, remember to back up your important data!"
echo -ne "Select y to install openwrt to emmc disk, are you sure?  y/n [n]\b\b"
read yn
case $yn in 
      y|Y) yn='y';;
      *)   yn='n';;
esac

if [ "$yn" == "n" ]; then
    echo "Bye bye!"
    exit 0
fi

# backup old bootloader
if  [ ! -f /root/bootloader-backup.bin ]; then
    echo -n "backup the bootloader ->  bootloader-backup.bin ... "
    dd if=/dev/$DST_NAME of=/root/bootloader-backup.bin bs=1M count=4
    sync
    echo "done"
fi

# swapoff -a
swapoff -a

# umount all other mount points
MOUNTS=$(lsblk -l -o MOUNTPOINT)
for mnt in $MOUNTS; do
    if  [ "$mnt" == "MOUNTPOINT" ]; then
        continue
    fi

    if  [ "$mnt" == "" ]; then
        continue
    fi

    if  [ "$mnt" == "/" ]; then
        continue
    fi

    if  [ "$mnt" == "/boot" ]; then
        continue
    fi

    if  [ "$mnt" == "[SWAP]" ]; then
        echo "swapoff -a"
        swapoff -a
        continue
    fi

    echo "umount -f $mnt"
    umount -f $mnt
    if  [ $? -ne 0 ]; then
        echo "$mnt can not be umount, install abort"
        exit 1
    fi
done

# Delete old partition if exists
p=$(lsblk -l | grep -e "${DST_NAME}p" | wc -l)
echo "total $p partions will be deleted"
>/tmp/fdisk.script
while [ $p -ge 1 ];do
      echo "d" >> /tmp/fdisk.script
      if  [ $p -gt 1 ]; then
          echo "$p" >> /tmp/fdisk.script
      fi
      p=$((p-1))
done

# Create new partition
SKIP_MB=700
DST_TOTAL_MB=$((DST_SIZE/1024/1024))

start1=$(( SKIP_MB * 2048 ))
end1=$(( start1 + (TARGET_BOOT_SIZE_MB * 2048) - 1 ))

start2=$(( end1 + 1 ))
end2=$(( start2 + (TARGET_ROOTFS_SIZE_MB * 2048) -1 ))

start3=$(( end2 + 1 ))
end3=$(( DST_TOTAL_MB * 2048 -1 ))

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
t
1
c
t
2
83
t
3
83
w
q
EOF

# write some zero data to part begin
seek=$((start1 / 2048))
dd if=/dev/zero of=/dev/${DST_NAME} bs=1M count=1 seek=$seek
sync

seek=$((start2 / 2048))
dd if=/dev/zero of=/dev/${DST_NAME} bs=1M count=1 seek=$seek
sync

seek=$((start3 / 2048))
dd if=/dev/zero of=/dev/${DST_NAME} bs=1M count=1 seek=$seek
sync

fdisk /dev/$DST_NAME < /tmp/fdisk.script
if  [ $? -ne 0 ]; then
    echo "fdisk failed, restore the backup bootloader, and abort."
    dd if=/root/bootloader-backup.bin of=/dev/$DST_NAME
    sync
    exit 1
fi
echo "fdisk done"
echo

BLDR_ORIG=/root/u-boot-2015-phicomm-n1.bin
if  [ -f "${BLDR_ORIG}" ]; then
    dd if=${BLDR_ORIG} of="${DST_NAME}" conv=fsync bs=1 count=442
    dd if=${BLDR_ORIG} of="${DST_NAME}" conv=fsync bs=512 skip=1 seek=1
    sync
fi

# fix wifi macaddr
if  [ -x /usr/bin/fix_wifi_macaddr.sh ]; then
    /usr/bin/fix_wifi_macaddr.sh
fi

# mkfs
echo "begin to create filesystems ... "
echo "create boot filesystem ... "
mkfs.fat -n EMMC_BOOT -F 32 /dev/${DST_NAME}p1
mkdir -p /mnt/${DST_NAME}p1
sleep 2
umount -f /mnt/${DST_NAME}p1 2>/dev/null

echo "create rootfs filesystems ... "
ROOTFS_UUID=$(/usr/bin/uuidgen)
mkfs.btrfs -f -U ${ROOTFS_UUID} -L EMMC_ROOTFS -m single /dev/${DST_NAME}p2
mkdir -p /mnt/${DST_NAME}p2
sleep 2
umount -f /mnt/${DST_NAME}p2 2>/dev/null
echo "filesystem succeed created!"

# mount and copy
echo "wait for boot partition mounted ... "
i=1
max_try=10
while [ $i -le $max_try ]; do
      mount -t vfat /dev/${DST_NAME}p1 /mnt/${DST_NAME}p1 2>/dev/null
      sleep 2
      mnt=$(lsblk -l -o MOUNTPOINT | grep /mnt/${DST_NAME}p1)
      if [ "$mnt" == "" ]; then
            if [ $i -lt $max_try ]; then
                  echo "can not mount boot partition, try again ..."
                  i=$((i+1))
            else
                  echo "can not mount boot partition, abort!"
                  exit 1
            fi
      else
            echo "mount ok"
            echo -n "copy boot ..."
            cd /mnt/${DST_NAME}p1
            rm -rf /boot/'System Volume Information/'
            (cd /boot && tar cf - .) | tar mxf -
            sync
            echo "done"
            echo -n "Write uEnv.txt ... "
            lines=$(wc -l < /boot/uEnv.txt)
            lines=$((lines-1))
            head -n $lines /boot/uEnv.txt > uEnv.txt
            cat >> uEnv.txt <<EOF
APPEND=root=UUID=${ROOTFS_UUID} rootfstype=btrfs rootflags=compress=zstd console=ttyAML0,115200n8 console=tty0 no_console_suspend consoleblank=0 fsck.fix=yes fsck.repair=yes net.ifnames=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1
EOF

            rm -f s905_autoscript* aml_autoscript*
            sync
            echo "done."
            cd /
            umount -f /mnt/${DST_NAME}p1
            break
      fi
done
echo "done" 

echo "wait for root partition mounted ... "
i=1
while [ $i -le $max_try ]; do
        mount -t btrfs -o compress=zstd /dev/${DST_NAME}p2 /mnt/${DST_NAME}p2 2>/dev/null
        sleep 2
        mnt=$(lsblk -l -o MOUNTPOINT | grep /mnt/${DST_NAME}p2)
        if [ "$mnt" == "" ]; then
              if [ $i -lt $max_try ]; then
                    echo "can not mount root partition, try again ..."
                    i=$((i+1))
              else
                    echo "can not mount root partition, abort!"
                    exit 1
              fi
        else
              echo "mount ok"
              echo -n "make dirs ... "
              cd /mnt/${DST_NAME}p2
              mkdir -p bin boot dev etc lib opt mnt overlay proc rom root run sbin sys tmp usr www
              ln -sf lib/ lib64
              ln -sf tmp/ var
              echo "done"

              COPY_SRC="root etc bin sbin lib opt usr www"
              echo "copy data ... "
              for src in $COPY_SRC;do
                    echo -n "copy $src ... "
                    (cd / && tar cf - $src) | tar mxf -
                    sync
                    echo "done"
              done
              rm -rf opt/docker && ln -sf /mnt/${DST_NAME}p3/docker/ opt/docker
              echo "copy done"

              echo -n "Edit other config files ... "
              cd /mnt/${DST_NAME}p2/root
              #rm -f inst-to-emmc.sh update-to-emmc.sh
              cd /mnt/${DST_NAME}p2/etc/rc.d
              ln -sf ../init.d/dockerd S99dockerd
              cd /mnt/${DST_NAME}p2/etc
              cat > fstab <<EOF
UUID=${ROOTFS_UUID} / btrfs compress=zstd 0 1
LABEL=EMMC_BOOT /boot vfat defaults 0 2
#tmpfs /tmp tmpfs defaults,nosuid 0 0
EOF

              cd /mnt/${DST_NAME}p2/etc/config
              cat > fstab <<EOF
config global
        option anon_swap '0'
        option anon_mount '1'
        option auto_swap '0'
        option auto_mount '1'
        option delay_root '5'
        option check_fs '0'

config mount
        option target '/overlay'
        option uuid '${ROOTFS_UUID}'
        option enabled '1'
        option enabled_fsck '1'
        option fstype 'btrfs'
        option options 'compress=zstd'

config mount
        option target '/boot'
        option label 'EMMC_BOOT'
        option enabled '1'
        option enabled_fsck '0'
        option fstype 'vfat'

EOF
              cd /
              umount -f /mnt/${DST_NAME}p2
              break
        fi
done
echo "done" 

echo "create shared filesystem ... "
mkdir -p /mnt/${DST_NAME}p3
case  $TARGET_SHARED_FSTYPE in
      xfs) mkfs.xfs -f -L EMMC_SHARED /dev/${DST_NAME}p3
           mount -t xfs /dev/${DST_NAME}p3 /mnt/${DST_NAME}p3
           ;;
    btrfs) mkfs.btrfs -L EMMC_SHARED /dev/${DST_NAME}p3
           mount -t btrfs /dev/${DST_NAME}p3 /mnt/${DST_NAME}p3
           ;;
        *) mkfs.ext4 -L EMMC_SHARED  /dev/${DST_NAME}p3
           mount -t ext4 /dev/${DST_NAME}p3 /mnt/${DST_NAME}p3
           ;;
esac
sleep 1
[ -d /mnt/${DST_NAME}p3 ] || ( mkdir -p /mnt/${DST_NAME}p3 && mount /dev/${DST_NAME}p3 /mnt/${DST_NAME}p3 )
mkdir -p /mnt/${DST_NAME}p3/docker
if  [ -f /mnt/${DST_NAME}p2/etc/config/AdGuardHome ]; then
    mkdir -p /mnt/${DST_NAME}p3/AdGuardHome/data
    rm -rf /mnt/${DST_NAME}p2/usr/bin/AdGuardHome
    ln -sf /mnt/${DST_NAME}p3/AdGuardHome /mnt/${DST_NAME}p2/usr/bin/AdGuardHome
fi
echo "done"

echo "All done, please [ reboot ] Phicomm-N1."

