#!/bin/bash
#============================================================================
#
# This file is licensed under the terms of the GNU General Public
# License version 2. This program is licensed "as is" without any
# warranty of any kind, whether express or implied.
#
# This file is a part of the make OpenWrt for Amlogic s9xxx tv box
# https://github.com/ophub/amlogic-s9xxx-openwrt
#
# Description: Automatically Packaged OpenWrt for Amlogic s9xxx tv box
# Copyright (C) 2020- https://github.com/unifreq
# Copyright (C) 2020- https://github.com/ophub/amlogic-s9xxx-openwrt
#
# Command: sudo ./make -d
# Command optional parameters please refer to the source code repository
#
#============================== Functions list ==============================
#
# error_msg          : Output error message
# process_msg        : Output process message
# get_textoffset     : Get kernel TEXT_OFFSET
#
# init_var           : Initialize all variables
# find_openwrt       : Find OpenWrt file (openwrt-armvirt/*rootfs.tar.gz)
# download_depends   : Download the dependency files
# download_kernel    : Download the latest kernel
#
# confirm_version    : Confirm version type
# extract_openwrt    : Extract OpenWrt files
# extract_armbian    : Extract Armbian files
# refactor_files     : Refactor related files
# make_image         : Making OpenWrt file
# copy_files         : Copy the OpenWrt files
# clean_tmp          : Clear temporary files
#
# loop_make          : Loop to make OpenWrt files
#
#====================== Set make environment variables ======================
#
# Related file storage path
make_path="${PWD}"
tmp_path="${make_path}/tmp"
out_path="${make_path}/out"
openwrt_path="${make_path}/openwrt-armvirt"
openwrt_rootfs_file="*rootfs.tar.gz"
amlogic_path="${make_path}/amlogic-s9xxx"
armbian_path="${amlogic_path}/amlogic-armbian"
kernel_path="${amlogic_path}/amlogic-kernel"
uboot_path="${amlogic_path}/amlogic-u-boot"
configfiles_path="${amlogic_path}/common-files"
bootfs_path="${configfiles_path}/bootfs"
openvfd_path="${configfiles_path}/rootfs/usr/share/openvfd"
# Add custom openwrt firmware information
op_release="etc/flippy-openwrt-release"
# Dependency files download repository
depends_repo="https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian"
# Install/Update script files download repository
script_repo="https://github.com/ophub/luci-app-amlogic/tree/main/luci-app-amlogic/root/usr/sbin"
# Kernel files download repository
kernel_repo="https://github.com/ophub/kernel/tree/main/pub"
version_branch="stable"
auto_kernel="true"
build_kernel=("5.10.125" "5.15.50")
# Set supported SoC
build_openwrt=(
    "a311d"
    "s922x" "s922x-n2" "s922x-reva"
    "s905x3"
    "s905x2" "s905x2-km3"
    "s912" "s912-m8s"
    "s905d" "s905d-ki"
    "s905x"
    "s905w"
    "s905"
    "s905l3a"
)
# Set OpenWrt firmware size (Unit: MiB, SKIP_MB >= 4, BOOT_MB >= 256, ROOT_MB >= 512)
SKIP_MB="68"
BOOT_MB="256"
ROOT_MB="960"
#
# Set font color
STEPS="[\033[95m STEPS \033[0m]"
INFO="[\033[94m INFO \033[0m]"
SUCCESS="[\033[92m SUCCESS \033[0m]"
WARNING="[\033[93m WARNING \033[0m]"
ERROR="[\033[91m ERROR \033[0m]"
#
#============================================================================

error_msg() {
    echo -e "${ERROR} ${1}"
    exit 1
}

process_msg() {
    echo -e " [\033[1;92m ${soc} - ${kernel} \033[0m] ${1}"
}

get_textoffset() {
    vmlinuz_name="${1}"
    K510="1"
    # With TEXT_OFFSET patch is [ 0108 ], without TEXT_OFFSET patch is [ 0000 ]
    [[ "$(hexdump -n 15 -x "${vmlinuz_name}" 2>/dev/null | head -n 1 | awk '{print $7}')" == "0108" ]] && K510="0"
}

init_var() {
    cd ${make_path}

    # If it is followed by [ : ], it means that the option requires a parameter value
    get_all_ver="$(getopt "db:k:a:v:s:" "${@}")"

    while [[ -n "${1}" ]]; do
        case "${1}" in
        -d | --Default)
            : ${build_openwrt:="${build_openwrt}"}
            : ${build_kernel:="${build_kernel}"}
            : ${auto_kernel:="${auto_kernel}"}
            : ${version_branch:="${version_branch}"}
            : ${ROOT_MB:="${ROOT_MB}"}
            ;;
        -b | --BuildSoC)
            if [[ -n "${2}" ]]; then
                if [[ "${2}" != "all" ]]; then
                    unset build_openwrt
                    oldIFS=$IFS
                    IFS=_
                    build_openwrt=(${2})
                    IFS=$oldIFS
                fi
                shift
            else
                error_msg "Invalid -b parameter [ ${2} ]!"
            fi
            ;;
        -k | --Kernel)
            if [[ -n "${2}" ]]; then
                oldIFS=$IFS
                IFS=_
                build_kernel=(${2})
                IFS=$oldIFS
                shift
            else
                error_msg "Invalid -k parameter [ ${2} ]!"
            fi
            ;;
        -a | --AutoKernel)
            if [[ -n "${2}" ]]; then
                auto_kernel="${2}"
                shift
            else
                error_msg "Invalid -a parameter [ ${2} ]!"
            fi
            ;;
        -v | --VersionBranch)
            if [[ -n "${2}" ]]; then
                version_branch="${2}"
                shift
            else
                error_msg "Invalid -v parameter [ ${2} ]!"
            fi
            ;;
        -s | --Size)
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
}

find_openwrt() {
    cd ${make_path}

    openwrt_file_name="$(ls ${openwrt_path}/${openwrt_rootfs_file} 2>/dev/null | head -n 1 | awk -F "/" '{print $NF}')"
    if [[ -n "${openwrt_file_name}" ]]; then
        echo -e "${INFO} OpenWrt make file: [ ${openwrt_file_name} ]"
    else
        error_msg "There is no [ ${openwrt_rootfs_file} ] file in the [ ${openwrt_path} ] directory."
    fi
}

download_depends() {
    cd ${make_path}
    echo -e "${STEPS} Download all dependent files..."

    # Convert depends library address to svn format
    if [[ "${depends_repo}" == http* && -n "$(echo ${depends_repo} | grep "tree/main")" ]]; then
        depends_repo="${depends_repo//tree\/main/trunk}"
    fi
    # Sync armbian related files
    if [[ -d "${armbian_path}" ]]; then
        svn up ${armbian_path} --force
    else
        svn co ${depends_repo}/amlogic-armbian ${armbian_path} --force
    fi
    # Sync /boot related files
    if [[ -d "${bootfs_path}" ]]; then
        svn up ${bootfs_path} --force
    else
        svn co ${depends_repo}/common-files/bootfs ${bootfs_path} --force
    fi
    # Sync u-boot related files
    if [[ -d "${uboot_path}" ]]; then
        svn up ${uboot_path} --force
    else
        svn co ${depends_repo}/amlogic-u-boot ${uboot_path} --force
    fi
    # Sync openvfd related files
    if [[ -d "${openvfd_path}" ]]; then
        svn up ${openvfd_path} --force
    else
        svn co ${depends_repo}/common-files/rootfs/usr/share/openvfd ${openvfd_path} --force
    fi

    # Convert script library address to svn format
    if [[ "${script_repo}" == http* && -n "$(echo ${script_repo} | grep "tree/main")" ]]; then
        script_repo="${script_repo//tree\/main/trunk}"
    fi
    # Sync install/update and other related files
    svn export ${script_repo} ${configfiles_path}/rootfs/usr/sbin --force

    sync
}

download_kernel() {
    cd ${make_path}

    # Convert kernel library address to svn format
    if [[ "${kernel_repo}" == http* && -n "$(echo ${kernel_repo} | grep "tree/main")" ]]; then
        kernel_repo="${kernel_repo//tree\/main/trunk}"
    fi
    kernel_repo="${kernel_repo}/${version_branch}"

    # Set empty array
    tmp_arr_kernels=()

    # Convert kernel library address to API format
    server_kernel_url="${kernel_repo#*com\/}"
    server_kernel_url="${server_kernel_url//trunk/contents}"
    server_kernel_url="https://api.github.com/repos/${server_kernel_url}"

    # Query the latest kernel in a loop
    i=1
    for KERNEL_VAR in ${build_kernel[*]}; do
        echo -e "${INFO} (${i}) Auto query the latest kernel version of the same series for [ ${KERNEL_VAR} ]"
        # Identify the kernel mainline
        MAIN_LINE="$(echo ${KERNEL_VAR} | awk -F '.' '{print $1"."$2}')"
        # Check the version on the server (e.g LATEST_VERSION="125")
        LATEST_VERSION="$(curl -s "${server_kernel_url}" | grep "name" | grep -oE "${MAIN_LINE}.[0-9]+" | sed -e "s/${MAIN_LINE}.//g" | sort -n | sed -n '$p')"
        if [[ "${?}" -eq "0" && ! -z "${LATEST_VERSION}" ]]; then
            tmp_arr_kernels[${i}]="${MAIN_LINE}.${LATEST_VERSION}"
        else
            tmp_arr_kernels[${i}]="${KERNEL_VAR}"
        fi
        echo -e "${INFO} (${i}) [ ${tmp_arr_kernels[$i]} ] is latest kernel. \n"

        let i++
    done

    # Reset the kernel array to the latest kernel version
    unset build_kernel
    build_kernel="${tmp_arr_kernels[*]}"

    # Synchronization related kernel
    i=1
    for KERNEL_VAR in ${build_kernel[*]}; do
        if [[ ! -d "${kernel_path}/${KERNEL_VAR}" ]]; then
            echo -e "${INFO} (${i}) [ ${KERNEL_VAR} ] Kernel loading from [ ${kernel_repo/trunk/tree\/main}/${KERNEL_VAR} ]"
            svn export ${kernel_repo}/${KERNEL_VAR} ${kernel_path}/${KERNEL_VAR} --force
        else
            echo -e "${INFO} (${i}) [ ${KERNEL_VAR} ] Kernel is in the local directory."
        fi

        let i++
    done
    sync
}

confirm_version() {
    process_msg " (1/7) Confirm version type."
    cd ${make_path}

    # Confirm soc branch
    case "${soc}" in
    a311d | khadas-vim3)
        FDTFILE="meson-g12b-a311d-khadas-vim3.dtb"
        UBOOT_OVERLOAD="u-boot-gtkingpro.bin"
        MAINLINE_UBOOT="khadas-vim3-u-boot.sd.bin"
        ANDROID_UBOOT=""
        ;;
    s922x | belink | belinkpro | ugoos)
        FDTFILE="meson-g12b-gtking-pro.dtb"
        UBOOT_OVERLOAD="u-boot-gtkingpro.bin"
        MAINLINE_UBOOT="gtkingpro-u-boot.bin.sd.bin"
        ANDROID_UBOOT=""
        ;;
    s922x-n2 | odroid-n2)
        FDTFILE="meson-g12b-odroid-n2.dtb"
        UBOOT_OVERLOAD="u-boot-gtkingpro.bin"
        MAINLINE_UBOOT="odroid-n2-u-boot.bin.sd.bin"
        ANDROID_UBOOT=""
        ;;
    s922x-reva)
        FDTFILE="meson-g12b-gtking-pro.dtb"
        UBOOT_OVERLOAD="u-boot-gtkingpro-rev-a.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT=""
        ;;
    s905x3 | tx3 | x96 | hk1 | h96 | ugoosx3)
        FDTFILE="meson-sm1-x96-max-plus-100m.dtb"
        UBOOT_OVERLOAD="u-boot-x96maxplus.bin"
        MAINLINE_UBOOT="x96maxplus-u-boot.bin.sd.bin"
        ANDROID_UBOOT="hk1box-bootloader.img"
        ;;
    s905x2 | x96max4g | x96max2g)
        FDTFILE="meson-g12a-x96-max.dtb"
        UBOOT_OVERLOAD="u-boot-x96max.bin"
        MAINLINE_UBOOT="x96max-u-boot.bin.sd.bin"
        ANDROID_UBOOT=""
        ;;
    s905x2-km3)
        FDTFILE="meson-g12a-sei510.dtb"
        UBOOT_OVERLOAD="u-boot-x96max.bin"
        MAINLINE_UBOOT="x96max-u-boot.bin.sd.bin"
        ANDROID_UBOOT=""
        ;;
    s912 | h96proplus | octopus)
        FDTFILE="meson-gxm-octopus-planet.dtb"
        UBOOT_OVERLOAD="u-boot-zyxq.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT=""
        ;;
    s912-m8s | s912-m8s-pro-l)
        FDTFILE="meson-gxm-q201.dtb"
        UBOOT_OVERLOAD="u-boot-s905x-s912.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT=""
        ;;
    s905d | n1)
        FDTFILE="meson-gxl-s905d-phicomm-n1.dtb"
        UBOOT_OVERLOAD="u-boot-n1.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT="u-boot-2015-phicomm-n1.bin"
        ;;
    s905d-ki)
        FDTFILE="meson-gxl-s905d-mecool-ki-pro.dtb"
        UBOOT_OVERLOAD="u-boot-p201.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT=""
        ;;
    s905x | hg680p | tbee | b860h)
        FDTFILE="meson-gxl-s905x-p212.dtb"
        UBOOT_OVERLOAD="u-boot-p212.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT=""
        ;;
    s905w | x96mini | tx3mini)
        FDTFILE="meson-gxl-s905w-tx3-mini.dtb"
        UBOOT_OVERLOAD="u-boot-s905x-s912.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT=""
        ;;
    s905 | beelinkminimx | mxqpro+)
        FDTFILE="meson-gxbb-beelink-mini-mx.dtb"
        #FDTFILE="meson-gxbb-mxq-pro-plus.dtb"
        #FDTFILE="meson-gxbb-vega-s95-telos.dtb"
        UBOOT_OVERLOAD="u-boot-s905.bin"
        #UBOOT_OVERLOAD="u-boot-p201.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT=""
        ;;
    s905l3a | e900v22c | e900v22d)
        FDTFILE="meson-g12a-s905l3a-e900v22c.dtb"
        UBOOT_OVERLOAD="u-boot-e900v22c.bin"
        MAINLINE_UBOOT=""
        ANDROID_UBOOT=""
        ;;
    *)
        error_msg "Have no this soc: [ ${soc} ]"
        ;;
    esac

    # Confirm UUID
    ROOTFS_UUID="$(cat /proc/sys/kernel/random/uuid)"
    [[ -z "${ROOTFS_UUID}" ]] && ROOTFS_UUID="$(uuidgen)"
    [[ -z "${ROOTFS_UUID}" ]] && error_msg "The uuidgen is invalid, cannot continue."
}

extract_openwrt() {
    process_msg " (2/7) Extract openwrt files."
    cd ${make_path}

    local firmware="${openwrt_path}/${openwrt_file_name}"

    root_comm="${tmp_path}/root_comm"
    mkdir -p ${root_comm}

    tar -xzf ${firmware} -C ${root_comm}
    rm -rf ${root_comm}/lib/modules/* 2>/dev/null
    sync
}

extract_armbian() {
    process_msg " (3/7) Extract armbian files."
    cd ${make_path}

    root="${tmp_path}/${kernel}/${soc}/root"
    boot="${tmp_path}/${kernel}/${soc}/boot"
    mkdir -p ${root} ${boot}

    # Copy OpenWrt files
    cp -rf ${root_comm}/* ${root}

    # Unzip the relevant files
    tar -xJf "${armbian_path}/boot-common.tar.xz" -C ${boot}
    tar -xJf "${armbian_path}/firmware.tar.xz" -C ${root}

    # Copy the same files
    [[ "$(ls ${configfiles_path}/bootfs 2>/dev/null | wc -w)" -ne "0" ]] && cp -rf ${configfiles_path}/bootfs/* ${boot}
    [[ "$(ls ${configfiles_path}/rootfs 2>/dev/null | wc -w)" -ne "0" ]] && cp -rf ${configfiles_path}/rootfs/* ${root}

    # Copy the bootloader files
    [[ -d "${root}/lib/u-boot" ]] || mkdir -p "${root}/lib/u-boot"
    cp -f ${uboot_path}/bootloader/* ${root}/lib/u-boot
    # Copy the overload files
    cp -f ${uboot_path}/overload/* ${boot}

    # Replace the kernel
    build_boot="$(ls ${kernel_path}/${kernel}/boot-${kernel}-*.tar.gz 2>/dev/null | head -n 1)"
    build_dtb="$(ls ${kernel_path}/${kernel}/dtb-amlogic-${kernel}-*.tar.gz 2>/dev/null | head -n 1)"
    build_modules="$(ls ${kernel_path}/${kernel}/modules-${kernel}-*.tar.gz 2>/dev/null | head -n 1)"
    [[ -n "${build_boot}" && -n "${build_dtb}" && -n "${build_modules}" ]] || error_msg "The 3 kernel missing."

    # 01. For /boot five files
    tar -xzf ${build_boot} -C ${boot} && sync
    [[ "$(ls ${boot}/*-${kernel}-* -l 2>/dev/null | grep "^-" | wc -l)" -ge "4" ]] || error_msg "The /boot files is missing."
    (cd ${boot} && cp -f uInitrd-* uInitrd && cp -f vmlinuz-* zImage && sync)
    get_textoffset "${boot}/zImage"

    # 02. For /boot/dtb/amlogic/*
    tar -xzf ${build_dtb} -C ${boot}/dtb/amlogic && sync

    # 03. For /lib/modules/*
    tar -xzf ${build_modules} -C ${root}/lib/modules && sync
    (cd ${root}/lib/modules/${kernel}-*/ && rm -f build source *.ko 2>/dev/null && find ./ -type f -name '*.ko' -exec ln -s {} ./ \; && sync)
    [[ "$(ls ${root}/lib/modules/${kernel}-* -l 2>/dev/null | grep "^d" | wc -l)" -eq "1" ]] || error_msg "Missing kernel."
    sync
}

refactor_files() {
    process_msg " (4/7) Refactor related files."
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

    # Edit fstab
    sed -i "s/LABEL=ROOTFS/UUID=${ROOTFS_UUID}/" etc/fstab 2>/dev/null
    sed -i "s/option label 'ROOTFS'/option uuid '${ROOTFS_UUID}'/" etc/config/fstab 2>/dev/null

    # Turn off speed limit by default
    [[ -f "etc/config/nft-qos" ]] && sed -i "s|option limit_enable.*|option limit_enable '0'|g" etc/config/nft-qos

    # Turn off hw_flow by default
    [[ -f "etc/config/turboacc" ]] && sed -i "s|option hw_flow.*|option hw_flow '0'|g" etc/config/turboacc
    [[ -f "etc/config/turboacc" ]] && sed -i "s|option sfe_flow.*|option sfe_flow '0'|g" etc/config/turboacc

    # Add USB and wireless network drivers
    [[ -f "etc/modules.d/usb-net-rtl8150" ]] || echo "rtl8150" >etc/modules.d/usb-net-rtl8150
    # USB RTL8152/8153/8156 network card Driver
    [[ -f "etc/modules.d/usb-net-rtl8152" ]] || echo "r8152" >etc/modules.d/usb-net-rtl8152
    # USB AX88179 network card Driver
    [[ -f "etc/modules.d/usb-net-asix-ax88179" ]] || echo "ax88179_178a" >etc/modules.d/usb-net-asix-ax88179
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
    # Ath10k Driver
    echo "ath10k_core" >etc/modules.d/ath10k_core
    echo "ath10k_sdio" >etc/modules.d/ath10k_sdio
    echo "ath10k_usb" >etc/modules.d/ath10k_usb

    # Relink the kmod program
    [[ -x "sbin/kmod" ]] && (
        kmod_list="depmod insmod lsmod modinfo modprobe rmmod"
        for ki in ${kmod_list}; do
            rm -f sbin/${ki} 2>/dev/null
            ln -sf kmod sbin/${ki}
        done
    )

    # Modify the cpu mode to schedutil
    if [[ -f "etc/config/cpufreq" ]]; then
        sed -i "s/ondemand/schedutil/" etc/config/cpufreq
    fi

    # Add cpustat
    cpustat_file="${configfiles_path}/patches/cpustat"
    if [[ -d "${cpustat_file}" && -x "bin/bash" ]]; then
        cp -f ${cpustat_file}/cpustat usr/bin/cpustat && chmod +x usr/bin/cpustat >/dev/null 2>&1
        cp -f ${cpustat_file}/getcpu bin/getcpu && chmod +x bin/getcpu >/dev/null 2>&1
        cp -f ${cpustat_file}/30-sysinfo.sh etc/profile.d/30-sysinfo.sh >/dev/null 2>&1
        sed -i "s/\/bin\/ash/\/bin\/bash/" etc/passwd >/dev/null 2>&1
        sed -i "s/\/bin\/ash/\/bin\/bash/" usr/libexec/login.sh >/dev/null 2>&1
    fi

    # Add balethirq
    balethirq_file="${configfiles_path}/patches/balethirq"
    if [[ -d "${balethirq_file}" ]]; then
        cp -f ${balethirq_file}/balethirq.pl usr/sbin/balethirq.pl && chmod +x usr/sbin/balethirq.pl >/dev/null 2>&1
        sed -i "/exit/i\/usr/sbin/balethirq.pl" etc/rc.local >/dev/null 2>&1
        cp -f ${balethirq_file}/balance_irq etc/balance_irq >/dev/null 2>&1
    fi

    # Add firmware information
    echo "PLATFORM='amlogic'" >>${op_release} 2>/dev/null
    echo "FDTFILE='${FDTFILE}'" >>${op_release} 2>/dev/null
    echo "UBOOT_OVERLOAD='${UBOOT_OVERLOAD}'" >>${op_release} 2>/dev/null
    echo "MAINLINE_UBOOT='/lib/u-boot/${MAINLINE_UBOOT}'" >>${op_release} 2>/dev/null
    echo "ANDROID_UBOOT='/lib/u-boot/${ANDROID_UBOOT}'" >>${op_release} 2>/dev/null
    echo "KERNEL_VERSION='${kernel}'" >>${op_release} 2>/dev/null
    echo "SOC='${soc}'" >>${op_release} 2>/dev/null
    echo "K510='${K510}'" >>${op_release} 2>/dev/null

    # Add firmware version information to the terminal page
    if [[ -f "etc/banner" ]]; then
        op_version=$(echo $(ls lib/modules/ 2>/dev/null))
        op_production_date=$(date +%Y-%m-%d)
        echo " Install OpenWrt: System → Amlogic Service → Install OpenWrt" >>etc/banner
        echo " Update  OpenWrt: System → Amlogic Service → Online  Update" >>etc/banner
        echo " Amlogic Box SoC: ${soc} | OpenWrt Kernel: ${op_version}" >>etc/banner
        echo " Production Date: ${op_production_date}" >>etc/banner
        echo "───────────────────────────────────────────────────────────────────────" >>etc/banner
    fi

    # Add wireless master mode
    wireless_mac80211="lib/netifd/wireless/mac80211.sh"
    [[ -f "${wireless_mac80211}" ]] && {
        cp -f ${wireless_mac80211} ${wireless_mac80211}.bak
        sed -i "s|iw |ipconfig |g" ${wireless_mac80211}
    }

    # Get random macaddr
    mac_hexchars="0123456789ABCDEF"
    mac_end="$(for i in {1..6}; do echo -n ${mac_hexchars:$((${RANDOM} % 16)):1}; done | sed -e 's/\(..\)/:\1/g')"
    random_macaddr="9E:62${mac_end}"

    # Optimize wifi/bluetooth module
    [[ -d "lib/firmware/brcm" ]] && (
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
        # x96max plus v5.1 (ip1001m phy) adopts am7256 (brcm4354)
        sed -e "s/macaddr=.*/macaddr=${random_macaddr}:07/" "brcmfmac4354-sdio.txt" >"brcmfmac4354-sdio.amlogic,sm1.txt"
    )
    sync

    cd ${boot}

    # For btrfs file system
    uenv_mount_string="UUID=${ROOTFS_UUID} rootflags=compress=zstd:6 rootfstype=btrfs"
    boot_conf_file="uEnv.txt"
    [[ -f "${boot_conf_file}" ]] || error_msg "The [ ${boot_conf_file} ] file does not exist."
    sed -i "s|LABEL=ROOTFS|${uenv_mount_string}|g" ${boot_conf_file}
    sed -i "s|meson.*.dtb|${FDTFILE}|g" ${boot_conf_file}

    # Add an alternate file (/boot/extlinux/extlinux.conf) for devices like T95Z. If needed, rename delete .bak
    boot_extlinux_file="extlinux/extlinux.conf.bak"
    if [[ -f "${boot_extlinux_file}" ]]; then
        sed -i "s|LABEL=ROOTFS|${uenv_mount_string}|g" ${boot_extlinux_file}
        sed -i "s|meson.*.dtb|${FDTFILE}|g" ${boot_extlinux_file}
    fi

    # Add u-boot.ext for 5.10 kernel
    if [[ "${K510}" -eq "1" && -n "${UBOOT_OVERLOAD}" && -f "${UBOOT_OVERLOAD}" ]]; then
        cp -f ${UBOOT_OVERLOAD} u-boot.ext
        chmod +x u-boot.ext
    elif [[ "${K510}" -eq "1" ]] && [[ -z "${UBOOT_OVERLOAD}" || ! -f "${UBOOT_OVERLOAD}" ]]; then
        error_msg "${soc} SoC does not support using ${kernel} kernel, missing u-boot."
    fi
    sync
}

make_image() {
    process_msg " (5/7) Make openwrt image."
    cd ${make_path}

    build_image_file="${out_path}/openwrt_${soc}_k${kernel}_$(date +"%Y.%m.%d").img"
    rm -f ${build_image_file}
    sync

    [[ -d "${out_path}" ]] || mkdir -p ${out_path}
    IMG_SIZE="$((SKIP_MB + BOOT_MB + ROOT_MB))"

    #fallocate -l ${IMG_SIZE}M ${build_image_file}
    dd if=/dev/zero of=${build_image_file} bs=1M count=${IMG_SIZE} conv=fsync 2>/dev/null && sync

    parted -s ${build_image_file} mklabel msdos 2>/dev/null
    parted -s ${build_image_file} mkpart primary fat32 $((SKIP_MB))MiB $((SKIP_MB + BOOT_MB - 1))MiB 2>/dev/null
    parted -s ${build_image_file} mkpart primary btrfs $((SKIP_MB + BOOT_MB))MiB 100% 2>/dev/null
    sync

    loop_new="$(losetup -P -f --show "${build_image_file}")"
    [[ -n "${loop_new}" ]] || error_msg "losetup ${build_image_file} failed."

    mkfs.vfat -n "BOOT" ${loop_new}p1 >/dev/null 2>&1
    mkfs.btrfs -f -U ${ROOTFS_UUID} -L "ROOTFS" -m single ${loop_new}p2 >/dev/null 2>&1
    sync

    # Write the specified bootloader
    if [[ -n "${MAINLINE_UBOOT}" && -f "${root}/lib/u-boot/${MAINLINE_UBOOT}" ]]; then
        dd if="${root}/lib/u-boot/${MAINLINE_UBOOT}" of="${loop_new}" bs=1 count=444 conv=fsync 2>/dev/null
        dd if="${root}/lib/u-boot/${MAINLINE_UBOOT}" of="${loop_new}" bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
        #echo -e "${INFO} ${soc}_v${kernel} write Mainline bootloader: ${MAINLINE_UBOOT}"
    elif [[ -n "${ANDROID_UBOOT}" && -f "${root}/lib/u-boot/${ANDROID_UBOOT}" ]]; then
        dd if="${root}/lib/u-boot/${ANDROID_UBOOT}" of="${loop_new}" bs=1 count=444 conv=fsync 2>/dev/null
        dd if="${root}/lib/u-boot/${ANDROID_UBOOT}" of="${loop_new}" bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
        #echo -e "${INFO} ${soc}_v${kernel} write Android bootloader: ${ANDROID_UBOOT}"
    fi
    sync
}

copy_files() {
    process_msg " (6/7) Copy files to image."
    cd ${make_path}

    local bootfs="${tmp_path}/${kernel}/${soc}/bootfs"
    local rootfs="${tmp_path}/${kernel}/${soc}/rootfs"
    mkdir -p ${bootfs} ${rootfs} && sync

    if ! mount ${loop_new}p1 ${bootfs}; then
        error_msg "mount ${loop_new}p1 failed!"
    fi
    if ! mount ${loop_new}p2 ${rootfs}; then
        error_msg "mount ${loop_new}p2 failed!"
    fi

    btrfs subvolume create ${rootfs}/etc >/dev/null 2>&1

    cp -rf ${boot}/* ${bootfs}
    cp -rf ${root}/* ${rootfs}

    mkdir -p ${rootfs}/.snapshots
    btrfs subvolume snapshot -r ${rootfs}/etc ${rootfs}/.snapshots/etc-000 >/dev/null 2>&1
    rm -f ${rootfs}/rom/sbin/firstboot 2>/dev/null
    sync

    cd ${make_path}
    umount -f ${bootfs} 2>/dev/null
    umount -f ${rootfs} 2>/dev/null
    losetup -d ${loop_new} 2>/dev/null

    cd ${out_path} && pigz -9 *.img
    sync
}

clean_tmp() {
    process_msg " (7/7) Cleanup tmp files."
    cd ${make_path}

    for x in $(lsblk | grep $(pwd) | grep -oE 'loop[0-9]+' | sort | uniq); do
        umount -f /dev/${x}p* 2>/dev/null
        losetup -d /dev/${x} 2>/dev/null
    done
    losetup -D

    rm -rf ${tmp_path} 2>/dev/null
    sync
}

loop_make() {
    cd ${make_path}

    j="1"
    for b in ${build_openwrt[*]}; do

        i="1"
        for k in ${build_kernel[*]}; do
            {
                echo -n "(${j}.${i}) Start making OpenWrt [ ${b} - ${k} ]. "

                now_remaining_space="$(df -Tk ${make_path} | grep '/dev/' | awk '{print $5}' | echo $(($(xargs) / 1024 / 1024)))"
                if [[ "${now_remaining_space}" -le "2" ]]; then
                    echo "Remaining space is less than 2G, exit this making. \n"
                    break
                else
                    echo "Remaining space is ${now_remaining_space}G."
                fi

                # The loop variable assignment
                soc="${b}"
                kernel="${k}"

                # Execute the following functions in sequence
                confirm_version
                extract_openwrt
                extract_armbian
                refactor_files
                make_image
                copy_files
                clean_tmp

                echo -e "(${j}.${i}) OpenWrt made successfully. \n"
                let i++
            }
        done

        let j++
    done

    cd ${out_path}

    # Backup the openwrt file
    cp -f ${openwrt_path}/${openwrt_file_name} . 2>/dev/null && sync

    # Generate sha256sum check file
    sha256sum * >sha256sums && sync
}

# Show welcome message
echo -e "${INFO} Welcome to tools for making Amlogic s9xxx OpenWrt! \n"
[[ "$(id -u)" == "0" ]] || error_msg "please run this script as root: [ sudo ./${0} ]"
# Show server start information
echo -e "${INFO} Server CPU configuration information: \n$(cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c) \n"
echo -e "${INFO} Server memory usage: \n$(free -h) \n"
echo -e "${INFO} Server space usage before starting to compile: \n$(df -hT ${make_path}) \n"
echo -e "${INFO} Setting parameters: [ ${@} ] \n"
#
# Initialize variables and download the kernel
init_var "${@}"
# Find OpenWrt file
find_openwrt
# Download the dependency files
download_depends
# Download the latest kernel
[[ "${auto_kernel}" == "true" ]] && download_kernel
echo -e "${INFO} OpenWrt SoC List: [ $(echo ${build_openwrt[*]} | tr "\n" " ") ]"
echo -e "${INFO} Kernel List: [ $(echo ${build_kernel[*]} | tr "\n" " ") ] \n"
# Loop to make OpenWrt firmware
loop_make
#
# Show server end information
echo -e "${INFO} Server space usage after compilation: \n$(df -hT ${make_path}) \n"
# All process completed
wait
