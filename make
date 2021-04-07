#!/bin/bash
#======================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Packaged OpenWrt for Amlogic S9xxx STB
# Function: Use Flippy's kernrl files for Amlogic S9xxx STB to build openwrt
# Copyright (C) 2020-2021 Flippy's kernrl files for Amlogic S9xxx STB
# Copyright (C) 2020-2021 https://github.com/tuanqing/mknop
# Copyright (C) 2020-2021 https://github.com/ophub/amlogic-s9xxx-openwrt
#======================================================================================================================

#===== Do not modify the following parameter settings, Start =====
build_openwrt=("s905x3" "s905x2" "s905x" "s905d" "s912" "s922x")
make_path=${PWD}
tmp_path=${make_path}/tmp
out_path=${make_path}/out
openwrt_path=${make_path}/openwrt-armvirt
amlogic_path=${make_path}/amlogic-s9xxx
kernel_path=${amlogic_path}/amlogic-kernel
armbian_path=${amlogic_path}/amlogic-armbian
uboot_path=${amlogic_path}/amlogic-u-boot
installfiles_path=${amlogic_path}/install-program/files
configfiles_path=${amlogic_path}/common-files
#===== Do not modify the following parameter settings, End =======

# Set firmware size ( BOOT_MB size >= 128, ROOT_MB size >= 320 )
BOOT_MB=256
ROOT_MB=1024

tag() {
    echo -e " [ \033[1;36m ${1} \033[0m ]"
}

process() {
    echo -e " [ \033[1;32m ${build} \033[0m - \033[1;32m ${kernel} \033[0m ] ${1}"
}

die() {
    error "${1}" && exit 1
}

error() {
    echo -e " [ \033[1;31m Error \033[0m ] ${1}"
}

loop_setup() {
    loop=$(losetup -P -f --show "${1}")
    [ ${loop} ] || die "losetup ${1} failed."
}

cleanup() {
    cd ${make_path}
    for x in $(lsblk | grep $(pwd) | grep -oE 'loop[0-9]+' | sort | uniq); do
        umount -f /dev/${x}p* 2>/dev/null
        losetup -d /dev/${x} 2>/dev/null
    done
    losetup -D
    rm -rf ${tmp_path}
}

extract_openwrt() {
    cd ${make_path}
    local firmware="${openwrt_path}/${firmware}"
    local suffix="${firmware##*.}"
    mount="${tmp_path}/mount"
    root_comm="${tmp_path}/root_comm"

    mkdir -p ${mount} ${root_comm}
    while true; do
        case "${suffix}" in
        tar)
            tar -xf ${firmware} -C ${root_comm}
            break
            ;;
        gz)
            if ls ${firmware} | grep -q ".tar.gz$"; then
                tar -xzf ${firmware} -C ${root_comm}
                break
            else
                tmp_firmware="${tmp_path}/${firmware##*/}"
                tmp_firmware=${tmp_firmware%.*}
                gzip -d ${firmware} -c > ${tmp_firmware}
                firmware=${tmp_firmware}
                suffix=${firmware##*.}
            fi
            ;;
        img)
            loop_setup ${firmware}
            if ! mount -r ${loop}p2 ${mount}; then
                if ! mount -r ${loop}p1 ${mount}; then
                    die "mount ${loop} failed!"
                fi
            fi
            cp -rf ${mount}/* ${root_comm} && sync
            umount -f ${mount}
            losetup -d ${loop}
            break
            ;;
        ext4)
            if ! mount -r -o loop ${firmware} ${mount}; then
                die "mount ${firmware} failed!"
            fi
            cp -rf ${mount}/* ${root_comm} && sync
            umount -f ${mount}
            break
            ;;
        *)
            die "This script only supports rootfs.tar[.gz], ext4-factory.img[.gz], root.ext4[.gz] six formats."
            ;;
        esac
    done

    rm -rf ${root_comm}/lib/modules/*/
}

extract_armbian() {
    cd ${make_path}
    build_op=${1}
    kernel_dir="${kernel_path}/kernel/${kernel}"
    root="${tmp_path}/${kernel}/${build_op}/root"
    boot="${tmp_path}/${kernel}/${build_op}/boot"

    mkdir -p ${root} ${boot}

    tar -xJf "${armbian_path}/boot-common.tar.xz" -C ${boot}
    tar -xJf "${armbian_path}/firmware.tar.xz" -C ${root}

    if  [ -f "${kernel_dir}/kernel.tar.xz" ]; then
        tar -xJf "${kernel_dir}/kernel.tar.xz" -C ${boot}
        tar -xJf "${kernel_dir}/modules.tar.xz" -C ${root}
    elif [ -f ${kernel_dir}/boot-*.tar.gz -a -f ${kernel_dir}/dtb-amlogic-*.tar.gz -a -f ${kernel_dir}/modules-*.tar.gz ]; then
        mkdir -p ${boot}/dtb/amlogic ${root}/lib/modules
        tar -xzf ${kernel_dir}/dtb-amlogic-*.tar.gz -C ${boot}/dtb/amlogic

        tar -xzf ${kernel_dir}/boot-*.tar.gz -C ${boot}
        mv -f ${boot}/uInitrd-* ${boot}/uInitrd && mv -f ${boot}/vmlinuz-* ${boot}/zImage 2>/dev/null

        tar -xzf ${kernel_dir}/modules-*.tar.gz -C ${root}/lib/modules
        cd ${root}/lib/modules/*/
        rm -f *.ko
        find ./ -type f -name '*.ko' -exec ln -s {} ./ \;
        cd ${make_path} && sync
    else
        die "Have no kernel files in [ ${kernel_dir} ]"
    fi

    cp -rf ${root_comm}/* ${root}

    # Complete file for ${root}: [ /etc ], [ /lib/u-boot ] etc.
    [ $(ls ${configfiles_path}/files 2>/dev/null | wc -w) != 0 ] && cp -rf ${configfiles_path}/files/* ${root}
    sync
}

utils() {
    cd ${make_path}
    build_op=${1}
    build_usekernel=${2}

    kernel_vermaj=$(echo ${build_usekernel} | grep -oE '^[1-9].[0-9]{1,2}')
    k510_ver=${kernel_vermaj%%.*}
    k510_maj=${kernel_vermaj##*.}
    if  [ ${k510_ver} -eq "5" ];then
        if  [ "${k510_maj}" -ge "10" ];then
            K510=1
        else
            K510=0
        fi
    elif [ ${k510_ver} -gt "5" ];then
        K510=1
    else
        K510=0
    fi

    case "${build_op}" in
        s905x3 | x96 | hk1 | h96)
            FDTFILE="meson-sm1-x96-max-plus-100m.dtb"
            U_BOOT_EXT=1
            UBOOT_OVERLOAD="u-boot-x96maxplus.bin"
            MAINLINE_UBOOT="/lib/u-boot/x96maxplus-u-boot.bin.sd.bin"
            ANDROID_UBOOT="/lib/u-boot/hk1box-bootloader.img"
            ;;
        s905x2 | x96max4g | x96max2g)
            FDTFILE="meson-g12a-x96-max.dtb"
            U_BOOT_EXT=0
            UBOOT_OVERLOAD="u-boot-x96max.bin"
            MAINLINE_UBOOT="/lib/u-boot/x96max-u-boot.bin.sd.bin"
            ANDROID_UBOOT=""
            ;;
        s905x | hg680p | b860h)
            FDTFILE="meson-gxl-s905x-p212.dtb"
            U_BOOT_EXT=0
            UBOOT_OVERLOAD="u-boot-p212.bin"
            MAINLINE_UBOOT=""
            ANDROID_UBOOT=""
            ;;
        s905d | n1)
            FDTFILE="meson-gxl-s905d-phicomm-n1.dtb"
            U_BOOT_EXT=0
            UBOOT_OVERLOAD="u-boot-n1.bin"
            MAINLINE_UBOOT=""
            ANDROID_UBOOT="/lib/u-boot/u-boot-2015-phicomm-n1.bin"
            ;;
        s912 | octopus)
            FDTFILE="meson-gxm-octopus-planet.dtb"
            U_BOOT_EXT=0
            UBOOT_OVERLOAD="u-boot-zyxq.bin"
            MAINLINE_UBOOT=""
            ANDROID_UBOOT=""
            ;;
        s922x | belink | belinkpro | ugoos)
            FDTFILE="meson-g12b-gtking-pro.dtb"
            U_BOOT_EXT=1
            UBOOT_OVERLOAD="u-boot-gtkingpro.bin"
            MAINLINE_UBOOT="/lib/u-boot/gtkingpro-u-boot.bin.sd.bin"
            ANDROID_UBOOT=""
            ;;
        *)
            die "Have no this firmware: [ ${build_op} - ${kernel} ]"
            ;;
    esac

    #Edit ${root}/* files ========== Begin ==========
    cd ${root}

    # Add other operations below
    echo 'pwm_meson' > etc/modules.d/pwm-meson
    if ! grep -q 'ulimit -n' etc/init.d/boot; then
        sed -i '/kmodloader/i \\tulimit -n 51200\n' etc/init.d/boot
    fi
    if ! grep -q '/tmp/update' etc/init.d/boot; then
        sed -i '/mkdir -p \/tmp\/.uci/a \\tmkdir -p \/tmp\/update' etc/init.d/boot
    fi
    sed -i 's/ttyAMA0/ttyAML0/' etc/inittab
    sed -i 's/ttyS0/tty0/' etc/inittab

    mkdir -p boot run opt
    chown -R 0:0 ./

    # Complete file: openwrt-install openwrt-update
    [ -f usr/bin/openwrt-install ] || cp -f ${installfiles_path}/openwrt-install usr/bin/
    [ -f usr/bin/openwrt-update ] || cp -f ${installfiles_path}/openwrt-update usr/bin/

    #Edit fstab
    ROOTFS_UUID=$(uuidgen)
    #echo "ROOTFS_UUID: ${ROOTFS_UUID}"
    sed -i "s/LABEL=ROOTFS/UUID=${ROOTFS_UUID}/" etc/fstab 2>/dev/null
    sed -i "s/option label 'ROOTFS'/option uuid '${ROOTFS_UUID}'/" etc/config/fstab 2>/dev/null

    # Add drivers from {kernel_path}/build_kernel/patches/root/wireless/
    [ -f etc/modules.d/rtl8189fs ] || echo "8189fs" > etc/modules.d/rtl8189fs
    [ -f etc/modules.d/rtl8188fu ] || echo "rtl8188fu" > etc/modules.d/rtl8188fu
    [ -f etc/modules.d/usb-net-rtl8150 ] || echo "rtl8150" > etc/modules.d/usb-net-rtl8150
    [ -f etc/modules.d/usb-net-rtl8152 ] || echo "r8152" > etc/modules.d/usb-net-rtl8152
    [ -f etc/modules.d/usb-net-asix-ax88179 ] || echo "ax88179_178a" > etc/modules.d/usb-net-asix-ax88179

    # Add firmware information to the openwrt-version
    echo "FDTFILE='${FDTFILE}'" >> lib/u-boot/openwrt-version 2>/dev/null
    echo "U_BOOT_EXT='${U_BOOT_EXT}'" >> lib/u-boot/openwrt-version 2>/dev/null
    echo "UBOOT_OVERLOAD='${UBOOT_OVERLOAD}'" >> lib/u-boot/openwrt-version 2>/dev/null
    echo "MAINLINE_UBOOT='${MAINLINE_UBOOT}'" >> lib/u-boot/openwrt-version 2>/dev/null
    echo "ANDROID_UBOOT='${ANDROID_UBOOT}'" >> lib/u-boot/openwrt-version 2>/dev/null
    echo "AMLOGIC_SOC='${build_op}'" >> lib/u-boot/openwrt-version 2>/dev/null
    echo "KERNEL_VERSION='${build_usekernel}'" >> lib/u-boot/openwrt-version 2>/dev/null
    echo "K510='${K510}'" >> lib/u-boot/openwrt-version 2>/dev/null

    # Add firmware version information to the terminal page
    if  [ -f etc/banner ]; then
        op_version=$(echo $(ls lib/modules/ 2>/dev/null ))
        op_packaged_date=$(date +%Y-%m-%d)
        echo " Amlogic SoC: ${build_op}" >> etc/banner
        echo " Kernel: ${op_version}" >> etc/banner
        if  [ "${K510}" -eq "1" ]; then
            echo " Support install to EMMC: No" >> etc/banner
        else
            echo " Support install to EMMC: Yes" >> etc/banner
        fi
        echo " Install command: openwrt-install" >> etc/banner
        echo " Update command: openwrt-update" >> etc/banner
        echo " Backup & Restore command: openwrt-backup" >> etc/banner
        echo " View version command: openwrt-version" >> etc/banner
        echo " Packaged Date: ${op_packaged_date}" >> etc/banner
        echo " -----------------------------------------------------" >> etc/banner
    fi

    # Patches For openssl
    SSL_CNF_PATCH=${configfiles_path}/patches/openssl/openssl_engine.patch
    [ -f ${SSL_CNF_PATCH} ] && patch -p1 < ${SSL_CNF_PATCH} >/dev/null 2>&1

    # Patches For cpustat
    cpustat_file=${configfiles_path}/patches/cpustat/cpustat.py
    cpustat_patch=${configfiles_path}/patches/cpustat/luci-admin-status-index-html.patch
    [ -f ${cpustat_file} ] && cp -f ${cpustat_file} usr/bin/cpustat && chmod 755 usr/bin/cpustat >/dev/null 2>&1
    [ -f ${cpustat_patch} ] && cd usr/lib/lua/luci/view/admin_status && patch -p0 < ${cpustat_patch} >/dev/null 2>&1

    sync
    # Edit ${root}/* files ========== End ==========


    # Edit ${boot}/* files ========== Begin ==========
    cd ${boot}

    # Edit the uEnv.txt
    if [  ! -f "uEnv.txt" ]; then
       die "Error: uEnv.txt Files does not exist"
    else
       old_fdt_dtb="meson-gxl-s905d-phicomm-n1.dtb"
       sed -i "s/${old_fdt_dtb}/${FDTFILE}/g" uEnv.txt
    fi

    # Add u-boot.ext for 5.10 kernel
    if [[ "${K510}" -eq "1" && -n "${UBOOT_OVERLOAD}" ]]; then
       if [ -f ${uboot_path}/${UBOOT_OVERLOAD} ]; then
          cp -f ${uboot_path}/${UBOOT_OVERLOAD} u-boot.ext
       else
          die "${build_usekernel} have no the 5.10 kernel u-boot file: [ ${UBOOT_OVERLOAD} ]"
       fi
    fi

    sync
    #Edit ${boot}/* files ========== End ==========
}

make_image() {
    cd ${make_path}
    build_op=${1}
    build_image_file="${out_path}/openwrt_${build_op}_v${kernel}_$(date +"%Y.%m.%d.%H%M").img"
    rm -f ${build_image_file}
    sync

    [ -d ${out_path} ] || mkdir -p ${out_path}
    SKIP_MB=16
    fallocate -l $((SKIP_MB + BOOT_MB + rootsize))M ${build_image_file}

    parted -s ${build_image_file} mklabel msdos 2>/dev/null
    parted -s ${build_image_file} mkpart primary fat32 $((SKIP_MB))M $((SKIP_MB + BOOT_MB -1))M 2>/dev/null
    parted -s ${build_image_file} mkpart primary btrfs $((SKIP_MB + BOOT_MB))M 100% 2>/dev/null

    loop_setup ${build_image_file}
    mkfs.vfat -n "BOOT" ${loop}p1 >/dev/null 2>&1
    mkfs.btrfs -U ${ROOTFS_UUID} -L "ROOTFS" -m single ${loop}p2 >/dev/null 2>&1

    # Write the specified bootloader
    if  [[ "${MAINLINE_UBOOT}" != "" && -f "${root}${MAINLINE_UBOOT}" ]]; then
        dd if=${root}${MAINLINE_UBOOT} of=${loop} bs=1 count=442 conv=fsync 2>/dev/null
        dd if=${root}${MAINLINE_UBOOT} of=${loop} bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
        #echo -e "${build_op}_v${kernel} write Mainline bootloader: ${MAINLINE_UBOOT}"
    elif [[ "${ANDROID_UBOOT}" != ""  && -f "${root}${ANDROID_UBOOT}" ]]; then
        dd if=${root}${ANDROID_UBOOT} of=${loop} bs=1 count=442 conv=fsync 2>/dev/null
        dd if=${root}${ANDROID_UBOOT} of=${loop} bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
        #echo -e "${build_op}_v${kernel} write Android bootloader: ${ANDROID_UBOOT}"
    fi
}

copy2image() {
    cd ${make_path}
    build_op=${1}

    set -e

    local bootfs="${mount}/${kernel}/${build_op}/bootfs"
    local rootfs="${mount}/${kernel}/${build_op}/rootfs"

    mkdir -p ${bootfs} ${rootfs}
    if ! mount ${loop}p1 ${bootfs}; then
        die "mount ${loop}p1 failed!"
    fi
    if ! mount ${loop}p2 ${rootfs}; then
        die "mount ${loop}p2 failed!"
    fi

    cp -rf ${boot}/* ${bootfs}
    cp -rf ${root}/* ${rootfs}
    sync

    cd ${make_path}
    umount -f ${bootfs} 2>/dev/null
    umount -f ${rootfs} 2>/dev/null
    losetup -d ${loop} 2>/dev/null
}

get_firmwares() {
    firmwares=()
    i=0
    IFS=$'\n'

    [ -d "${openwrt_path}" ] && {
        for x in $(ls ${openwrt_path}); do
            firmwares[i++]=${x}
        done
    }
}

get_kernels() {
    kernels=()
    i=0
    IFS=$'\n'

    local kernel_root="${kernel_path}/kernel"
    [ -d ${kernel_root} ] && {
        work=$(pwd)
        cd ${kernel_root}
        for x in $(ls ./); do
            [[ -f "${x}/kernel.tar.xz" && -f "${x}/modules.tar.xz" ]] && kernels[i++]=${x}
        done
        cd ${work}
    }
}

show_kernels() {
    if [ ${#kernels[*]} = 0 ]; then
        die "No kernel files in [ ${kernel_path}/kernel ] directory!"
    else
        show_list "${kernels[*]}" "kernel"
    fi
}

show_list() {
    echo " ${2}: "
    i=0
    for x in ${1}; do
        echo " ($((++i))) ${x}"
    done
}

choose_firmware() {
    show_list "${firmwares[*]}" "firmware"
    choose_files ${#firmwares[*]} "firmware"
    firmware=${firmwares[opt]}
    tag ${firmware} && echo
}

choose_kernel() {
    show_kernels
    choose_files ${#kernels[*]} "kernel"
    kernel=${kernels[opt]}
    tag ${kernel} && echo
}

choose_files() {
    local len=${1}

    if [ "${len}" = 1 ]; then
        opt=0
    else
        i=0
        while true; do
            echo && read -p " select ${2} above, and press Enter to select the first one: " ${opt}
            [ ${opt} ] || opt=1
            if [[ "${opt}" -ge 1 && "${opt}" -le "${len}" ]]; then
                ((opt--))
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
 if you don't know what this means, press Enter to keep default: " ${rootsize}
        [ ${rootsize} ] || rootsize=${ROOT_MB}
        if [[ "${rootsize}" -ge 256 ]]; then
            tag ${rootsize} && echo
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
    -c, --clean            clean up the output and temporary directories

    -d, --default          the kernel version is "all", and the rootfs partition size is "1024m"

    -b, --build=BUILD      Specify multiple cores, use "_" to connect
       , -b all            Compile all types of openwrt
       , -b s905x3         Specify a single openwrt for compilation
       , -b s905x3_s905d   Specify multiple openwrt, use "_" to connect

    -k=VERSION             set the kernel version, which must be in the "kernel" directory
       , -k all            build all the kernel version
       , -k latest         build the latest kernel version
       , -k 5.4.6          Specify a single kernel for compilation
       , -k 5.4.6_5.9.0    Specify multiple cores, use "_" to connect

    --kernel               show all kernel version in "kernel" directory

    -s, --size=SIZE        set the rootfs partition size, do not less than 256m

    -h, --help             display this help

EOF
}

##
[ $(id -u) = 0 ] || die "please run this script as root: [ sudo ./make ]"
echo -e "Welcome to use the OpenWrt packaging tool!\n"
echo -e "\n $(df -hT) \n"

cleanup
get_firmwares
get_kernels

while [ "${1}" ]; do
    case "${1}" in
    -h | --help)
        usage && exit
        ;;
    -c | --clean)
        cleanup
        rm -rf ${out_path}
        echo "Clean up ok!" && exit
        ;;

    -d | --default)
        : ${rootsize:=${ROOT_MB}}
        : ${firmware:="${firmwares[0]}"}
        : ${kernel:="all"}
        : ${build:="all"}
        ;;
    -b | --build)
        build=${2}
        if   [ "${build}" = "all" ]; then
             shift
        elif [ -n "${build}" ]; then
             unset build_openwrt
             oldIFS=$IFS
             IFS=_
             build_openwrt=(${build})
             IFS=$oldIFS
             unset build
             : ${build:="all"}
        else
             die "Invalid build [ ${2} ]!"
        fi
        shift
        ;;
    -k)
        kernel=${2}
        if   [ "${kernel}" = "all" ]; then
             shift
        elif [ "${kernel}" = "latest" ]; then
             kernel="${kernels[-1]}"
             shift
        elif [ -n "${kernel}" ]; then
             oldIFS=$IFS
             IFS=_
             kernels=(${kernel})
             IFS=$oldIFS
             unset kernel
             : ${kernel:="all"}
             shift
        else
             die "Invalid kernel [ ${2} ]!"
        fi
        ;;
    --kernel)
        show_kernels && exit
        ;;
    -s | --size)
        rootsize=${2}
        if [[ "${rootsize}" -ge 256 ]]; then
            shift
        else
            die "Invalid size [ ${2} ]!"
        fi
        ;;
    *)
        die "Invalid option [ ${1} ]!"
        ;;
    esac
    shift
done

if [ ${#firmwares[*]} = 0 ]; then
    die "No the [ openwrt-armvirt-64-default-rootfs.tar.gz ] file in [ ${openwrt_path} ] directory!"
fi

if [ ${#kernels[*]} = 0 ]; then
    die "No this kernel files in [ ${kernel_path}/kernel ] directory!"
fi

[ ${firmware} ] && echo " firmware   ==>   ${firmware}"
[ ${rootsize} ] && echo " rootsize   ==>   ${rootsize}"
[ ${make_path} ] && echo " make_path   ==>   ${make_path}"

[ ${firmware} ] || [ ${kernel} ] || [ ${rootsize} ] && echo

[ ${firmware} ] || choose_firmware
[ ${kernel} ] || choose_kernel
[ ${rootsize} ] || set_rootsize

[ ${kernel} != "all" ] && kernels=("${kernel}")
[ ${build} != "all" ] && build_openwrt=("${build}")

extract_openwrt

for b in ${build_openwrt[*]}; do
    for x in ${kernels[*]}; do
        {
            kernel=${x}
            build=${b}
            process " extract armbian files."
            extract_armbian ${b}
            utils ${b} ${x}
            process " make openwrt image."
            make_image ${b}
            process " copy files to image."
            copy2image ${b}
            process " generate success."
        } &
    done
done

wait
echo -e "\n $(df -hT) \n"

cleanup
chmod -R 777 ${out_path}

