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
# Command: sudo ./make
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
# query_version      : Query the latest kernel version
# download_kernel    : Download the latest kernel
#
# confirm_version    : Confirm version type
# make_image         : Making OpenWrt file
# extract_openwrt    : Extract OpenWrt files
# replace_kernel     : Replace the kernel
# refactor_files     : Refactor related files
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
kernel_path="${amlogic_path}/amlogic-kernel"
uboot_path="${amlogic_path}/u-boot"
common_files="${amlogic_path}/common-files"
bootfs_path="${common_files}/bootfs"
openvfd_path="${common_files}/rootfs/usr/share/openvfd"
firmware_path="${common_files}/rootfs/lib/firmware"
model_conf="${common_files}/rootfs/etc/model_database.txt"

# Add custom openwrt firmware information
op_release="etc/flippy-openwrt-release"

# Dependency files download repository
depends_repo="https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian"
# Convert depends library address to svn format
depends_repo="${depends_repo//tree\/main/trunk}"

# Firmware files download repository
firmware_repo="https://github.com/ophub/firmware/tree/main/firmware"
# Convert firmware library address to svn format
firmware_repo="${firmware_repo//tree\/main/trunk}"

# Install/Update script files download repository
script_repo="https://github.com/ophub/luci-app-amlogic/tree/main/luci-app-amlogic/root/usr/sbin"
# Convert script library address to svn format
script_repo="${script_repo//tree\/main/trunk}"

# Kernel files download repository
kernel_repo="https://github.com/ophub/kernel/tree/main/pub"
version_branch="stable"
build_kernel=("5.10.125" "5.15.50")
auto_kernel="true"

# Set supported board
build_openwrt=(
    "a311d"
    "s922x" "s922x-n2" "s922x-reva"
    "s905x3" "s905x3-b"
    "s905x2" "s905x2-km3"
    "s912" "s912-m8s"
    "s905d" "s905d-ki" "s905l2"
    "s905x"
    "s905w"
    "s905"
    "s905l3a"
)

# Set OpenWrt firmware size (Unit: MiB, SKIP_MB >= 4, BOOT_MB >= 256, ROOT_MB >= 512)
SKIP_MB="4"
BOOT_MB="256"
ROOT_MB="1024"

# Get gh_token for api.github.com
gh_token=""

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
    echo -e " [\033[1;92m ${board} - ${kernel} \033[0m] ${1}"
}

get_textoffset() {
    vmlinuz_name="${1}"
    K510="1"
    # With TEXT_OFFSET patch is [ 0108 ], without TEXT_OFFSET patch is [ 0000 ]
    [[ "$(hexdump -n 15 -x "${vmlinuz_name}" 2>/dev/null | head -n 1 | awk '{print $7}')" == "0108" ]] && K510="0"
}

init_var() {
    echo -e "${STEPS} Start Initializing Variables..."

    # If it is followed by [ : ], it means that the option requires a parameter value
    get_all_ver="$(getopt "b:k:a:v:r:s:g:" "${@}")"

    while [[ -n "${1}" ]]; do
        case "${1}" in
        -b | --Board)
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
        -r | --KernelRepository)
            if [[ -n "${2}" ]]; then
                kernel_repo="${2}"
                shift
            else
                error_msg "Invalid -r parameter [ ${2} ]!"
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
        -g | --gh_token)
            if [[ -n "${2}" ]]; then
                gh_token="${2}"
                shift
            else
                error_msg "Invalid -g parameter [ ${2} ]!"
            fi
            ;;
        *)
            error_msg "Invalid option [ ${1} ]!"
            ;;
        esac
        shift
    done

    # Convert kernel library address to svn format
    kernel_repo="${kernel_repo//tree\/main/trunk}"
}

find_openwrt() {
    cd ${make_path}
    echo -e "${STEPS} Start searching for OpenWrt file..."

    # Find whether the openwrt file exists
    openwrt_file_name="$(ls ${openwrt_path}/${openwrt_rootfs_file} 2>/dev/null | head -n 1 | awk -F "/" '{print $NF}')"
    if [[ -n "${openwrt_file_name}" ]]; then
        echo -e "${INFO} OpenWrt file: [ ${openwrt_file_name} ]"
    else
        error_msg "There is no [ ${openwrt_rootfs_file} ] file in the [ ${openwrt_path} ] directory."
    fi

    # Extract the openwrt release information file
    source_codename=""
    source_release_file="etc/openwrt_release"
    temp_dir="$(mktemp -d)"
    (cd ${temp_dir} && tar -xzf "${openwrt_path}/${openwrt_file_name}" "./${source_release_file}" 2>/dev/null)
    # Find custom DISTRIB_SOURCECODE, such as [ official/lede ]
    [[ -f "${temp_dir}/${source_release_file}" ]] && {
        source_codename="$(cat ${temp_dir}/${source_release_file} 2>/dev/null | grep -oE "^DISTRIB_SOURCECODE=.*" | head -n 1 | cut -d"'" -f2)"
        [[ -n "${source_codename}" && "${source_codename:0:1}" != "_" ]] && source_codename="_${source_codename}"
        echo -e "${INFO} The source_codename: [ ${source_codename} ]"
    }
    # Remove temporary directory
    rm -rf ${temp_dir}
}

download_depends() {
    cd ${make_path}
    echo -e "${STEPS} Start downloading dependency files..."

    # Download /boot related files
    if [[ -d "${bootfs_path}" ]]; then
        svn up ${bootfs_path} --force
    else
        svn co ${depends_repo}/armbian-files/platform-files/amlogic/bootfs ${bootfs_path} --force
    fi

    # Download u-boot related files
    if [[ -d "${uboot_path}" ]]; then
        svn up ${uboot_path} --force
    else
        svn co ${depends_repo}/u-boot/amlogic ${uboot_path} --force
    fi

    # Download openvfd related files
    if [[ -d "${openvfd_path}" ]]; then
        svn up ${openvfd_path} --force
    else
        svn co ${depends_repo}/armbian-files/platform-files/amlogic/rootfs/usr/share/openvfd ${openvfd_path} --force
    fi

    # Download armbian firmware file
    svn co ${firmware_repo} ${firmware_path} --force

    # Download balethirq related files
    svn export ${depends_repo}/armbian-files/common-files/usr/sbin/balethirq.pl ${common_files}/rootfs/usr/sbin --force
    svn export ${depends_repo}/armbian-files/common-files/etc/balance_irq ${common_files}/rootfs/etc --force

    # Download install/update and other related files
    svn export ${script_repo} ${common_files}/rootfs/usr/sbin --force
    chmod +x ${common_files}/rootfs/usr/sbin/*
}

query_version() {
    echo -e "${STEPS} Start querying the latest kernel version..."

    # Convert kernel library address to API format
    server_kernel_url="${kernel_repo#*com\/}"
    server_kernel_url="${server_kernel_url//trunk/contents}"
    server_kernel_url="https://api.github.com/repos/${server_kernel_url}/${version_branch}"

    # Set empty array
    tmp_arr_kernels=()

    # Query the latest kernel in a loop
    i=1
    for KERNEL_VAR in ${build_kernel[*]}; do
        echo -e "${INFO} (${i}) Auto query the latest kernel version of the same series for [ ${KERNEL_VAR} ]"

        # Identify the kernel mainline
        MAIN_LINE="$(echo ${KERNEL_VAR} | awk -F '.' '{print $1"."$2}')"

        # Check the version on the server (e.g LATEST_VERSION="125")
        if [[ -n "${gh_token}" ]]; then
            LATEST_VERSION="$(curl --header "authorization: Bearer ${gh_token}" -s "${server_kernel_url}" | grep "name" | grep -oE "${MAIN_LINE}\.[0-9]+" | sed -e "s/${MAIN_LINE}\.//g" | sort -n | sed -n '$p')"
            query_api="Authenticated user request"
        else
            LATEST_VERSION="$(curl -s "${server_kernel_url}" | grep "name" | grep -oE "${MAIN_LINE}\.[0-9]+" | sed -e "s/${MAIN_LINE}\.//g" | sort -n | sed -n '$p')"
            query_api="Unauthenticated user request"
        fi

        if [[ "${?}" -eq "0" && -n "${LATEST_VERSION}" ]]; then
            tmp_arr_kernels[${i}]="${MAIN_LINE}.${LATEST_VERSION}"
        else
            tmp_arr_kernels[${i}]="${KERNEL_VAR}"
        fi

        echo -e "${INFO} (${i}) [ ${tmp_arr_kernels[$i]} ] is latest kernel (${query_api}). \n"

        let i++
    done

    # Reset the kernel array to the latest kernel version
    unset build_kernel
    build_kernel="${tmp_arr_kernels[*]}"
}

download_kernel() {
    cd ${make_path}
    echo -e "${STEPS} Start downloading the kernel files..."

    i=1
    for KERNEL_VAR in ${build_kernel[*]}; do
        if [[ ! -d "${kernel_path}/${KERNEL_VAR}" ]]; then
            echo -e "${INFO} (${i}) [ ${KERNEL_VAR} ] Kernel loading from [ ${kernel_repo/trunk/tree\/main}/${version_branch}/${KERNEL_VAR} ]"
            svn export ${kernel_repo}/${version_branch}/${KERNEL_VAR} ${kernel_path}/${KERNEL_VAR} --force
        else
            echo -e "${INFO} (${i}) [ ${KERNEL_VAR} ] Kernel is in the local directory."
        fi

        let i++
    done
}

confirm_version() {
    process_msg " (1/6) Confirm version type."
    cd ${make_path}

    # Find [ the first ] configuration information with [ the same BOARD name ] and [ BUILD as yes ] in the ${model_conf} file.
    [[ -f "${model_conf}" ]] || error_msg "[ ${model_conf} ] file is missing!"
    board_conf="$(cat ${model_conf} | sed -e 's/NA//g' -e 's/NULL//g' -e 's/[ ][ ]*//g' | grep -E "^[^#].*:${board}:yes$" | head -n 1)"
    [[ -n "${board_conf}" ]] || error_msg "[ ${board} ] config is missing!"

    # 1.ID  2.MODEL  3.SOC  4.FDTFILE  5.UBOOT_OVERLOAD  6.MAINLINE_UBOOT  7.ANDROID_UBOOT  8.DESCRIPTION  9.FAMILY  10.BOARD  11.BUILD
    SOC="$(echo ${board_conf} | awk -F':' '{print $3}')"
    FDTFILE="$(echo ${board_conf} | awk -F':' '{print $4}')"
    UBOOT_OVERLOAD="$(echo ${board_conf} | awk -F':' '{print $5}')"
    MAINLINE_UBOOT="$(echo ${board_conf} | awk -F':' '{print $6}')" && MAINLINE_UBOOT="${MAINLINE_UBOOT##*/}"
    ANDROID_UBOOT="$(echo ${board_conf} | awk -F':' '{print $7}')" && ANDROID_UBOOT="${ANDROID_UBOOT##*/}"
    FAMILY="$(echo ${board_conf} | awk -F':' '{print $9}')"

    # Confirm UUID
    ROOTFS_UUID="$(cat /proc/sys/kernel/random/uuid)"
    [[ -z "${ROOTFS_UUID}" ]] && ROOTFS_UUID="$(uuidgen)"
    [[ -z "${ROOTFS_UUID}" ]] && error_msg "The uuidgen is invalid, cannot continue."
}

make_image() {
    process_msg " (2/6) Make openwrt image."
    cd ${make_path}

    # Set openwrt filename
    build_image_file="${out_path}/openwrt${source_codename}_${board}_k${kernel}_$(date +"%Y.%m.%d").img"
    rm -f ${build_image_file}

    [[ -d "${out_path}" ]] || mkdir -p ${out_path}
    IMG_SIZE="$((SKIP_MB + BOOT_MB + ROOT_MB))"

    #fallocate -l ${IMG_SIZE}M ${build_image_file}
    dd if=/dev/zero of=${build_image_file} bs=1M count=${IMG_SIZE} conv=fsync 2>/dev/null

    # Create openwrt image file partition
    parted -s ${build_image_file} mklabel msdos 2>/dev/null
    parted -s ${build_image_file} mkpart primary fat32 $((SKIP_MB))MiB $((SKIP_MB + BOOT_MB - 1))MiB 2>/dev/null
    parted -s ${build_image_file} mkpart primary btrfs $((SKIP_MB + BOOT_MB))MiB 100% 2>/dev/null

    # Mount the openwrt image file
    loop_new="$(losetup -P -f --show "${build_image_file}")"
    [[ -n "${loop_new}" ]] || error_msg "losetup ${build_image_file} failed."

    # Format openwrt image file
    mkfs.vfat -F 32 -n "BOOT" ${loop_new}p1 >/dev/null 2>&1
    mkfs.btrfs -f -U ${ROOTFS_UUID} -L "ROOTFS" -m single ${loop_new}p2 >/dev/null 2>&1

    # Write the specified bootloader
    if [[ -n "${MAINLINE_UBOOT}" && -f "${uboot_path}/bootloader/${MAINLINE_UBOOT}" ]]; then
        dd if="${uboot_path}/bootloader/${MAINLINE_UBOOT}" of="${loop_new}" bs=1 count=444 conv=fsync 2>/dev/null
        dd if="${uboot_path}/bootloader/${MAINLINE_UBOOT}" of="${loop_new}" bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
        #echo -e "${INFO} ${board}_v${kernel} write Mainline bootloader: ${MAINLINE_UBOOT}"
    elif [[ -n "${ANDROID_UBOOT}" && -f "${uboot_path}/bootloader/${ANDROID_UBOOT}" ]]; then
        dd if="${uboot_path}/bootloader/${ANDROID_UBOOT}" of="${loop_new}" bs=1 count=444 conv=fsync 2>/dev/null
        dd if="${uboot_path}/bootloader/${ANDROID_UBOOT}" of="${loop_new}" bs=512 skip=1 seek=1 conv=fsync 2>/dev/null
        #echo -e "${INFO} ${board}_v${kernel} write Android bootloader: ${ANDROID_UBOOT}"
    fi
}

extract_openwrt() {
    process_msg " (3/6) Extract openwrt files."
    cd ${make_path}

    # Create openwrt mirror partition
    tag_bootfs="${tmp_path}/${kernel}/${board}/bootfs"
    tag_rootfs="${tmp_path}/${kernel}/${board}/rootfs"
    mkdir -p ${tag_bootfs} ${tag_rootfs}

    # Mount the openwrt image
    mount -t vfat ${loop_new}p1 ${tag_bootfs}
    [[ "${?}" -eq "0" ]] || error_msg "mount ${loop_new}p1 failed!"

    mount -t btrfs -o compress=zstd:6 ${loop_new}p2 ${tag_rootfs}
    [[ "${?}" -eq "0" ]] || error_msg "mount ${loop_new}p2 failed!"

    # Create snapshot directory
    btrfs subvolume create ${tag_rootfs}/etc >/dev/null 2>&1

    # Unzip the openwrt package
    tar -xzf ${openwrt_path}/${openwrt_file_name} -C ${tag_rootfs}
    rm -rf ${tag_rootfs}/lib/modules/*
    rm -f ${tag_rootfs}/rom/sbin/firstboot

    # Copy the same files
    [[ -d "${common_files}/bootfs" ]] && cp -rf ${common_files}/bootfs/* ${tag_bootfs}
    [[ -d "${common_files}/rootfs" ]] && cp -rf ${common_files}/rootfs/* ${tag_rootfs}

    # Copy the bootloader files
    [[ -d "${tag_rootfs}/lib/u-boot" ]] || mkdir -p "${tag_rootfs}/lib/u-boot"
    cp -f ${uboot_path}/bootloader/* ${tag_rootfs}/lib/u-boot
    # Copy the overload files
    cp -f ${uboot_path}/overload/* ${tag_bootfs}
}

replace_kernel() {
    process_msg " (4/6) Replace the kernel."
    cd ${make_path}

    # Replace the kernel
    build_boot="$(ls ${kernel_path}/${kernel}/boot-${kernel}-*.tar.gz 2>/dev/null | head -n 1)"
    build_dtb="$(ls ${kernel_path}/${kernel}/dtb-amlogic-${kernel}-*.tar.gz 2>/dev/null | head -n 1)"
    build_modules="$(ls ${kernel_path}/${kernel}/modules-${kernel}-*.tar.gz 2>/dev/null | head -n 1)"
    [[ -n "${build_boot}" && -n "${build_dtb}" && -n "${build_modules}" ]] || error_msg "The 3 kernel missing."

    # 01. For /boot five files
    tar -xzf ${build_boot} -C ${tag_bootfs}
    [[ "$(ls ${tag_bootfs}/*-${kernel}-* -l 2>/dev/null | grep "^-" | wc -l)" -ge "4" ]] || error_msg "The /boot files is missing."
    (cd ${tag_bootfs} && cp -f uInitrd-* uInitrd && cp -f vmlinuz-* zImage)
    get_textoffset "${tag_bootfs}/zImage"

    # 02. For /boot/dtb/amlogic/*
    tar -xzf ${build_dtb} -C ${tag_bootfs}/dtb/amlogic

    # 03. For /lib/modules/*
    tar -xzf ${build_modules} -C ${tag_rootfs}/lib/modules
    (cd ${tag_rootfs}/lib/modules/${kernel}-*/ && rm -f build source *.ko 2>/dev/null && find ./ -type f -name '*.ko' -exec ln -s {} ./ \;)
    [[ "$(ls ${tag_rootfs}/lib/modules/${kernel}-* -l 2>/dev/null | grep "^d" | wc -l)" -eq "1" ]] || error_msg "Missing kernel."
}

refactor_files() {
    process_msg " (5/6) Refactor related files."
    cd ${tag_bootfs}

    # For btrfs file system
    uenv_mount_string="UUID=${ROOTFS_UUID} rootflags=compress=zstd:6 rootfstype=btrfs"
    boot_conf_file="uEnv.txt"
    [[ -f "${boot_conf_file}" ]] || error_msg "The [ ${boot_conf_file} ] file does not exist."
    sed -i "s|LABEL=ROOTFS|${uenv_mount_string}|g" ${boot_conf_file}
    sed -i "s|meson.*.dtb|${FDTFILE}|g" ${boot_conf_file}

    # Add an alternate file (/boot/extlinux/extlinux.conf) for devices like T95Z. If needed, rename delete .bak
    boot_extlinux_file="extlinux/extlinux.conf.bak"
    [[ -f "${boot_extlinux_file}" ]] && {
        sed -i "s|LABEL=ROOTFS|${uenv_mount_string}|g" ${boot_extlinux_file}
        sed -i "s|meson.*.dtb|${FDTFILE}|g" ${boot_extlinux_file}
    }

    # Add u-boot.ext for 5.10 kernel
    if [[ "${K510}" -eq "1" && -n "${UBOOT_OVERLOAD}" && -f "${UBOOT_OVERLOAD}" ]]; then
        cp -f ${UBOOT_OVERLOAD} u-boot.ext
        chmod +x u-boot.ext
    elif [[ "${K510}" -eq "1" ]] && [[ -z "${UBOOT_OVERLOAD}" || ! -f "${UBOOT_OVERLOAD}" ]]; then
        error_msg "${board} Board does not support using ${kernel} kernel, missing u-boot."
    fi

    cd ${tag_rootfs}

    # Add directory
    mkdir -p .reserved boot run

    # Edit fstab
    sed -i "s|LABEL=ROOTFS|UUID=${ROOTFS_UUID}|" etc/fstab
    sed -i "s|option label 'ROOTFS'|option uuid '${ROOTFS_UUID}'|" etc/config/fstab

    # Add firmware information
    echo "PLATFORM='amlogic'" >>${op_release}
    echo "SOC='${SOC}'" >>${op_release}
    echo "FDTFILE='${FDTFILE}'" >>${op_release}
    echo "UBOOT_OVERLOAD='${UBOOT_OVERLOAD}'" >>${op_release}
    echo "MAINLINE_UBOOT='/lib/u-boot/${MAINLINE_UBOOT}'" >>${op_release}
    echo "ANDROID_UBOOT='/lib/u-boot/${ANDROID_UBOOT}'" >>${op_release}
    echo "FAMILY='${FAMILY}'" >>${op_release}
    echo "BOARD='${board}'" >>${op_release}
    echo "KERNEL_VERSION='${kernel}'" >>${op_release}
    echo "K510='${K510}'" >>${op_release}

    # Add firmware version information to the terminal page
    [[ -f "etc/banner" ]] && {
        op_version=$(echo $(ls lib/modules/ 2>/dev/null))
        op_production_date=$(date +%Y-%m-%d)
        echo " Install OpenWrt: System → Amlogic Service → Install OpenWrt" >>etc/banner
        echo " Update  OpenWrt: System → Amlogic Service → Online  Update" >>etc/banner
        echo " Amlogic Box SoC: ${SOC} | OpenWrt Kernel: ${op_version}" >>etc/banner
        echo " Production Date: ${op_production_date}" >>etc/banner
        echo "───────────────────────────────────────────────────────────────────────" >>etc/banner
    }

    # Add cpustat
    cpustat_file="${common_files}/patches/cpustat"
    [[ -d "${cpustat_file}" && -x "bin/bash" ]] && {
        cp -f ${cpustat_file}/30-sysinfo.sh etc/profile.d/30-sysinfo.sh
        cp -f ${cpustat_file}/getcpu bin/getcpu && chmod +x bin/getcpu
        cp -f ${cpustat_file}/cpustat usr/bin/cpustat && chmod +x usr/bin/cpustat
        sed -i "s/\/bin\/ash/\/bin\/bash/" etc/passwd
        sed -i "s/\/bin\/ash/\/bin\/bash/" usr/libexec/login.sh
    }

    # Turn off hw_flow by default
    [[ -f "etc/config/turboacc" ]] && {
        sed -i "s|option hw_flow.*|option hw_flow '0'|g" etc/config/turboacc
        sed -i "s|option sw_flow.*|option sw_flow '0'|g" etc/config/turboacc
    }

    # Add balethirq
    balethirq_file="${common_files}/rootfs/usr/sbin/balethirq.pl"
    [[ -x "${balethirq_file}" ]] && sed -i "/^exit 0/i\/usr/sbin/balethirq.pl" etc/rc.local

    # Modify the cpu mode to schedutil
    [[ -f "etc/config/cpufreq" ]] && sed -i "s/ondemand/schedutil/" etc/config/cpufreq

    # Turn off speed limit by default
    [[ -f "etc/config/nft-qos" ]] && sed -i "s|option limit_enable.*|option limit_enable '0'|g" etc/config/nft-qos

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
    # Enable watchdog driver
    echo "meson_gxbb_wdt" >etc/modules.d/watchdog

    # Add blacklist
    mkdir -p etc/modprobe.d
    cat >etc/modprobe.d/99-local.conf <<EOF
blacklist snd_soc_meson_aiu_i2s
alias brnf br_netfilter
alias pwm pwm_meson
alias wifi brcmfmac
EOF

    # Adjust startup settings
    if ! grep -q 'ulimit -n' etc/init.d/boot; then
        sed -i '/kmodloader/i \\tulimit -n 51200\n' etc/init.d/boot
    fi
    if ! grep -q '/tmp/update' etc/init.d/boot; then
        sed -i '/mkdir -p \/tmp\/.uci/a \\tmkdir -p \/tmp\/update' etc/init.d/boot
    fi
    sed -i 's/ttyAMA0/ttyAML0/' etc/inittab
    sed -i 's/ttyS0/tty0/' etc/inittab

    # Relink the kmod program
    [[ -x "sbin/kmod" ]] && (
        kmod_list="depmod insmod lsmod modinfo modprobe rmmod"
        for ki in ${kmod_list}; do
            rm -f sbin/${ki}
            ln -sf kmod sbin/${ki}
        done
    )

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

    cd ${make_path}

    # Create snapshot
    mkdir -p ${tag_rootfs}/.snapshots
    btrfs subvolume snapshot -r ${tag_rootfs}/etc ${tag_rootfs}/.snapshots/etc-000 >/dev/null 2>&1

    sync && sleep 3
}

clean_tmp() {
    process_msg " (6/6) Cleanup tmp files."
    cd ${make_path}

    # Unmount the openwrt image file
    umount -f ${tag_bootfs} 2>/dev/null
    umount -f ${tag_rootfs} 2>/dev/null
    losetup -d ${loop_new} 2>/dev/null

    # Loop to cancel other mounts
    for x in $(lsblk | grep $(pwd) | grep -oE 'loop[0-9]+' | sort | uniq); do
        umount -f /dev/${x}p* 2>/dev/null
        losetup -d /dev/${x} 2>/dev/null
    done
    losetup -D

    cd ${out_path}

    # Compress the openwrt image file
    pigz -9f *.img && sync

    cd ${make_path}

    # Clear temporary files directory
    rm -rf ${tmp_path}
}

loop_make() {
    cd ${make_path}
    echo -e "${STEPS} Start making OpenWrt firmware..."

    j="1"
    for b in ${build_openwrt[*]}; do

        i="1"
        for k in ${build_kernel[*]}; do
            {
                echo -n "(${j}.${i}) Start making OpenWrt [ ${b} - ${k} ]. "

                now_remaining_space="$(df -Tk ${make_path} | grep '/dev/' | awk '{print $5}' | echo $(($(xargs) / 1024 / 1024)))"
                if [[ "${now_remaining_space}" -le "3" ]]; then
                    echo "Remaining space is less than 3G, exit this making."
                    break
                else
                    echo "Remaining space is ${now_remaining_space}G."
                fi

                # The loop variable assignment
                board="${b}"
                kernel="${k}"

                # Execute the following functions in sequence
                confirm_version
                make_image
                extract_openwrt
                replace_kernel
                refactor_files
                clean_tmp

                echo -e "(${j}.${i}) OpenWrt made successfully. \n"
                let i++
            }
        done

        let j++
    done

    cd ${out_path}

    # Backup the openwrt file
    cp -f ${openwrt_path}/${openwrt_file_name} .

    # Generate sha256sum check file
    sha256sum * >sha256sums && sync
}

# Show welcome message
echo -e "${STEPS} Welcome to tools for making Amlogic s9xxx OpenWrt! \n"
[[ "$(id -u)" == "0" ]] || error_msg "please run this script as root: [ sudo ./${0} ]"
# Show server start information
echo -e "${INFO} Server CPU configuration information: \n$(cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c) \n"
echo -e "${INFO} Server memory usage: \n$(free -h) \n"
echo -e "${INFO} Server space usage before starting to compile: \n$(df -hT ${make_path}) \n"
#
# Initialize variables and download the kernel
init_var "${@}"
# Find OpenWrt file
find_openwrt
# Download the dependency files
download_depends
# Download the latest kernel
[[ "${auto_kernel}" == "true" ]] && query_version
download_kernel
#
echo -e "${INFO} OpenWrt Board List: [ $(echo ${build_openwrt[*]} | tr "\n" " ") ]"
echo -e "${INFO} Kernel List: [ $(echo ${build_kernel[*]} | tr "\n" " ") ] \n"
#
# Loop to make OpenWrt firmware
loop_make
#
# Show server end information
echo -e "${STEPS} Server space usage after compilation: \n$(df -hT ${make_path}) \n"
echo -e "${SUCCESS} All process completed successfully."
# All process completed
wait
