#!/bin/sh
#======================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Packaged OpenWrt for S905x3-Boxs
# Function: Install and Upgrading openwrt to the emmc for S905x3-Boxs
# Copyright (C) 2020 Flippy
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-openwrt
#======================================================================================

# check cmd param
if  [ "$1" == "" ]; then
    IMG_NAME=$( ls /mnt/mmcblk2p4/*.img 2>/dev/null | head -n 1 )
else
    IMG_NAME=$1
fi

# check file
if  [ ! -f "$IMG_NAME" ]; then
    echo "[ $IMG_NAME ] does not exist."
    exit 1
else
    echo "Start upgrade from [ ${IMG_NAME} ]"
fi

# find boot partition 
BOOT_PART_MSG=$(lsblk -l -o NAME,PATH,TYPE,UUID,MOUNTPOINT | awk '$3~/^part$/ && $5 ~ /^\/boot$/ {print $0}')
if  [ "${BOOT_PART_MSG}" == "" ]; then
    echo "Boot The partition does not exist or is not mounted correctly, so the upgrade cannot be continued!"
    exit 1
fi

BR_FLAG=1
echo -e "Do you want to the upgraded system? y/n [y]\b\b"
read yn
case $yn in
     n*|N*) BR_FLAG=0;;
esac

BOOT_NAME=$(echo $BOOT_PART_MSG | awk '{print $1}')
BOOT_PATH=$(echo $BOOT_PART_MSG | awk '{print $2}')
BOOT_UUID=$(echo $BOOT_PART_MSG | awk '{print $4}')

# find root partition 
ROOT_PART_MSG=$(lsblk -l -o NAME,PATH,TYPE,UUID,MOUNTPOINT | awk '$3~/^part$/ && $5 ~ /^\/$/ {print $0}')
ROOT_NAME=$(echo $ROOT_PART_MSG | awk '{print $1}')
ROOT_PATH=$(echo $ROOT_PART_MSG | awk '{print $2}')
ROOT_UUID=$(echo $ROOT_PART_MSG | awk '{print $4}')

case $ROOT_NAME in 
     mmcblk2p2) NEW_ROOT_NAME=mmcblk2p3
	        NEW_ROOT_LABEL=EMMC_ROOTFS2
	        ;;
     mmcblk2p3) NEW_ROOT_NAME=mmcblk2p2
	        NEW_ROOT_LABEL=EMMC_ROOTFS1
	        ;;
             *) echo "ROOTFS The partition location is incorrect, so the upgrade cannot continue!"
                exit 1
                ;;
esac
echo "NEW_ROOT_NAME: [ ${NEW_ROOT_NAME} ]"

# find new root partition
NEW_ROOT_PART_MSG=$(lsblk -l -o NAME,PATH,TYPE,UUID,MOUNTPOINT | grep "${NEW_ROOT_NAME}" | awk '$3 ~ /^part$/ && $5 !~ /^\/$/ && $5 !~ /^\/boot$/ {print $0}')
if  [ "${NEW_ROOT_PART_MSG}" == "" ]; then
    echo "The new ROOTFS partition does not exist, so the upgrade cannot continue!"
	  exit 1
fi

NEW_ROOT_NAME=$(echo $NEW_ROOT_PART_MSG | awk '{print $1}')
NEW_ROOT_PATH=$(echo $NEW_ROOT_PART_MSG | awk '{print $2}')
NEW_ROOT_UUID=$(echo $NEW_ROOT_PART_MSG | awk '{print $4}')
NEW_ROOT_MP=$(echo $NEW_ROOT_PART_MSG | awk '{print $5}')
echo "NEW_ROOT_MP: [ ${NEW_ROOT_MP} ]"

# backup old bootloader
if  [ ! -f /root/backup-bootloader.img ]; then
    echo "Backup bootloader -> [ backup-bootloader.img ] ... "
    dd if=/dev/mmcblk2 of=/root/backup-bootloader.img bs=1M count=4 conv=fsync
    echo "Backup bootloader complete."
    echo
fi

# losetup
losetup -f -P $IMG_NAME
if  [ $? -eq 0 ]; then
    LOOP_DEV=$(losetup | grep "$IMG_NAME" | awk '{print $1}')
    if  [ "$LOOP_DEV" == "" ]; then
        echo "loop device not found!"
        exit 1
    fi
else
    echo "losetup [ $IMG_FILE ] failed!"
    exit 1
fi

WAIT=3
echo "The loopdev is [ $LOOP_DEV ], wait [ ${WAIT} ] seconds. "
while [ $WAIT -ge 1 ]; do
      sleep 1
      WAIT=$(( WAIT - 1 ))
done

# umount loop devices (openwrt will auto mount some partition)
MOUNTED_DEVS=$(lsblk -l -o NAME,PATH,MOUNTPOINT | grep "$LOOP_DEV" | awk '$3 !~ /^$/ {print $2}')
for dev in $MOUNTED_DEVS; do
    while : ; do
        echo "umount [ $dev ] ... "
        umount -f $dev
        sleep 1
        mnt=$(lsblk -l -o NAME,PATH,MOUNTPOINT | grep "$dev" | awk '$3 !~ /^$/ {print $2}')
        if  [ "$mnt" == "" ]; then
            break
        else 
            echo "Retry ..."
        fi
    done
done

# mount src part
WORK_DIR=$PWD
P1=${WORK_DIR}/boot
P2=${WORK_DIR}/root
mkdir -p $P1 $P2

echo "Mount [ ${LOOP_DEV}p1 ] -> [ ${P1} ] ... "
mount -t vfat -o ro ${LOOP_DEV}p1 ${P1}
if  [ $? -ne 0 ]; then
    echo "Mount p1 [ ${LOOP_DEV}p1 ] failed!"
    losetup -D
    exit 1
fi	

echo "Mount [ ${LOOP_DEV}p2 ] -> [ ${P2} ] ... "
mount -t btrfs -o ro,compress=zstd ${LOOP_DEV}p2 ${P2}
if  [ $? -ne 0 ]; then
    echo "Mount p2 [ ${LOOP_DEV}p2 ] failed!"
    umount -f ${P1}
    losetup -D
    exit 1
fi	

#format NEW_ROOT
echo "umount [ ${NEW_ROOT_MP} ]"
umount -f "${NEW_ROOT_MP}"
if  [ $? -ne 0 ]; then
    echo "Mount [ ${NEW_ROOT_MP} ] failed, Please restart and try again!"
    umount -f ${P1}
    umount -f ${P2}
    losetup -D
    exit 1
fi

echo "Format [ ${NEW_ROOT_PATH} ]"
NEW_ROOT_UUID=$(uuidgen)
mkfs.btrfs -f -U ${NEW_ROOT_UUID} -L ${NEW_ROOT_LABEL} -m single ${NEW_ROOT_PATH}
if  [ $? -ne 0 ]; then
    echo "Format [ ${NEW_ROOT_PATH} ] failed!"
    umount -f ${P1}
    umount -f ${P2}
    losetup -D
    exit 1
fi

echo "Mount [ ${NEW_ROOT_PATH} ] -> [ ${NEW_ROOT_MP} ]"
mount -t btrfs -o compress=zstd ${NEW_ROOT_PATH} ${NEW_ROOT_MP}
if  [ $? -ne 0 ]; then
    echo "Mount [ ${NEW_ROOT_PATH} ] -> [ ${NEW_ROOT_MP} ] failed!"
    umount -f ${P1}
    umount -f ${P2}
    losetup -D
    exit 1
fi

# begin copy rootfs
cd ${NEW_ROOT_MP}
echo "Start copying data， From [ ${P2} ] TO [ ${NEW_ROOT_MP} ] ..."
ENTRYS=$(ls)
for entry in $ENTRYS; do
    if  [ "$entry" == "lost+found" ]; then
        continue
    fi
    echo "Remove old [ $entry ] ... "
    rm -rf $entry 
    if  [ $? -ne 0 ]; then
        echo "failed."
        exit 1
    fi
done

echo "Create folder ... "
mkdir -p .reserved bin boot dev etc lib opt mnt overlay proc rom root run sbin sys tmp usr www
ln -sf lib/ lib64
ln -sf tmp/ var

COPY_SRC="root etc bin sbin lib opt usr www"
echo "Copy data brgin ... "
for src in $COPY_SRC; do
    echo "Copy [ $src ] ... "
    (cd ${P2} && tar cf - $src) | tar xf -
    sync
done
[ -d /mnt/mmcblk2p4/docker ] || mkdir -p /mnt/mmcblk2p4/docker
rm -rf opt/docker && ln -sf /mnt/mmcblk2p4/docker/ opt/docker

if  [ -f /mnt/${NEW_ROOT_NAME}/etc/config/AdGuardHome ]; then
    [ -d /mnt/mmcblk2p4/AdGuardHome/data ] || mkdir -p /mnt/mmcblk2p4/AdGuardHome/data
    if  [ ! -L /usr/bin/AdGuardHome ]; then
        [ -d /usr/bin/AdGuardHome ] && \
        cp -a /usr/bin/AdGuardHome/* /mnt/mmcblk2p4/AdGuardHome/
    fi
    ln -sf /mnt/mmcblk2p4/AdGuardHome /mnt/${NEW_ROOT_NAME}/usr/bin/AdGuardHome
fi

BOOTLOADER="./lib/u-boot/hk1box-bootloader.img"
if  [ -f ${BOOTLOADER} ]; then
    if dmesg | grep 'AMedia X96 Max+'; then
        echo "Write new bootloader [ ${BOOTLOADER} ] ... "
        # write u-boot
        dd if=${BOOTLOADER} of=/dev/mmcblk2 bs=1 count=442 conv=fsync
        dd if=${BOOTLOADER} of=/dev/mmcblk2 bs=512 skip=1 seek=1 conv=fsync
        echo "Write complete."
    fi
fi

#rm -f /mnt/${NEW_ROOT_NAME}/usr/bin/s905x3-install.sh
#rm -f /mnt/${NEW_ROOT_NAME}/usr/bin/s905x3-update.sh
sync
echo "Copy data complete ..."

echo "Modify the configuration file ... "
rm -f "./etc/rc.local.orig" "./usr/bin/mk_newpart.sh" "./etc/part_size"
rm -rf "./opt/docker" && ln -sf "/mnt/mmcblk2p4/docker" "./opt/docker"

cat > ./etc/fstab <<EOF
UUID=${NEW_ROOT_UUID} / btrfs compress=zstd 0 1
LABEL=EMMC_BOOT /boot vfat defaults 0 2
#tmpfs /tmp tmpfs defaults,nosuid 0 0
EOF

cat > ./etc/config/fstab <<EOF
config  global
        option anon_swap '0'
        option anon_mount '1'
        option auto_swap '0'
        option auto_mount '1'
        option delay_root '5'
        option check_fs '0'

config  mount
        option target '/overlay'
        option uuid '${NEW_ROOT_UUID}'
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

rm -f ./etc/bench.log
cat >> ./etc/crontabs/root << EOF
17 3 * * * /etc/coremark.sh
EOF

sed -e 's/ttyAMA0/ttyAML0/' -i ./etc/inittab
sed -e 's/ttyS0/tty0/' -i ./etc/inittab

rm -f ./etc/part_size ./usr/bin/mk_newpart.sh
if  [ -x ./usr/sbin/balethirq.pl ]; then
    if  grep "balethirq.pl" "./etc/rc.local"; then
        echo "balance irq is enabled"
    else
        echo "enable balance irq"
        sed -e "/exit/i\/usr/sbin/balethirq.pl" -i ./etc/rc.local
    fi
fi
mv ./etc/rc.local ./etc/rc.local.orig

cat > ./etc/rc.local <<EOF
if [ ! -f /etc/rc.d/*dockerd ]; then
    /etc/init.d/dockerd enable
    /etc/init.d/dockerd start
fi
mv /etc/rc.local.orig /etc/rc.local
exec /etc/rc.local
exit
EOF

chmod 755 ./etc/rc.local*

cd ${WORK_DIR}
 
echo "Start copying data， from [ ${P1} ] to [ /boot ] ..."
cd /boot
echo "Delete the old boot file ..."
cp uEnv.txt /tmp/uEnv.txt
U_BOOT_EMMC=0
[ -f u-boot.emmc ] && U_BOOT_EMMC=1
rm -rf *

echo "Copy the new boot file ... "
(cd ${P1} && tar cf - . ) | tar xf -
[ $U_BOOT_EMMC -eq 1 ] && cp u-boot.sd u-boot.emmc
rm -f aml_autoscript* s905_autoscript*
sync

echo "Update boot parameters ... "
if  [ -f /tmp/uEnv.txt ];then
    lines=$(wc -l < /tmp/uEnv.txt)
    lines=$(( lines - 1 ))
    head -n $lines /tmp/uEnv.txt > uEnv.txt
    cat >> uEnv.txt <<EOF
APPEND=root=UUID=${NEW_ROOT_UUID} rootfstype=btrfs rootflags=compress=zstd console=ttyAML0,115200n8 console=tty0 no_console_suspend consoleblank=0 fsck.fix=yes fsck.repair=yes net.ifnames=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1
EOF
else
    cat > uEnv.txt <<EOF
LINUX=/zImage
INITRD=/uInitrd
FDT=/dtb/amlogic/meson-sm1-x96-max-plus.dtb
APPEND=root=UUID=${NEW_ROOT_UUID} rootfstype=btrfs rootflags=compress=zstd console=ttyAML0,115200n8 console=tty0 no_console_suspend consoleblank=0 fsck.fix=yes fsck.repair=yes net.ifnames=0 cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory swapaccount=1
EOF
fi

sync

cd $WORK_DIR
umount -f ${P1} ${P2} 2>/dev/null
losetup -D 2>/dev/null
rm -rf ${P1} ${P2} 2>/dev/null
rm -f ${IMG_NAME} 2>/dev/null

echo "The upgrade is complete, please [ reboot ] the system!"

