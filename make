#!/bin/bash
#======================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Packaged OpenWrt for S905x3-Boxs and Phicomm-N1
# Function: Use Flippy's kernrl files for amlogic-s9xxx to build openwrt for S905x3-Boxs and Phicomm-N1
# Copyright (C) 2020 Flippy's kernrl files for amlogic-s9xxx
# Copyright (C) 2020 https://github.com/tuanqing/mknop
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-openwrt
#======================================================================================================================

#===== Do not modify the following parameter settings, Start =====
tmp_path="tmp"
out_path="out"
armbian_path="armbian"
openwrt_path="openwrt-armvirt"
kernel_path="kernel-amlogic"
build_openwrt=("n1" "x96" "hk1" "h96" "octopus")
make_path=${PWD}
#===== Do not modify the following parameter settings, End =======

# Set firmware size (ROOT_MB: must be ≥ 256)
SKIP_MB=16
BOOT_MB=256
ROOT_MB=1024

tag() {
    echo -e " [ \033[1;36m$1\033[0m ]"
}

process() {
    echo -e " [ \033[1;32m$build\033[0m - \033[1;32m$kernel\033[0m ] $1"
}

die() {
    error "$1" && exit 1
}

error() {
    echo -e " [ \033[1;31mError\033[0m ] $1"
}

loop_setup() {
    loop=$(losetup -P -f --show "$1")
    [ $loop ] || die "you used a lower version Linux, please update the util-linux package or upgrade your system."
}

cleanup() {
    for x in $(grep $(pwd) /proc/mounts | grep -oE "loop[0-9]{1,2}" | sort | uniq); do
        umount -f /dev/${x}p[1-2] 2>/dev/null
        losetup -d "/dev/$x" 2>/dev/null
    done
    rm -rf $tmp_path
}

extract_openwrt() {
    cd ${make_path}
    local firmware="$openwrt_path/$firmware"
    local suffix="${firmware##*.}"
    mount="$tmp_path/mount"
    root_comm="$tmp_path/root_comm"

    mkdir -p $mount $root_comm
    while true; do
        case "$suffix" in
        tar)
            tar -xf $firmware -C $root_comm
            break
            ;;
        gz)
            if ls $firmware | grep -q ".tar.gz$"; then
                tar -xzf $firmware -C $root_comm
                break
            else
                tmp_firmware="$tmp_path/${firmware##*/}"
                tmp_firmware=${tmp_firmware%.*}
                gzip -d $firmware -c > $tmp_firmware
                firmware=$tmp_firmware
                suffix=${firmware##*.}
            fi
            ;;
        img)
            loop_setup $firmware
            if ! mount -r ${loop}p2 $mount; then
                if ! mount -r ${loop}p1 $mount; then
                    die "mount ${loop} failed!"
                fi
            fi
            cp -rf $mount/* $root_comm && sync
            umount -f $mount
            losetup -d $loop
            break
            ;;
        ext4)
            if ! mount -r -o loop $firmware $mount; then
                die "mount $firmware failed!"
            fi
            cp -rf $mount/* $root_comm && sync
            umount -f $mount
            break
            ;;
        *)
            die "This script only supports rootfs.tar[.gz], ext4-factory.img[.gz], root.ext4[.gz] six formats."
            ;;
        esac
    done

    rm -rf $root_comm/lib/modules/*/
}

extract_armbian() {
    cd ${make_path}
    build_op=${1}
    kernel_dir="$armbian_path/$kernel_path/kernel/$kernel"
    root_dir="$armbian_path/$kernel_path/root"
    root="$tmp_path/$kernel/$build_op/root"
    boot="$tmp_path/$kernel/$build_op/boot"

    mkdir -p $root $boot

    tar -xJf "$armbian_path/boot-common.tar.xz" -C $boot
    tar -xJf "$kernel_dir/kernel.tar.xz" -C $boot
    tar -xJf "$armbian_path/firmware.tar.xz" -C $root
    tar -xJf "$kernel_dir/modules.tar.xz" -C $root

    cp -rf $root_comm/* $root
    [ $(ls $root_dir | wc -w) != 0 ] && cp -r $root_dir/* $root
    sync
}

utils() {
    (
        cd $root
        # add other operations below

        echo 'pwm_meson' > etc/modules.d/pwm-meson
        if ! grep -q 'ulimit -n' etc/init.d/boot; then
            sed -i '/kmodloader/i \\tulimit -n 51200\n' etc/init.d/boot
        fi
        if ! grep -q '/tmp/upgrade' etc/init.d/boot; then
            sed -i '/mkdir -p \/tmp\/.uci/a \\tmkdir -p \/tmp\/upgrade' etc/init.d/boot
        fi
        sed -i 's/ttyAMA0/ttyAML0/' etc/inittab
        sed -i 's/ttyS0/tty0/' etc/inittab

        mkdir -p boot run opt
        chown -R 0:0 ./
    )
}

make_image() {
    build_op=${1}
    build_image_file="$out_path/openwrt_${build_op}_v${kernel}_$(date +"%Y.%m.%d.%H%M").img"
    rm -f $build_image_file
    sync

    [ -d "$out_path/$kernel" ] || mkdir -p "$out_path/$kernel"
    fallocate -l $((SKIP_MB + BOOT_MB + rootsize))M $build_image_file
}

format_image() {
    build_op=${1}

    parted -s $build_image_file mklabel msdos 2>/dev/null
    parted -s $build_image_file mkpart primary ext4 $((SKIP_MB))M $((SKIP_MB + BOOT_MB -1))M 2>/dev/null
    parted -s $build_image_file mkpart primary ext4 $((SKIP_MB + BOOT_MB))M 100% 2>/dev/null

    loop_setup $build_image_file
    mkfs.vfat -n "BOOT" ${loop}p1 >/dev/null 2>&1
    mke2fs -F -q -t ext4 -L "ROOTFS" -m 0 ${loop}p2 >/dev/null 2>&1

    # Complete file
    complete_path=${make_path}/install-program/files
    [ -f ${root}/root/hk1box-bootloader.img ] || cp -f ${complete_path}/hk1box-bootloader.img  ${root}/root/
    [ -f ${root}/root/u-boot-2015-phicomm-n1.bin ] || cp -f ${complete_path}/u-boot-2015-phicomm-n1.bin  ${root}/root/
    [ -f ${root}/usr/bin/s905x3-install.sh ] || cp -f ${complete_path}/s905x3-install.sh  ${root}/usr/bin/
    [ -f ${root}/usr/bin/s905x3-update.sh ] || cp -f ${complete_path}/s905x3-update.sh  ${root}/usr/bin/
    [ -f ${root}/usr/bin/n1-install.sh ] || cp -f ${complete_path}/n1-install.sh  ${root}/usr/bin/
    [ -f ${root}/usr/bin/n1-update.sh ] || cp -f ${complete_path}/n1-update.sh  ${root}/usr/bin/
    [ -f ${root}/etc/config/fstab ] || cp -f ${complete_path}/fstab  ${root}/etc/config/
    [ -f ${root}/etc/config/fstab ] || cp -f ${complete_path}/fstab  ${root}/etc/config/fstab.bak

    # Write the specified bootloader
    if [ "${build_op}" != "n1" ]; then
        BTLD_BIN="${root}/root/hk1box-bootloader.img"
        if [ -f ${BTLD_BIN} ]; then
           mkdir -p ${root}/lib/u-boot
           cp -f ${BTLD_BIN} ${root}/lib/u-boot/
           #echo "Write bootloader for $build_op: [ $( ls $root/lib/u-boot/*.img 2>/dev/null ) ]."
           dd if=${BTLD_BIN} of=${lodev} bs=1 count=442 conv=fsync 2>/dev/null
           dd if=${BTLD_BIN} of=${lodev} bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
        else
           die "bootloader does not exist."
        fi
    fi
    
    # Add firmware version information to the terminal page
    if  [ -f ${root}/etc/banner ]; then
        op_version=$(echo $(ls ${root}/lib/modules/) 2>/dev/null)
        op_packaged_date=$(date +%Y-%m-%d)
        echo " OpenWrt Kernel: ${op_version}" >> ${root}/etc/banner
        echo " Phicomm-N1 installation command: n1-install.sh" >> ${root}/etc/banner
        echo " S905x3-Boxs installation command: s905x3-install.sh" >> ${root}/etc/banner
        echo " Packaged Date: ${op_packaged_date}" >> ${root}/etc/banner
        echo " -----------------------------------------------------" >> ${root}/etc/banner
    fi
}

copy2image() {
    build_op=${1}
    set -e

    local bootfs="$mount/$kernel/$build_op/bootfs"
    local rootfs="$mount/$kernel/$build_op/rootfs"

    mkdir -p $bootfs $rootfs
    if ! mount ${loop}p1 $bootfs; then
        die "mount ${loop}p1 failed!"
    fi
    if ! mount ${loop}p2 $rootfs; then
        die "mount ${loop}p2 failed!"
    fi

    cp -rf $boot/* $bootfs
    cp -rf $root/* $rootfs
    sync

    #Write the specified uEnv.txt
    if [ "$build_op" != "n1" ]; then
        cd ${bootfs}
        if [  ! -f "uEnv.txt" ]; then
           die "Error: uEnv.txt Files does not exist"
        fi

        n1_fdt_dtb="meson-gxl-s905d-phicomm-n1.dtb"
        case "${build_op}" in
        x96)
            new_fdt_dtb="meson-sm1-x96-max-plus-100m.dtb"
            sed -i "s/${n1_fdt_dtb}/${new_fdt_dtb}/g" uEnv.txt
            ;;
        hk1)
            new_fdt_dtb="meson-sm1-hk1box-vontar-x3.dtb"
            sed -i "s/${n1_fdt_dtb}/${new_fdt_dtb}/g" uEnv.txt
            ;;
        h96)
            new_fdt_dtb="meson-sm1-h96-max-x3.dtb"
            sed -i "s/${n1_fdt_dtb}/${new_fdt_dtb}/g" uEnv.txt
            ;;
        octopus)
            new_fdt_dtb="meson-gxm-octopus-planet.dtb"
            sed -i "s/${n1_fdt_dtb}/${new_fdt_dtb}/g" uEnv.txt
            ;;
        *)
            die "Have no this firmware: [ ${build_op} - ${kernel} ]"
            ;;
        esac

        sync
        cd ${make_path}
    fi

    umount -f $bootfs 2>/dev/null
    umount -f $rootfs 2>/dev/null
    losetup -d $loop 2>/dev/null
}

get_firmwares() {
    firmwares=()
    i=0
    IFS=$'\n'

    [ -d "$openwrt_path" ] && {
        for x in $(ls $openwrt_path); do
            firmwares[i++]=$x
        done
    }
}

get_kernels() {
    kernels=()
    i=0
    IFS=$'\n'

    local kernel_root="$armbian_path/$kernel_path/kernel"
    [ -d $kernel_root ] && {
        work=$(pwd)
        cd $kernel_root
        for x in $(ls ./); do
            [[ -f "$x/kernel.tar.xz" && -f "$x/modules.tar.xz" ]] && kernels[i++]=$x
        done
        cd $work
    }
}

show_kernels() {
    if [ ${#kernels[*]} = 0 ]; then
        die "No kernel files in [ ${armbian_path}/${openwrt_path}/kernel ] directory!"
    else
        show_list "${kernels[*]}" "kernel"
    fi
}

show_list() {
    echo " $2: "
    i=0
    for x in $1; do
        echo " ($((++i))) $x"
    done
}

choose_firmware() {
    show_list "${firmwares[*]}" "firmware"
    choose_files ${#firmwares[*]} "firmware"
    firmware=${firmwares[opt]}
    tag $firmware && echo
}

choose_kernel() {
    show_kernels
    choose_files ${#kernels[*]} "kernel"
    kernel=${kernels[opt]}
    tag $kernel && echo
}

choose_files() {
    local len=$1

    if [ "$len" = 1 ]; then
        opt=0
    else
        i=0
        while true; do
            echo && read -p " select $2 above, and press Enter to select the first one: " opt
            [ $opt ] || opt=1
            if [[ "$opt" -ge 1 && "$opt" -le "$len" ]]; then
                let opt--
                break
            else
                ((i++ >= 2)) && exit 1
                error "Wrong type, try again!"
                sleep 1s
            fi
        done
    fi
}

set_rootsize() {
    i=0
    rootsize=

    while true; do
        read -p " input the rootfs partition size, defaults to 1024m, do not less than 256m
 if you don't know what this means, press Enter to keep default: " rootsize
        [ $rootsize ] || rootsize=$ROOT_MB
        if [[ "$rootsize" -ge 256 ]]; then
            tag $rootsize && echo
            break
        else
            ((i++ >= 2)) && exit 1
            error "wrong type, try again!\n"
            sleep 1s
        fi
    done
}

usage() {
    cat <<EOF
Usage:
    make [option]

Options:
    -c, --clean          clean up the output and temporary directories

    -d, --default        the kernel version is "all", and the rootfs partition size is "1024m"

    -b, --build=BUILD    Specify multiple cores, use "_" to connect
       , -b all          Compile all types of openwrt
       , -b n1           Specify a single openwrt for compilation
       , -b n1_x96_hk1   Specify multiple openwrt, use "_" to connect

    -k=VERSION           set the kernel version, which must be in the "kernel" directory
       , -k all          build all the kernel version
       , -k latest       build the latest kernel version
       , -k 5.4.6        Specify a single kernel for compilation
       , -k 5.4.6_5.9.0  Specify multiple cores, use "_" to connect

    --kernel             show all kernel version in "kernel" directory

    -s, --size=SIZE      set the rootfs partition size, do not less than 256m

    -h, --help           display this help

EOF
}

##
[ $(id -u) = 0 ] || die "please run this script as root!"
echo -e "Welcome to use the OpenWrt automatic packaging tool!\n"

cleanup
get_firmwares
get_kernels

while [ "$1" ]; do
    case "$1" in
    -h | --help)
        usage && exit
        ;;
    -c | --clean)
        cleanup
        rm -rf $out_path
        echo "Clean up ok!" && exit
        ;;

    -d | --default)
        : ${rootsize:=$ROOT_MB}
        : ${firmware:="${firmwares[0]}"}
        : ${kernel:="all"}
        : ${build:="all"}
        ;;
    -b | --build)
        build=$2
        if   [ "$build" = "all" ]; then
             shift
        elif [ -n "$build" ]; then
             unset build_openwrt
             oldIFS=$IFS
             IFS=_
             build_openwrt=($build)
             IFS=$oldIFS
             unset build
             : ${build:="all"}
        else
             die "Invalid build [ $2 ]!"
        fi
        shift
        ;;
    -k)
        kernel=$2
        if   [ "$kernel" = "all" ]; then
             shift
        elif [ "$kernel" = "latest" ]; then
             kernel="${kernels[-1]}"
             shift
        elif [ -n "$kernel" ]; then
             oldIFS=$IFS
             IFS=_
             kernels=($kernel)
             IFS=$oldIFS
             unset kernel
             : ${kernel:="all"}
             shift
        else
             die "Invalid kernel [ $2 ]!"
        fi
        ;;
    --kernel)
        show_kernels && exit
        ;;
    -s | --size)
        rootsize=$2
        if [[ "$rootsize" -ge 256 ]]; then
            shift
        else
            die "Invalid size [ $2 ]!"
        fi
        ;;
    *)
        die "Invalid option [ $1 ]!"
        ;;
    esac
    shift
done

if [ ${#firmwares[*]} = 0 ]; then
    die "No the [ openwrt-armvirt-64-default-rootfs.tar.gz ] file in [ ${openwrt_path} ] directory!"
fi

if [ ${#kernels[*]} = 0 ]; then
    die "No this kernel files in [ ${armbian_path}/${openwrt_path}/kernel ] directory!"
fi

[ $firmware ] && echo " firmware   ==>   $firmware"
[ $rootsize ] && echo " rootsize   ==>   $rootsize"

[ $firmware ] || [ $kernel ] || [ $rootsize ] && echo

[ $firmware ] || choose_firmware
[ $kernel ] || choose_kernel
[ $rootsize ] || set_rootsize

[ $kernel != "all" ] && kernels=("$kernel")
[ $build != "all" ] && build_openwrt=("$build")

extract_openwrt

for b in ${build_openwrt[*]}; do
    for x in ${kernels[*]}; do
        {
            kernel=$x
            build=$b
            process " extract armbian files."
            extract_armbian ${b}
            utils
            process " make openwrt image."
            make_image ${b}
            process " format openwrt image."
            format_image ${b}
            process " copy files to image."
            copy2image ${b}
            process " generate success."
        } &
    done
done

wait

cleanup
chmod -R 777 $out_path

