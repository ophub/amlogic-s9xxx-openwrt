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
build_openwrt=("s905x3" "s905x2" "s905x" "s905w" "s905d" "s912" "s922x")
make_path=${PWD}
tmp_path=${make_path}/tmp
out_path=${make_path}/out
openwrt_path=${make_path}/openwrt-armvirt
amlogic_path=${make_path}/amlogic-s9xxx
kernel_path=${amlogic_path}/amlogic-kernel
armbian_path=${amlogic_path}/amlogic-armbian
uboot_path=${amlogic_path}/amlogic-u-boot
configfiles_path=${amlogic_path}/common-files
kernel_library="https://github.com/ophub/flippy-kernel/tree/main/library"
#kernel_library="https://github.com/ophub/flippy-kernel/trunk/library"
#===== Do not modify the following parameter settings, End =======

# Set firmware size ( BOOT_MB size >= 128, ROOT_MB size >= 320 )
BOOT_MB=256
ROOT_MB=1024

tag() {
    echo -e " [ \033[1;32m ${1} \033[0m ]"
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
    rm -rf ${tmp_path} 2>/dev/null
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
    kernel_dir="${kernel_path}/${kernel}"
    root="${tmp_path}/${kernel}/${build_op}/root"
    boot="${tmp_path}/${kernel}/${build_op}/boot"

    mkdir -p ${root} ${boot}

    tar -xJf "${armbian_path}/boot-common.tar.xz" -C ${boot}
    tar -xJf "${armbian_path}/firmware.tar.xz" -C ${root}

    if [ -f ${kernel_dir}/boot-* -a -f ${kernel_dir}/dtb-amlogic-* -a -f ${kernel_dir}/modules-* ]; then
        mkdir -p ${boot}/dtb/amlogic ${root}/lib/modules
        tar -xzf ${kernel_dir}/dtb-amlogic-*.tar.gz -C ${boot}/dtb/amlogic

        tar -xzf ${kernel_dir}/boot-*.tar.gz -C ${boot}
        mv -f ${boot}/uInitrd-* ${boot}/uInitrd && mv -f ${boot}/vmlinuz-* ${boot}/zImage 2>/dev/null

        tar -xzf ${kernel_dir}/modules-*.tar.gz -C ${root}/lib/modules
        cd ${root}/lib/modules/*/
        rm -rf *.ko
        find ./ -type f -name '*.ko' -exec ln -s {} ./ \;
        cd ${make_path} && sync
    else
        die "Have no kernel files in [ ${kernel_dir} ]"
    fi

    cp -rf ${root_comm}/* ${root}

    # Complete file for ${root}: [ /etc ], [ /lib/u-boot ] etc.
    [ "$(ls ${configfiles_path}/files 2>/dev/null | wc -w)" -ne "0" ] && cp -rf ${configfiles_path}/files/* ${root}
    sync
}

refactor_files() {
    cd ${make_path}
    build_op=${1}
    build_usekernel=${2}

    kernel_vermaj=$(echo ${build_usekernel} | grep -oE '^[1-9].[0-9]{1,3}')
    k510_ver=${kernel_vermaj%%.*}
    k510_maj=${kernel_vermaj##*.}
    if  [ "${k510_ver}" -eq "5" ];then
        if  [ "${k510_maj}" -ge "10" ];then
            K510="1"
        else
            K510="0"
        fi
    elif [ "${k510_ver}" -gt "5" ];then
        K510="1"
    else
        K510="0"
    fi

    case "${build_op}" in
        s905x3 | x96 | hk1 | h96 | ugoosx3)
            FDTFILE="meson-sm1-x96-max-plus-100m.dtb"
            UBOOT_OVERLOAD="u-boot-x96maxplus.bin"
            MAINLINE_UBOOT="/lib/u-boot/x96maxplus-u-boot.bin.sd.bin"
            ANDROID_UBOOT="/lib/u-boot/hk1box-bootloader.img"
            AMLOGIC_SOC="s905x3"
            ;;
        s905x2 | x96max4g | x96max2g)
            FDTFILE="meson-g12a-x96-max.dtb"
            UBOOT_OVERLOAD="u-boot-x96max.bin"
            MAINLINE_UBOOT="/lib/u-boot/x96max-u-boot.bin.sd.bin"
            ANDROID_UBOOT=""
            AMLOGIC_SOC="s905x2"
            ;;
        s905x | hg680p | b860h)
            FDTFILE="meson-gxl-s905x-p212.dtb"
            UBOOT_OVERLOAD="u-boot-p212.bin"
            MAINLINE_UBOOT=""
            ANDROID_UBOOT=""
            AMLOGIC_SOC="s905x"
            ;;
        s905w | x96mini | tx3mini)
            FDTFILE="meson-gxl-s905w-tx3-mini.dtb"
            UBOOT_OVERLOAD="u-boot-s905x-s912.bin"
            MAINLINE_UBOOT=""
            ANDROID_UBOOT=""
            AMLOGIC_SOC="s905w"
            ;;
        s905d | n1)
            FDTFILE="meson-gxl-s905d-phicomm-n1.dtb"
            UBOOT_OVERLOAD="u-boot-n1.bin"
            MAINLINE_UBOOT=""
            ANDROID_UBOOT="/lib/u-boot/u-boot-2015-phicomm-n1.bin"
            AMLOGIC_SOC="s905d"
            ;;
        s912 | h96proplus | octopus)
            FDTFILE="meson-gxm-octopus-planet.dtb"
            UBOOT_OVERLOAD="u-boot-zyxq.bin"
            MAINLINE_UBOOT=""
            ANDROID_UBOOT=""
            AMLOGIC_SOC="s912"
            ;;
        s922x | belink | belinkpro | ugoos)
            FDTFILE="meson-g12b-gtking-pro.dtb"
            UBOOT_OVERLOAD="u-boot-gtkingpro.bin"
            MAINLINE_UBOOT="/lib/u-boot/gtkingpro-u-boot.bin.sd.bin"
            ANDROID_UBOOT=""
            AMLOGIC_SOC="s922x"
            ;;
        *)
            die "Have no this firmware: [ ${build_op} - ${kernel} ]"
            ;;
    esac

    # Edit ${root}/* files ========== Begin ==========
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

    mkdir -p etc/modprobe.d
    cat > etc/modprobe.d/99-local.conf <<EOF
blacklist snd_soc_meson_aiu_i2s
alias brnf br_netfilter
alias pwm pwm_meson
alias wifi brcmfmac
EOF

    # echo br_netfilter > etc/modules.d/br_netfilter
    echo pwm_meson > etc/modules.d/pwm_meson 2>/dev/null
    echo panfrost > etc/modules.d/panfrost 2>/dev/null
    echo meson_gxbb_wdt > etc/modules.d/watchdog 2>/dev/null

    # Edit fstab
    ROOTFS_UUID=$(uuidgen)
    #echo "ROOTFS_UUID: ${ROOTFS_UUID}"
    sed -i "s/LABEL=ROOTFS/UUID=${ROOTFS_UUID}/" etc/fstab 2>/dev/null
    sed -i "s/option label 'ROOTFS'/option uuid '${ROOTFS_UUID}'/" etc/config/fstab 2>/dev/null
    
    # Turn off speed limit by default
    [ -f etc/config/nft-qos ] && sed -i "s|option limit_enable.*|option limit_enable '0'|g" etc/config/nft-qos

    # Turn off hw_flow by default
    [ -f etc/config/turboacc ] && sed -i "s|option hw_flow.*|option hw_flow '0'|g" etc/config/turboacc
    [ -f etc/config/turboacc ] && sed -i "s|option sfe_flow.*|option sfe_flow '0'|g" etc/config/turboacc

    # Add drivers
    [ -f etc/modules.d/8189fs ] || echo "8189fs" > etc/modules.d/8189fs
    [ -f etc/modules.d/8188fu ] || echo "8188fu" > etc/modules.d/8188fu
    [ -f etc/modules.d/usb-net-rtl8150 ] || echo "rtl8150" > etc/modules.d/usb-net-rtl8150
    [ -f etc/modules.d/usb-net-rtl8152 ] || echo "r8152" > etc/modules.d/usb-net-rtl8152
    [ -f etc/modules.d/usb-net-asix-ax88179 ] || echo "ax88179_178a" > etc/modules.d/usb-net-asix-ax88179

    # Add cpustat
    cpustat_file=${configfiles_path}/patches/cpustat
    if [[ -d "${cpustat_file}" && -x "bin/bash" ]]; then
        cp -f ${cpustat_file}/cpustat usr/bin/cpustat && chmod +x usr/bin/cpustat >/dev/null 2>&1
        cp -f ${cpustat_file}/getcpu bin/getcpu && chmod +x bin/getcpu >/dev/null 2>&1
        cp -f ${cpustat_file}/30-sysinfo.sh etc/profile.d/30-sysinfo.sh >/dev/null 2>&1
        sed -i "s/\/bin\/ash/\/bin\/bash/" etc/passwd >/dev/null 2>&1
        sed -i "s/\/bin\/ash/\/bin\/bash/" usr/libexec/login.sh >/dev/null 2>&1
        sync
    fi

    # Modify the cpu mode to schedutil
    if [[ -f "etc/config/cpufreq" ]];then
        sed -i "s/ondemand/schedutil/" etc/config/cpufreq
    fi

    # Add balethirq
    balethirq_file=${configfiles_path}/patches/balethirq
    if [ -d "${balethirq_file}" ];then
        cp -f ${balethirq_file}/balethirq.pl usr/sbin/balethirq.pl && chmod +x usr/sbin/balethirq.pl >/dev/null 2>&1
        sed -i "/exit/i\/usr/sbin/balethirq.pl" etc/rc.local >/dev/null 2>&1
        cp -f ${balethirq_file}/balance_irq etc/config/balance_irq >/dev/null 2>&1
        sync
    fi
    
    # Add firmware information to the etc/flippy-openwrt-release
    echo "FDTFILE='${FDTFILE}'" >> etc/flippy-openwrt-release 2>/dev/null
    echo "U_BOOT_EXT='${K510}'" >> etc/flippy-openwrt-release 2>/dev/null
    echo "UBOOT_OVERLOAD='${UBOOT_OVERLOAD}'" >> etc/flippy-openwrt-release 2>/dev/null
    echo "MAINLINE_UBOOT='${MAINLINE_UBOOT}'" >> etc/flippy-openwrt-release 2>/dev/null
    echo "ANDROID_UBOOT='${ANDROID_UBOOT}'" >> etc/flippy-openwrt-release 2>/dev/null
    echo "KERNEL_VERSION='${build_usekernel}'" >> etc/flippy-openwrt-release 2>/dev/null
    echo "SOC='${AMLOGIC_SOC}'" >> etc/flippy-openwrt-release 2>/dev/null
    echo "K510='${K510}'" >> etc/flippy-openwrt-release 2>/dev/null

    # Add firmware version information to the terminal page
    if  [ -f etc/banner ]; then
        op_version=$(echo $(ls lib/modules/ 2>/dev/null ))
        op_packaged_date=$(date +%Y-%m-%d)
        echo " Install: OpenWrt → System → Amlogic Service → Install" >> etc/banner
        echo " Amlogic SoC: ${build_op}" >> etc/banner
        echo " OpenWrt Kernel: ${op_version}" >> etc/banner
        echo " Packaged Date: ${op_packaged_date}" >> etc/banner
        echo " -----------------------------------------------------" >> etc/banner
    fi

    # Add some package and script connection
    ln -sf /usr/bin/openwrt-install-amlogic usr/bin/openwrt-install 2>/dev/null
    ln -sf /usr/bin/openwrt-update-amlogic usr/bin/openwrt-update 2>/dev/null

    sync
    # Edit ${root}/* files ========== End ==========


    # Edit ${boot}/* files ========== Begin ==========
    cd ${boot}

    # Edit the uEnv.txt
    if [  ! -f "uEnv.txt" ]; then
       die "The uEnv.txt File does not exist"
    else
       old_fdt_dtb="meson-gxl-s905d-phicomm-n1.dtb"
       sed -i "s/${old_fdt_dtb}/${FDTFILE}/g" uEnv.txt
    fi

    # Add u-boot.ext for 5.10 kernel
    if [[ "${K510}" -eq "1" && -n "${UBOOT_OVERLOAD}" ]]; then
       if [ -f "${uboot_path}/${UBOOT_OVERLOAD}" ]; then
          cp -f ${uboot_path}/${UBOOT_OVERLOAD} u-boot.ext && sync && chmod +x u-boot.ext
       else
          die "${build_usekernel} have no the 5.10 kernel u-boot file: [ ${UBOOT_OVERLOAD} ]"
       fi
    fi

    # Add ${UBOOT_OVERLOAD} to support kernel update to 5.10 and above
    if [[ -n "${UBOOT_OVERLOAD}" && -f "${uboot_path}/${UBOOT_OVERLOAD}" ]]; then
        cp -f ${uboot_path}/${UBOOT_OVERLOAD} . && sync && chmod +x ${UBOOT_OVERLOAD}
    fi

    sync
    # Edit ${boot}/* files ========== End ==========
}

make_image() {
    cd ${make_path}
    build_op=${1}
    build_image_file="${out_path}/openwrt_${build_op}_k${kernel}_$(date +"%Y.%m.%d.%H%M").img"
    rm -f ${build_image_file}
    sync

    [ -d ${out_path} ] || mkdir -p ${out_path}
    SKIP_MB=16
    IMG_SIZE=$((SKIP_MB + BOOT_MB + rootsize))

    #fallocate -l ${IMG_SIZE}M ${build_image_file}
    dd if=/dev/zero of=${build_image_file} bs=1M count=${IMG_SIZE} 2>/dev/null && sync

    parted -s ${build_image_file} mklabel msdos 2>/dev/null
    parted -s ${build_image_file} mkpart primary fat32 $((SKIP_MB))M $((SKIP_MB + BOOT_MB -1))M 2>/dev/null
    parted -s ${build_image_file} mkpart primary btrfs $((SKIP_MB + BOOT_MB))M 100% 2>/dev/null
    #parted -s ${build_image_file} print 2>/dev/null

    loop_setup ${build_image_file}
    mkfs.vfat -n "BOOT" ${loop}p1 >/dev/null 2>&1
    mkfs.btrfs -U ${ROOTFS_UUID} -L "ROOTFS" -m single ${loop}p2 >/dev/null 2>&1
    sync

    # Write the specified bootloader
    if  [[ "${MAINLINE_UBOOT}" != "" && -f "${root}${MAINLINE_UBOOT}" ]]; then
        dd if=${root}${MAINLINE_UBOOT} of=${loop} bs=1 count=444 conv=fsync 2>/dev/null
        dd if=${root}${MAINLINE_UBOOT} of=${loop} bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
        #echo -e "${build_op}_v${kernel} write Mainline bootloader: ${MAINLINE_UBOOT}"
    elif [[ "${ANDROID_UBOOT}" != ""  && -f "${root}${ANDROID_UBOOT}" ]]; then
        dd if=${root}${ANDROID_UBOOT} of=${loop} bs=1 count=444 conv=fsync 2>/dev/null
        dd if=${root}${ANDROID_UBOOT} of=${loop} bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
        #echo -e "${build_op}_v${kernel} write Android bootloader: ${ANDROID_UBOOT}"
    fi
    sync
}

copy2image() {
    cd ${make_path}
    build_op=${1}

    set -e

    local bootfs="${mount}/${kernel}/${build_op}/bootfs"
    local rootfs="${mount}/${kernel}/${build_op}/rootfs"

    mkdir -p ${bootfs} ${rootfs} && sync
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
    sync

    cd ${out_path} && gzip *.img && sync && cd ${make_path}
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

    local kernel_root="${kernel_path}"
    [ -d ${kernel_root} ] && {
        work=$(pwd)
        cd ${kernel_root}
        for x in $(ls ./); do
            [ "$( ls ${x}/*.tar.gz -l 2>/dev/null | grep "^-" | wc -l )" -ge "3" ] && kernels[i++]=${x}
        done
        cd ${work}
    }
}

show_kernels() {
    if [ ${#kernels[*]} = 0 ]; then
        die "No kernel files in [ ${kernel_path} ] directory!"
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
            echo && read -p " select ${2} above, and press Enter to select the first one: " opt
            [ ${opt} ] || opt=1
            if [[ "${opt}" -ge "1" && "${opt}" -le "${len}" ]]; then
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

choose_build() {
    i=1
    for var in  ${build_openwrt[*]}; do
        echo " (${i}) ${var}"
        let i++
    done
    echo && read -p " Please select the Amlogic SoC: " pause
    case  $pause in
          s905x3 | 1) build="s905x3" ;;
          s905x2 | 2) build="s905x2" ;;
          s905x | 3) build="s905x" ;;
          s905d | 4) build="s905d" ;;
          s912 | 5) build="s912" ;;
          s922x | 6) build="s922x" ;;
          *) die "Have no this Amlogic SoC" ;;
    esac
    tag ${build}
}

set_rootsize() {
    i=0
    rootsize=

    while true; do
        echo && read -p " input the rootfs partition size(mb) numerical value, defaults to 1024, do not less than 256
 if you don't know what this means, press Enter to keep default: " rootsize
        [ ${rootsize} ] || rootsize=${ROOT_MB}
        if [[ "${rootsize}" -ge "256" ]]; then
            tag ${rootsize} && echo
            break
        else
            ((i++ >= 2)) && exit 1
            error "Numerical value input error, try again!\n"
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

    -d, --default          the kernel version is "latest", and the rootfs partition size is "1024m"

    -b, --build=BUILD      Specify multiple cores, use "_" to connect
      , -b all             Compile all types of openwrt
      , -b s905x3          Specify a single openwrt for compilation
      , -b s905x3_s905d    Specify multiple openwrt, use "_" to connect

    -k=VERSION             set the kernel version, which must be in the "kernel" directory
      , -k all             build all the kernel version
      , -k latest          build the latest kernel version
      , -k 5.4.6           Specify a single kernel for compilation
      , -k 5.4.6_5.9.0     Specify multiple cores, use "_" to connect

    -u, --update           Whether to auto update to the latest kernel of the same series
      , -u ture            Auto update to the latest kernel
      , -u false           Do not upgrade, compile the specified kernel

    --kernel               show all kernel version in "kernel" directory

    -s, --size=SIZE        set the rootfs partition size, do not less than 256m

    -h, --help             display this help

EOF
}

[ $(id -u) = 0 ] || die "please run this script as root: [ sudo ./make ]"
echo -e "Welcome to use the OpenWrt packaging tool! \n"
echo -e "Server space usage before starting to compile: \n$(df -hT ${PWD}) \n"

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
            : ${kernel:="${kernels[-1]}"}
            : ${build:="all"}
            : ${auto_kernel:="true"}
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
                 shift
            else
                 die "Invalid build [ ${2} ]!"
            fi
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
        -a | --autokernel)
            auto_kernel=${2}
            if [ -n "${auto_kernel}" ]; then
                shift
            else
                die "Invalid size [ ${2} ]!"
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
    die "No this kernel files in [ ${kernel_path} ] directory!"
fi

[ ${firmware} ] && echo " firmware   ==>   ${firmware}"
[ ${rootsize} ] && echo " rootsize   ==>   ${rootsize}"
[ ${make_path} ] && echo " make_path   ==>   ${make_path}"

[ ${firmware} ] || [ ${kernel} ] || [ ${rootsize} ] && echo

[ ${firmware} ] || choose_firmware
[ ${kernel} ] || choose_kernel
[ ${build} ] || choose_build
[ ${rootsize} ] || set_rootsize

[ ${kernel} != "all" ] && unset kernels && kernels=(${kernel})
[ ${build} != "all" ] && unset build_openwrt && build_openwrt=(${build})

# Convert kernel library address to svn format
if [[ ${kernel_library} == http* && $(echo ${kernel_library} | grep "tree/main") != "" ]]; then
    kernel_library=${kernel_library//tree\/main/trunk}
fi

# Check the new version on the kernel library, when auto_kernel=true
if [[ -n "${auto_kernel}" && "${auto_kernel}" == "true" ]]; then

    # Set empty array
    TMP_ARR_KERNELS=()

    # Convert kernel library address to API format
    SERVER_KERNEL_URL=${kernel_library#*com\/}
    SERVER_KERNEL_URL=${SERVER_KERNEL_URL//trunk/contents}
    SERVER_KERNEL_URL="https://api.github.com/repos/${SERVER_KERNEL_URL}"

    # Query the latest kernel in a loop
    i=1
    for KERNEL_VAR in ${kernels[*]}; do
        echo -e "(${i}) Auto query the latest kernel version of the same series for [ ${KERNEL_VAR} ]"
        MAIN_LINE_M=$(echo "${KERNEL_VAR}" | cut -d '.' -f1)
        MAIN_LINE_V=$(echo "${KERNEL_VAR}" | cut -d '.' -f2)
        MAIN_LINE_S=$(echo "${KERNEL_VAR}" | cut -d '.' -f3)
        MAIN_LINE="${MAIN_LINE_M}.${MAIN_LINE_V}"
        # Check the version on the server (e.g LATEST_VERSION="124")
        LATEST_VERSION=$(curl -s "${SERVER_KERNEL_URL}" | grep "name" | grep -oE "${MAIN_LINE}.[0-9]+"  | sed -e "s/${MAIN_LINE}.//g" | sort -n | sed -n '$p')
        if [[ "$?" -eq "0" && ! -z "${LATEST_VERSION}" ]]; then
            TMP_ARR_KERNELS[${i}]="${MAIN_LINE}.${LATEST_VERSION}"
        else
            TMP_ARR_KERNELS[${i}]="${KERNEL_VAR}"
        fi
        echo -e "(${i}) [ ${TMP_ARR_KERNELS[$i]} ] is latest kernel. \n"

        let i++
    done

    # Reset the kernel array to the latest kernel version
    unset kernels
    kernels=${TMP_ARR_KERNELS[*]}

fi

# Synchronization related kernel
i=1
for KERNEL_VAR in ${kernels[*]}; do
    if [ ! -d "${kernel_path}/${KERNEL_VAR}" ]; then
        echo -e "(${i}) [ ${KERNEL_VAR} ] Kernel loading from [ ${kernel_library}/${KERNEL_VAR} ]"
        svn checkout ${kernel_library}/${KERNEL_VAR} ${kernel_path}/${KERNEL_VAR} >/dev/null
        rm -rf ${kernel_path}/${KERNEL_VAR}/.svn >/dev/null && sync
    else
        echo -e "(${i}) [ ${KERNEL_VAR} ] Kernel is in the local directory."
    fi

    let i++
done

echo -e "Ready, start packaging... \n"

# Start loop compilation
k=1
for b in ${build_openwrt[*]}; do

    i=1
    for x in ${kernels[*]}; do
        {
            echo -n "(${k}.${i}) Start packaging OpenWrt [ ${b} - ${x} ]. "

            now_remaining_space=$(df -hT ${PWD} | grep '/dev/' | awk '{print $5}' | sed 's/.$//')
            if  [[ "${now_remaining_space}" -le "2" ]]; then
                echo "Remaining space is less than 2G, exit this packaging. \n"
                break 2
            else
                echo "Remaining space is ${now_remaining_space}G."
            fi
            
            kernel=${x}
            build=${b}
            process " (1/6) extract armvirt files."
            extract_openwrt
            process " (2/6) extract armbian files."
            extract_armbian ${b}
            process " (3/6) refactor related files."
            refactor_files ${b} ${x}
            process " (4/6) make openwrt image."
            make_image ${b}
            process " (5/6) copy files to image."
            copy2image ${b}
            process " (6/6) cleanup tmp files."
            cleanup
            
            echo -e "(${k}.${i}) OpenWrt packaged successfully. \n"
            
            let i++
        }
    done
    
    let k++
done

cp -f ${openwrt_path}/*.tar.gz ${out_path} 2>/dev/null && sync
echo -e "Server space usage after compilation: \n$(df -hT ${PWD}) \n"

wait
chmod -R 777 ${out_path}

