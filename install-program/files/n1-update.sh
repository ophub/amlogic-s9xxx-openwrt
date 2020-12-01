#!/bin/sh
#======================================================================================
# https://github.com/ophub/openwrt-kernel-for-amlogic-s9xxx
# Description: Automatically Packaged OpenWrt for Phicomm-N1
# Function: Install and Upgrading openwrt to the emmc for Phicomm-N1
# Copyright (C) 2020 Flippy's kernrl files for amlogic-s9xxx
# Copyright (C) 2020 https://github.com/tuanqing/mknop
# Copyright (C) 2020 https://github.com/ophub/openwrt-kernel-for-amlogic-s9xxx
#======================================================================================

# EMMC DEVICE MAJOR
DST_MAJ=179

DST_NAME=$(lsblk -l -b -I $DST_MAJ -o NAME,MAJ:MIN,SIZE | grep "${DST_MAJ}:0" | awk '{print $1}')
DST_SIZE=$(lsblk -l -b -I $DST_MAJ -o NAME,MAJ:MIN,SIZE | grep "${DST_MAJ}:0" | awk '{print $3}')

ROOT_NAME=$(lsblk -l -o NAME,MAJ:MIN,MOUNTPOINT | grep -e '/$' | awk '{print $1}')
ROOT_MAJ=$(lsblk -l -o NAME,MAJ:MIN,MOUNTPOINT | grep -e '/$' | awk '{print $2}' | awk -F ':' '{print $1}')

BOOT_NAME=$(lsblk -l -o NAME,MAJ:MIN,MOUNTPOINT | grep -e '/boot$' | awk '{print $1}')
BOOT_MAJ=$(lsblk -l -o NAME,MAJ:MIN,MOUNTPOINT | grep -e '/boot$' | awk '{print $2}' | awk -F ':' '{print $1}')

if  [ "$BOOT_MAJ" == "$DST_MAJ" ];then
    echo "The boot is on emmc, cannot update!"
    exit 1
else
    if  [ "$ROOT_MAJ" == "$DST_MAJ" ];then
        echo "The rootfs is on emmc, cannot update!"
        exit 1
    fi
fi

# backup old bootloader
if  [ ! -f bootloader-backup.bin ];then
    echo "Backup the bootloader ->  bootloader-backup.bin ... "
    dd if=/dev/$DST_NAME of=bootloader-backup.bin bs=1M count=4
    sync
fi

# swapoff -a
swapoff -a

# umount all other mount points
MOUNTS=$(lsblk -l -o MOUNTPOINT)
for mnt in $MOUNTS;do
    if  [ "$mnt" == "MOUNTPOINT" ];then
        continue
    fi

    if  [ "$mnt" == "" ];then
        continue
    fi

    if  [ "$mnt" == "/" ];then
        continue
    fi

    if  [ "$mnt" == "/boot" ];then
        continue
    fi

    if  [ "$mnt" == "/opt" ];then
        continue
    fi

    if  [ "$mnt" == "[SWAP]" ];then
        echo "Swapoff -a"
        swapoff -a
        continue
    fi

    echo "Umount -f [ $mnt ]"
    umount -f $mnt
    if  [ $? -ne 0 ];then
        echo "Can not be umount [ $mnt  ], update abort."
        exit 1
    fi

    sleep 1
    # force umount again
    umount -f $mnt 2>/dev/null
done

# fix wifi macaddr
if  [ -x /usr/bin/fix_wifi_macaddr.sh ];then
    /usr/bin/fix_wifi_macaddr.sh
fi

# Mount old rootfs
ROOTFS_FSTYPE=$(lsblk -l -o PATH,FSTYPE | grep "/dev/${DST_NAME}p2" | awk '{print $2}')
mkdir -p /mnt/${DST_NAME}p2
echo "Wait for root partition mounted ... "
max_try=10
i=1
while [ $i -le $max_try ]; do
      case $ROOTFS_FSTYPE in
      ext4)  mount -t ext4 /dev/${DST_NAME}p2 /mnt/${DST_NAME}p2 2>/dev/null
             ;;
      btrfs) mount -t btrfs -o compress=zstd /dev/${DST_NAME}p2 /mnt/${DST_NAME}p2 2>/dev/null
             ;;
      xfs)   mount -t xfs /dev/${DST_NAME}p2 /mnt/${DST_NAME}p2 2>/dev/null
             ;;
      esac

      sleep 2
      mnt=$(lsblk -l -o MOUNTPOINT | grep "/mnt/${DST_NAME}p2")
      if  [ "$mnt" == "" ];then
          if  [ $i -lt $max_try ];then
              echo "Can not mount emmc root partition, try again ..."
              i=$((i+1))
              continue
          else
              echo "Can not mount emmc root partition, abort!"
              exit 1
          fi
      else
          break
      fi
done

# umount old rootfs
echo "Umount the old rootfs ... "
cd /mnt
umount -f /mnt/${DST_NAME}p2
if  [ $? -ne 0 ];then
    echo "Can't umount old emmc rootfs, update failed!"
    exit 1
fi

# Format rootfs
echo "Format emmc new rootfs partition to btrfs ... "
ROOTFS_UUID=$(/usr/bin/uuidgen)
mkfs.btrfs -f -U ${ROOTFS_UUID} -L EMMC_ROOTFS -m single /dev/${DST_NAME}p2
if  [ $? -ne 0 ];then
    echo "Can't format new emmc rootfs, update failed! please try again!"
    echo "You can run [ n1-install.sh ] to repair!"
    exit 1
else
    mkdir -p /mnt/${DST_NAME}p2
    sleep 2
    # force umount again
    umount -f /mnt/${DST_NAME}p2 2>/dev/null
fi

# mount new rootfs
echo "Wait for the new rootfs partition mounted ... "
i=1
max_try=10
while [ $i -le $max_try ]; do
    mount -t btrfs -o compress=zstd /dev/${DST_NAME}p2 /mnt/${DST_NAME}p2 2>/dev/null
    sleep 2
    mnt=$(lsblk -l -o MOUNTPOINT | grep "/mnt/${DST_NAME}p2")
    if  [ "$mnt" == "" ];then
        if [ $i -lt $max_try ];then
            echo "Can not mount the rootfs partition, try again ..."
            i=$((i+1))
            continue
        else
            echo "Mount new emmc rootfs failed, please run [ n1-install.sh ] to repair!"
            exit 1
        fi
    else
        break
    fi
done

echo "Make new dirs ... "
cd /mnt/${DST_NAME}p2
mkdir -p .reserved bin boot dev etc lib opt mnt overlay proc rom root run sbin sys tmp usr www
ln -sf lib/ lib64
ln -sf tmp/ var
		
echo "Copy data ... "
cd /mnt/${DST_NAME}p2
COPY_SRC="root etc bin sbin lib opt usr www"
for src in $COPY_SRC;do
    rm -rf $src
    echo "Copy new [ $src ] ... "
    (cd / && tar cf - $src) | tar mxf -
done
sync

# copy others ...
echo "Copy other files ... "
mount /dev/${DST_NAME}p3 /mnt/${DST_NAME}p3
cd /mnt/${DST_NAME}p2
[ -d /mnt/${DST_NAME}p3/docker ] || mkdir -p /mnt/${DST_NAME}p3/docker
rm -rf opt/docker && ln -sf /mnt/${DST_NAME}p3/docker/ opt/docker
sync
umount /mnt/${DST_NAME}p3

echo "Edit config files ... "
#cd /mnt/${DST_NAME}p2/usr/bin/
#rm -rf n1-install.sh n1-update.sh

cd /mnt/${DST_NAME}p2/etc/rc.d
ln -sf ../init.d/dockerd S99dockerd

cd /mnt/${DST_NAME}p2/etc
cat > fstab <<EOF
UUID=${ROOTFS_UUID} / btrfs compress=zstd 0 1
LABEL=EMMC_BOOT /boot vfat defaults 0 2
#tmpfs /tmp tmpfs defaults,nosuid 0 0
EOF
sed -e 's/ttyAMA0/ttyAML0/' -i inittab
sed -e 's/ttyS0/tty0/' -i inittab

cd /mnt/${DST_NAME}p2/etc/config
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
        option uuid '${ROOTFS_UUID}'
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

cd /mnt/${DST_NAME}p2/etc
rm -f bench.log
cat >> crontabs/root << EOF
17 3 * * * /etc/coremark.sh
EOF
echo "Config files edit done."

cd /mnt/${DST_NAME}p2
if  [ -x ./usr/sbin/balethirq.pl ];then
    if  grep "balethirq.pl" "./etc/rc.local";then
        echo "Balance irq is enabled"
    else
        echo "Enable balance irq"
        sed -e "/exit/i\/usr/sbin/balethirq.pl" -i ./etc/rc.local
    fi
fi

cp /etc/config/luci ./etc/config/
sync

sync
cd /
umount -f /mnt/${DST_NAME}p2
echo "Copy rootfs done"

# format boot
echo "Format new boot partition to vfat ..."
mkfs.fat -n EMMC_BOOT -F 32 /dev/${DST_NAME}p1 2>/dev/null
if  [ $? -eq 0 ];then
    mkdir -p /mnt/${DST_NAME}p1
    sleep 2
    umount -f /mnt/${DST_NAME}p1 2>/dev/null
fi

# mount boot
echo "Wait for boot partition mounted ... "
i=1
max_try=10
while [ $i -le $max_try ]; do
      mount -t vfat /dev/${DST_NAME}p1 /mnt/${DST_NAME}p1 2>/dev/null
      sleep 2
      mnt=$(lsblk -l -o MOUNTPOINT | grep "/mnt/${DST_NAME}p1")
      if  [ "$mnt" == "" ];then
          if  [ $i -lt $max_try ];then
              echo "Can not mount boot partition, try again ..."
              i=$((i+1))
              continue
          else
              echo "Mount new emmc rootfs failed, please run inst-to-emmc.sh to repair!"
              exit 1
          fi
      else
          break
      fi
done

# copy boot contents
cd /mnt/${DST_NAME}p1
echo "Delete old boot ..."
rm -rf *

echo "Copy new boot ..."
rm -rf /boot/'System Volume Information/'
(cd /boot && tar cf - .) | tar mxf -
sync

echo "Write uEnv.txt ... "
cd /mnt/${DST_NAME}p1
lines=$(wc -l < /boot/uEnv.txt)
lines=$((lines-1))
head -n $lines /boot/uEnv.txt > uEnv.txt
cat >> uEnv.txt <<EOF
APPEND=root=UUID=${ROOTFS_UUID} rootfstype=btrfs rootflags=compress=zstd console=ttyAML0,115200n8 console=tty0 no_console_suspend consoleblank=0 fsck.fix=yes fsck.repair=yes net.ifnames=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1
EOF

rm -f s905_autoscript* aml_autoscript*
sync

cd /
umount -f /mnt/${DST_NAME}p1

echo "Update done, please [ reboot ] your phicomm-n1."

