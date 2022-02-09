#!/bin/bash
#========================================================================
# This file is licensed under the terms of the GNU General Public
# License version 2. This program is licensed "as is" without any
# warranty of any kind, whether express or implied.
#
# This file is a part of the make OpenWrt for Amlogic s9xxx tv box
# https://github.com/ophub/amlogic-s9xxx-openwrt
#
# Description: Automatically Packaged OpenWrt for Amlogic s9xxx tv box
# Copyright (C) 2020- https://github.com/unifreq
# Copyright (C) 2020- https://github.com/tuanqing/mknop
# Copyright (C) 2020- https://github.com/ophub/amlogic-s9xxx-openwrt
#
# Command: sudo ./make -d
# Command optional parameters please refer to the source code repository
#========================================================================

#===== Do not modify the following parameter settings, Start =====
make_path=${PWD}
tmp_path=${make_path}/tmp
out_path=${make_path}/out
openwrt_path=${make_path}/openwrt-armvirt
openwrt_file="openwrt-armvirt-64-default-rootfs.tar.gz"
amlogic_path=${make_path}/amlogic-s9xxx
kernel_path=${amlogic_path}/amlogic-kernel
armbian_path=${amlogic_path}/amlogic-armbian
uboot_path=${amlogic_path}/amlogic-u-boot
configfiles_path=${amlogic_path}/common-files
op_release="etc/flippy-openwrt-release"
build_openwrt=("s922x" "s922x-n2" "s922x-reva" "s905x3" "s905x2" "s912" "s912-t95z" "s905" "s905d" "s905d-ki" "s905x" "s905w")

kernel_library="https://github.com/ophub/kernel/tree/main/pub"
#kernel_library="https://github.com/ophub/kernel/trunk/pub"
version_branch="stable"
auto_kernel="true"
build_kernel=("5.10.90" "5.4.170")

# Set firmware size (BOOT_MB >= 128, ROOT_MB >= 512)
SKIP_MB=16
BOOT_MB=256
ROOT_MB=960
#===== Do not modify the following parameter settings, End =======

error_msg() {
    echo -e " [\033[1;91m Error \033[0m] ${1}"
    exit 1
}

process_msg() {
    echo -e " [ \033[1;92m ${build} \033[0m - \033[1;92m ${kernel} \033[0m ] ${1}"
}

loop_setup() {
    loop=$(losetup -P -f --show "${1}")
    [ ${loop} ] || error_msg "losetup ${1} failed."
}

download_kernel() {
    # Convert kernel library address to svn format
    if [[ ${kernel_library} == http* && $(echo ${kernel_library} | grep "tree/main") != "" ]]; then
        kernel_library="${kernel_library//tree\/main/trunk}"
    fi
    kernel_library="${kernel_library}/${version_branch}"

    # Set empty array
    tmp_arr_kernels=()

    # Convert kernel library address to API format
    server_kernel_url=${kernel_library#*com\/}
    server_kernel_url=${server_kernel_url//trunk/contents}
    server_kernel_url="https://api.github.com/repos/${server_kernel_url}"

    # Query the latest kernel in a loop
    i=1
    for KERNEL_VAR in ${build_kernel[*]}; do
        echo -e "(${i}) Auto query the latest kernel version of the same series for [ ${KERNEL_VAR} ]"
        MAIN_LINE_M=$(echo "${KERNEL_VAR}" | cut -d '.' -f1)
        MAIN_LINE_V=$(echo "${KERNEL_VAR}" | cut -d '.' -f2)
        MAIN_LINE_S=$(echo "${KERNEL_VAR}" | cut -d '.' -f3)
        MAIN_LINE="${MAIN_LINE_M}.${MAIN_LINE_V}"
        # Check the version on the server (e.g LATEST_VERSION="124")
        LATEST_VERSION=$(curl -s "${server_kernel_url}" | grep "name" | grep -oE "${MAIN_LINE}.[0-9]+" | sed -e "s/${MAIN_LINE}.//g" | sort -n | sed -n '$p')
        if [[ "$?" -eq "0" && ! -z "${LATEST_VERSION}" ]]; then
            tmp_arr_kernels[${i}]="${MAIN_LINE}.${LATEST_VERSION}"
        else
            tmp_arr_kernels[${i}]="${KERNEL_VAR}"
        fi
        echo -e "(${i}) [ ${tmp_arr_kernels[$i]} ] is latest kernel. \n"

        let i++
    done

    # Reset the kernel array to the latest kernel version
    unset build_kernel
    build_kernel=${tmp_arr_kernels[*]}

    # Synchronization related kernel
    i=1
    for KERNEL_VAR in ${build_kernel[*]}; do
        if [ ! -d "${kernel_path}/${KERNEL_VAR}" ]; then
            echo -e "(${i}) [ ${KERNEL_VAR} ] Kernel loading from [ ${kernel_library}/${KERNEL_VAR} ]"
            svn export ${kernel_library}/${KERNEL_VAR} ${kernel_path}/${KERNEL_VAR} --force
        else
            echo -e "(${i}) [ ${KERNEL_VAR} ] Kernel is in the local directory."
        fi

        let i++
    done

    sync
}

extract_openwrt() {
    cd ${make_path}
    local firmware="${openwrt_path}/${openwrt_file}"

    root_comm="${tmp_path}/root_comm"
    mkdir -p ${root_comm}

    tar -xzf ${firmware} -C ${root_comm}
    rm -rf ${root_comm}/lib/modules/*/
    sync
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
    sync

    if [ -f ${kernel_dir}/boot-* -a -f ${kernel_dir}/dtb-amlogic-* -a -f ${kernel_dir}/modules-* ]; then
        mkdir -p ${boot}/dtb/amlogic ${root}/lib/modules
        tar -xzf ${kernel_dir}/dtb-amlogic-*.tar.gz -C ${boot}/dtb/amlogic
        sync

        tar -xzf ${kernel_dir}/boot-*.tar.gz -C ${boot}
        mv -f ${boot}/uInitrd-* ${boot}/uInitrd && mv -f ${boot}/vmlinuz-* ${boot}/zImage 2>/dev/null
        sync

        tar -xzf ${kernel_dir}/modules-*.tar.gz -C ${root}/lib/modules
        cd ${root}/lib/modules/*/
        rm -rf *.ko
        find ./ -type f -name '*.ko' -exec ln -s {} ./ \;
        sync
    else
        error_msg "Have no kernel files in [ ${kernel_dir} ]"
    fi

    cd ${make_path}
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
    if [ "${k510_ver}" -eq "5" ]; then
        if [ "${k510_maj}" -ge "10" ]; then
            K510="1"
        else
            K510="0"
        fi
    elif [ "${k510_ver}" -gt "5" ]; then
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
    s905x2-km3)
        FDTFILE="meson-g12a-sei510.dtb"
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
    s905d-ki)
        FDTFILE="meson-gxl-s905d-mecool-ki-pro.dtb"
        UBOOT_OVERLOAD="u-boot-p201.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT=""
        AMLOGIC_SOC="s905d"
        ;;
    s905 | beelinkminimx | mxqpro+)
        FDTFILE="meson-gxbb-vega-s95-telos.dtb"
        #FDTFILE="meson-gxbb-mxq-pro-plus.dtb"
        UBOOT_OVERLOAD="u-boot-s905.bin"
        #UBOOT_OVERLOAD="u-boot-p201.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT=""
        AMLOGIC_SOC="s905"
        ;;
    s912 | h96proplus | octopus)
        FDTFILE="meson-gxm-octopus-planet.dtb"
        UBOOT_OVERLOAD="u-boot-zyxq.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT=""
        AMLOGIC_SOC="s912"
        ;;
    s912-t95z | s912-t95z-plus)
        FDTFILE="meson-gxm-t95z-plus.dtb"
        UBOOT_OVERLOAD="u-boot-s905x-s912.bin"
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
    s922x-n2 | odroid-n2 | n2)
        FDTFILE="meson-g12b-odroid-n2.dtb"
        UBOOT_OVERLOAD="u-boot-gtkingpro.bin"
        MAINLINE_UBOOT="/lib/u-boot/odroid-n2-u-boot.bin.sd.bin"
        ANDROID_UBOOT=""
        AMLOGIC_SOC="s922x"
        ;;
    s922x-reva)
        FDTFILE="meson-g12b-gtking-pro.dtb"
        UBOOT_OVERLOAD="u-boot-gtkingpro-rev-a.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT=""
        AMLOGIC_SOC="s922x"
        ;;
    *)
        error_msg "Have no this firmware: [ ${build_op} - ${kernel} ]"
        ;;
    esac

    # Edit ${root}/* files ========== Begin ==========
    cd ${root}

    # Add other operations below
    echo 'pwm_meson' >etc/modules.d/pwm-meson
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
    cat >etc/modprobe.d/99-local.conf <<EOF
blacklist snd_soc_meson_aiu_i2s
alias brnf br_netfilter
alias pwm pwm_meson
alias wifi brcmfmac
EOF

    # echo br_netfilter > etc/modules.d/br_netfilter
    echo pwm_meson >etc/modules.d/pwm_meson 2>/dev/null
    echo panfrost >etc/modules.d/panfrost 2>/dev/null
    echo meson_gxbb_wdt >etc/modules.d/watchdog 2>/dev/null

    # Generate UUID
    ROOTFS_UUID="$(cat /proc/sys/kernel/random/uuid)"
    [ -z "${ROOTFS_UUID}" ] && ROOTFS_UUID="$(uuidgen)"
    [ -z "${ROOTFS_UUID}" ] && error_msg "The uuidgen is invalid, cannot continue."
    #echo "ROOTFS_UUID: ${ROOTFS_UUID}"

    # Edit fstab
    sed -i "s/LABEL=ROOTFS/UUID=${ROOTFS_UUID}/" etc/fstab 2>/dev/null
    sed -i "s/option label 'ROOTFS'/option uuid '${ROOTFS_UUID}'/" etc/config/fstab 2>/dev/null

    # Turn off speed limit by default
    [ -f etc/config/nft-qos ] && sed -i "s|option limit_enable.*|option limit_enable '0'|g" etc/config/nft-qos

    # Turn off hw_flow by default
    [ -f etc/config/turboacc ] && sed -i "s|option hw_flow.*|option hw_flow '0'|g" etc/config/turboacc
    [ -f etc/config/turboacc ] && sed -i "s|option sfe_flow.*|option sfe_flow '0'|g" etc/config/turboacc

    # Add USB and wireless network drivers
    [ -f etc/modules.d/usb-net-rtl8150 ] || echo "rtl8150" >etc/modules.d/usb-net-rtl8150
    # USB RTL8152/8153/8156 network card Driver
    [ -f etc/modules.d/usb-net-rtl8152 ] || echo "r8152" >etc/modules.d/usb-net-rtl8152
    # USB AX88179 network card Driver
    [ -f etc/modules.d/usb-net-asix-ax88179 ] || echo "ax88179_178a" >etc/modules.d/usb-net-asix-ax88179
    # brcmfmac built-in wireless network card Driver
    echo "brcmfmac" >etc/modules.d/brcmfmac
    echo "brcmutil" >etc/modules.d/brcmutil
    # USB Realtek RTL8188EU Wireless LAN Driver
    echo "r8188eu" >etc/modules.d/rtl8188eu
    # Realtek RTL8189FS Wireless LAN Driver
    echo "8189fs" >etc/modules.d/8189fs
    # Realtek RTL8188FU Wireless LAN Driver
    echo "rtl8188fu" >etc/modules.d/rtl8188fu
    # Realtek RTL8822CS Wireless LAN Driver
    echo "88x2cs" >etc/modules.d/88x2cs
    # USB Ralink Wireless LAN Driver
    echo "rt2500usb" >etc/modules.d/rt2500-usb
    echo "rt2800usb" >etc/modules.d/rt2800-usb
    echo "rt2x00usb" >etc/modules.d/rt2x00-usb
    # USB Mediatek Wireless LAN Driver
    echo "mt7601u" >etc/modules.d/mt7601u
    echo "mt7663u" >etc/modules.d/mt7663u
    echo "mt76x0u" >etc/modules.d/mt76x0u
    echo "mt76x2u" >etc/modules.d/mt76x2u
    # GPU Driver
    echo "panfrost" >etc/modules.d/panfrost
    # PWM Driver
    echo "pwm_meson" >etc/modules.d/pwm_meson

    # Add cpustat
    DISTRIB_SOURCECODE="$(cat etc/openwrt_release | grep "DISTRIB_SOURCECODE=" | awk -F "'" '{print $2}')"
    cpustat_file=${configfiles_path}/patches/cpustat
    if [[ -d "${cpustat_file}" && -x "bin/bash" && "${DISTRIB_SOURCECODE}" == "lede" ]]; then
        cp -f ${cpustat_file}/cpustat usr/bin/cpustat && chmod +x usr/bin/cpustat >/dev/null 2>&1
        cp -f ${cpustat_file}/getcpu bin/getcpu && chmod +x bin/getcpu >/dev/null 2>&1
        cp -f ${cpustat_file}/30-sysinfo.sh etc/profile.d/30-sysinfo.sh >/dev/null 2>&1
        sed -i "s/\/bin\/ash/\/bin\/bash/" etc/passwd >/dev/null 2>&1
        sed -i "s/\/bin\/ash/\/bin\/bash/" usr/libexec/login.sh >/dev/null 2>&1
    fi

    # Modify the cpu mode to schedutil
    if [[ -f "etc/config/cpufreq" ]]; then
        sed -i "s/ondemand/schedutil/" etc/config/cpufreq
    fi

    # Add balethirq
    balethirq_file=${configfiles_path}/patches/balethirq
    if [ -d "${balethirq_file}" ]; then
        cp -f ${balethirq_file}/balethirq.pl usr/sbin/balethirq.pl && chmod +x usr/sbin/balethirq.pl >/dev/null 2>&1
        sed -i "/exit/i\/usr/sbin/balethirq.pl" etc/rc.local >/dev/null 2>&1
        cp -f ${balethirq_file}/balance_irq etc/balance_irq >/dev/null 2>&1
    fi

    # Add firmware information
    echo "FDTFILE='${FDTFILE}'" >>${op_release} 2>/dev/null
    echo "U_BOOT_EXT='${K510}'" >>${op_release} 2>/dev/null
    echo "UBOOT_OVERLOAD='${UBOOT_OVERLOAD}'" >>${op_release} 2>/dev/null
    echo "MAINLINE_UBOOT='${MAINLINE_UBOOT}'" >>${op_release} 2>/dev/null
    echo "ANDROID_UBOOT='${ANDROID_UBOOT}'" >>${op_release} 2>/dev/null
    echo "KERNEL_VERSION='${build_usekernel}'" >>${op_release} 2>/dev/null
    echo "SOC='${AMLOGIC_SOC}'" >>${op_release} 2>/dev/null
    echo "K510='${K510}'" >>${op_release} 2>/dev/null

    # Add firmware version information to the terminal page
    if [ -f etc/banner ]; then
        op_version=$(echo $(ls lib/modules/ 2>/dev/null))
        op_packaged_date=$(date +%Y-%m-%d)
        echo " Install: OpenWrt → System → Amlogic Service → Install" >>etc/banner
        echo " Update: OpenWrt → System → Amlogic Service → Update" >>etc/banner
        echo " Amlogic SoC: ${build_op}" >>etc/banner
        echo " OpenWrt Kernel: ${op_version}" >>etc/banner
        echo " Packaged Date: ${op_packaged_date}" >>etc/banner
        echo " -------------------------------------------------------" >>etc/banner
    fi

    # Add some package and script connection
    ln -sf /usr/sbin/openwrt-backup usr/sbin/flippy 2>/dev/null

    # Add rtl8189fs & rtl8188fu driver for s905x(HG680P & B860H), rtl8822cs driver for s905x3(x96max+) in the dev branch kernel
    #[[ "${build_soc}" == "s905x3" || "${build_soc}" == "s905x" ]] && sed -i "s|stable|dev|g" etc/config/amlogic

    # Add wireless master mode
    wireless_mac80211="lib/netifd/wireless/mac80211.sh"
    [ -f "${wireless_mac80211}" ] && {
        cp -f ${wireless_mac80211} ${wireless_mac80211}.bak
        sed -i "s|iw |ipconfig |g" ${wireless_mac80211}
    }

    # Get random macaddr
    mac_hexchars="0123456789ABCDEF"
    mac_end=$(for i in {1..6}; do echo -n ${mac_hexchars:$((${RANDOM} % 16)):1}; done | sed -e 's/\(..\)/:\1/g')
    random_macaddr="9E:62${mac_end}"

    # Optimize wifi/bluetooth module
    [ -d "lib/firmware/brcm" ] && (
        cd lib/firmware/brcm/ && mv -f ../*.hcd . 2>/dev/null

        # gtking/gtking pro is bcm4356 wifi/bluetooth, wifi5 module AP6356S
        sed -e "s/macaddr=.*/macaddr=${random_macaddr}:00/" "brcmfmac4356-sdio.txt" >"brcmfmac4356-sdio.azw,gtking.txt"
        # gtking/gtking pro is bcm4356 wifi/bluetooth, wifi6 module AP6275S
        sed -e "s/macaddr=.*/macaddr=${random_macaddr}:01/" "brcmfmac4375-sdio.txt" >"brcmfmac4375-sdio.azw,gtking.txt"
        # Phicomm N1 is bcm43455 wifi/bluetooth
        sed -e "s/macaddr=.*/macaddr=${random_macaddr}:02/" "brcmfmac43455-sdio.txt" >"brcmfmac43455-sdio.phicomm,n1.txt"
        # MXQ Pro+ is AP6330(bcm4330) wifi/bluetooth
        sed -e "s/macaddr=.*/macaddr=${random_macaddr}:03/" "brcmfmac4330-sdio.txt" >"brcmfmac4330-sdio.crocon,mxq-pro-plus.txt"
        # HK1 Box & H96 Max X3 is bcm54339 wifi/bluetooth
        sed -e "s/macaddr=.*/macaddr=${random_macaddr}:04/" "brcmfmac4339-sdio.ZP.txt" >"brcmfmac4339-sdio.amlogic,sm1.txt"
        # old ugoos x3 is bcm43455 wifi/bluetooth
        sed -e "s/macaddr=.*/macaddr=${random_macaddr}:05/" "brcmfmac43455-sdio.txt" >"brcmfmac43455-sdio.amlogic,sm1.txt"
        # new ugoos x3 is brm43456
        sed -e "s/macaddr=.*/macaddr=${random_macaddr}:06/" "brcmfmac43456-sdio.txt" >"brcmfmac43456-sdio.amlogic,sm1.txt"
    )

    sync
    # Edit ${root}/* files ========== End ==========

    # Edit ${boot}/* files ========== Begin ==========
    cd ${boot}

    # Edit the uEnv.txt
    if [ ! -f "uEnv.txt" ]; then
        error_msg "The uEnv.txt File does not exist"
    else
        old_fdt_dtb="meson-gxl-s905d-phicomm-n1.dtb"
        sed -i "s/${old_fdt_dtb}/${FDTFILE}/g" uEnv.txt
        sed -i "s/LABEL=ROOTFS/UUID=${ROOTFS_UUID}/g" uEnv.txt
    fi

    # Add u-boot.ext for 5.10 kernel
    if [[ "${K510}" -eq "1" && -n "${UBOOT_OVERLOAD}" ]]; then
        if [ -f "${uboot_path}/${UBOOT_OVERLOAD}" ]; then
            cp -f ${uboot_path}/${UBOOT_OVERLOAD} u-boot.ext && sync && chmod +x u-boot.ext
        else
            error_msg "${build_usekernel} have no the 5.10 kernel u-boot file: [ ${UBOOT_OVERLOAD} ]"
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
    IMG_SIZE=$((SKIP_MB + BOOT_MB + ROOT_MB))

    #fallocate -l ${IMG_SIZE}M ${build_image_file}
    dd if=/dev/zero of=${build_image_file} bs=1M count=${IMG_SIZE} conv=fsync 2>/dev/null && sync

    parted -s ${build_image_file} mklabel msdos 2>/dev/null
    parted -s ${build_image_file} mkpart primary fat32 $((SKIP_MB))M $((SKIP_MB + BOOT_MB - 1))M 2>/dev/null
    parted -s ${build_image_file} mkpart primary btrfs $((SKIP_MB + BOOT_MB))M 100% 2>/dev/null
    sync

    loop_setup ${build_image_file}
    mkfs.vfat -n "BOOT" ${loop}p1 >/dev/null 2>&1
    mkfs.btrfs -U ${ROOTFS_UUID} -L "ROOTFS" -m single ${loop}p2 >/dev/null 2>&1
    sync

    # Write the specified bootloader
    if [[ "${MAINLINE_UBOOT}" != "" && -f "${root}${MAINLINE_UBOOT}" ]]; then
        dd if=${root}${MAINLINE_UBOOT} of=${loop} bs=1 count=444 conv=fsync 2>/dev/null
        dd if=${root}${MAINLINE_UBOOT} of=${loop} bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
        #echo -e "${build_op}_v${kernel} write Mainline bootloader: ${MAINLINE_UBOOT}"
    elif [[ "${ANDROID_UBOOT}" != "" && -f "${root}${ANDROID_UBOOT}" ]]; then
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

    local bootfs="${tmp_path}/${kernel}/${build_op}/bootfs"
    local rootfs="${tmp_path}/${kernel}/${build_op}/rootfs"

    mkdir -p ${bootfs} ${rootfs} && sync
    if ! mount ${loop}p1 ${bootfs}; then
        error_msg "mount ${loop}p1 failed!"
    fi
    if ! mount ${loop}p2 ${rootfs}; then
        error_msg "mount ${loop}p2 failed!"
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

cleanup() {
    cd ${make_path}
    for x in $(lsblk | grep $(pwd) | grep -oE 'loop[0-9]+' | sort | uniq); do
        umount -f /dev/${x}p* 2>/dev/null
        losetup -d /dev/${x} 2>/dev/null
    done
    losetup -D
    rm -rf ${tmp_path} 2>/dev/null
}

while [ "${1}" ]; do
    case "${1}" in
    -d | --default)
        : ${build_openwrt:="${build_openwrt}"}
        : ${build_kernel:="${build_kernel}"}
        : ${auto_kernel:="${auto_kernel}"}
        : ${version_branch:="${version_branch}"}
        : ${ROOT_MB:="${ROOT_MB}"}
        ;;
    -b | --build)
        if [ -n "${2}" ]; then
            unset build_openwrt
            oldIFS=$IFS
            IFS=_
            build_openwrt=(${2})
            IFS=$oldIFS
            shift
        else
            error_msg "Invalid -b parameter [ ${2} ]!"
        fi
        ;;
    -k | --kernel)
        if [ -n "${2}" ]; then
            oldIFS=$IFS
            IFS=_
            build_kernel=(${2})
            IFS=$oldIFS
            shift
        else
            error_msg "Invalid -k parameter [ ${2} ]!"
        fi
        ;;
    -a | --autokernel)
        if [ -n "${2}" ]; then
            auto_kernel="${2}"
            shift
        else
            error_msg "Invalid -a parameter [ ${2} ]!"
        fi
        ;;
    -v | --version)
        if [ -n "${2}" ]; then
            version_branch="${2}"
            shift
        else
            error_msg "Invalid -v parameter [ ${2} ]!"
        fi
        ;;
    -s | --size)
        if [[ -n "${2}" && "${2}" -ge "512" ]]; then
            ROOT_MB="${2}"
            shift
        else
            error_msg "Invalid -s parameter [ ${2} ]!"
        fi
        ;;
    *)
        error_msg "Invalid option [ ${1} ]!"
        ;;
    esac
    shift
done

[ $(id -u) = 0 ] || error_msg "please run this script as root: [ sudo ./$0 ]"
echo -e "Welcome to use the OpenWrt packaging tool!"
[ "${auto_kernel}" == "true" ] && download_kernel
echo -e "OpenWrt SoC List: [ $(echo ${build_openwrt[*]} | tr "\n" " ") ]"
echo -e "Kernel List: [ $(echo ${build_kernel[*]} | tr "\n" " ") ]"
echo -e "Server space usage before starting to compile: \n$(df -hT ${PWD}) \n"

# Start loop compilation
k=1
for b in ${build_openwrt[*]}; do

    i=1
    for x in ${build_kernel[*]}; do
        {
            echo -n "(${k}.${i}) Start packaging OpenWrt [ ${b} - ${x} ]. "

            now_remaining_space=$(df -hT ${PWD} | grep '/dev/' | awk '{print $5}' | sed 's/.$//' | awk -F "." '{print $1}')
            if [[ "${now_remaining_space}" -le "2" ]]; then
                echo "Remaining space is less than 2G, exit this packaging. \n"
                break 2
            else
                echo "Remaining space is ${now_remaining_space}G."
            fi

            kernel=${x}
            build=${b}
            process_msg " (1/6) extract armvirt files."
            extract_openwrt
            process_msg " (2/6) extract armbian files."
            extract_armbian ${b}
            process_msg " (3/6) refactor related files."
            refactor_files ${b} ${x}
            process_msg " (4/6) make openwrt image."
            make_image ${b}
            process_msg " (5/6) copy files to image."
            copy2image ${b}
            process_msg " (6/6) cleanup tmp files."
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
