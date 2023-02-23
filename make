#!/bin/bash
#============================================================================
#
# This file is licensed under the terms of the GNU General Public
# License version 2. This program is licensed "as is" without any
# warranty of any kind, whether express or implied.
#
# This file is a part of the make OpenWrt for Amlogic and Rockchip
# https://github.com/ophub/amlogic-s9xxx-openwrt
#
# Description: Automatically Packaged OpenWrt for Amlogic and Rockchip
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
# check_kernel       : Check kernel files integrity
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
current_path="${PWD}"
tmp_path="${current_path}/tmp"
out_path="${current_path}/out"
openwrt_path="${current_path}/openwrt-armvirt"
openwrt_rootfs_file="*rootfs.tar.gz"
make_path="${current_path}/make-openwrt"
kernel_path="${make_path}/kernel"
uboot_path="${make_path}/u-boot"
common_files="${make_path}/openwrt-files/common-files"
platform_files="${make_path}/openwrt-files/platform-files"
patches_path="${make_path}/openwrt-files/patches"
firmware_path="${common_files}/lib/firmware"
model_conf="${common_files}/etc/model_database.conf"
model_txt="${common_files}/etc/model_database.txt"

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
# Set stable kernel directory: [ stable ], rk3588 kernel directory: [ rk3588 ]
kernel_dir=("stable" "rk3588")
# Set the list of kernels used by default
stable_kernel=("6.1.10" "5.15.50")
rk3588_kernel=("5.10.150")
# Set to automatically use the latest kernel
auto_kernel="true"

# Get the list of devices built by default
# 1.ID  2.MODEL  3.SOC  4.FDTFILE  5.UBOOT_OVERLOAD  6.MAINLINE_UBOOT  7.BOOTLOADER_IMG  8.DESCRIPTION  9.KERNEL_BRANCH  10.PLATFORM  11.FAMILY  12.BOOT_CONF  13.BOARD  14.BUILD
build_openwrt=($(cat ${model_conf} | sed -e 's/NA//g' -e 's/NULL//g' -e 's/[ ][ ]*//g' | grep -E "^[^#].*:yes$" | awk -F':' '{print $13}' | sort | uniq | xargs))

# Set OpenWrt firmware size (Unit: MiB, BOOT_MB >= 256, ROOT_MB >= 512)
BOOT_MB="256"
ROOT_MB="1024"

# Get gh_token for api.github.com
gh_token=""

# Set font color
STEPS="[\033[95m STEPS \033[0m]"
INFO="[\033[94m INFO \033[0m]"
TIPS="[\033[93m TIPS \033[0m]"
WARNING="[\033[93m WARNING \033[0m]"
SUCCESS="[\033[92m SUCCESS \033[0m]"
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
    need_overload="yes"
    # With TEXT_OFFSET patch is [ 0108 ], without TEXT_OFFSET patch is [ 0000 ]
    [[ "$(hexdump -n 15 -x "${vmlinuz_name}" 2>/dev/null | head -n 1 | awk '{print $7}')" == "0108" ]] && need_overload="no"
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
                stable_kernel=(${2})
                IFS=$oldIFS
                shift
            else
                error_msg "Invalid -k parameter [ ${2} ]!"
            fi
            ;;
        -a | --Autokernel)
            if [[ -n "${2}" ]]; then
                auto_kernel="${2}"
                shift
            else
                error_msg "Invalid -a parameter [ ${2} ]!"
            fi
            ;;
        -v | --Versionbranch)
            if [[ -n "${2}" ]]; then
                oldIFS=${IFS}
                IFS=_
                kernel_dir=(${2})
                IFS=${oldIFS}
                [[ -n "$(echo "${kernel_dir[@]}" | grep -oE "rk3588")" ]] || kernel_dir[$(((${#kernel_dir[@]} + 1)))]="rk3588"
                shift
            else
                error_msg "Invalid -v parameter [ ${2} ]!"
            fi
            ;;
        -r | --kernelRepository)
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
        -g | --Gh_token)
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
    cd ${current_path}
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
    cd ${current_path}
    echo -e "${STEPS} Start downloading dependency files..."

    # Download /boot related files
    if [[ -d "${platform_files}" ]]; then
        svn up ${platform_files} --force
    else
        svn co ${depends_repo}/armbian-files/platform-files ${platform_files} --force
    fi
    rm -rf ${platform_files}/amlogic/rootfs/usr/sbin

    # Download u-boot related files
    if [[ -d "${uboot_path}" ]]; then
        svn up ${uboot_path} --force
    else
        svn co ${depends_repo}/u-boot ${uboot_path} --force
    fi

    # Download armbian firmware file
    svn co ${firmware_repo} ${firmware_path} --force

    # Download balethirq related files
    svn export ${depends_repo}/armbian-files/common-files/usr/sbin/balethirq.pl ${common_files}/usr/sbin --force
    svn export ${depends_repo}/armbian-files/common-files/etc/balance_irq ${common_files}/etc --force

    # Download install/update and other related files
    svn export ${script_repo} ${common_files}/usr/sbin --force
    chmod +x ${common_files}/usr/sbin/*
    # Convert text format profiles for install script(openwrt-install-amlogic)
    cat ${model_conf} | sed -e 's/NA//g' -e 's/NULL//g' -e 's/[ ][ ]*//g' | grep -E "^[^#].*" >${model_txt}
}

query_version() {
    echo -e "${STEPS} Start querying the latest kernel version..."

    # Convert kernel library address to API format
    server_kernel_url="${kernel_repo#*com\/}"
    server_kernel_url="${server_kernel_url//trunk/contents}"
    server_kernel_url="https://api.github.com/repos/${server_kernel_url}"

    # Check the version on the kernel library
    x="1"
    for k in ${kernel_dir[*]}; do
        {
            # Select the corresponding kernel directory and list
            if [[ "${k}" == "rk3588" ]]; then
                down_kernel_list=(${rk3588_kernel[*]})
            else
                down_kernel_list=(${stable_kernel[*]})
            fi

            # Query the name of the latest kernel version
            tmp_arr_kernels=()
            i=1
            for kernel_var in ${down_kernel_list[*]}; do
                echo -e "${INFO} (${x}.${i}) Auto query the latest kernel version of the same series for [ ${k} - ${kernel_var} ]"

                # Identify the kernel <VERSION> and <PATCHLEVEL>, such as [ 5.10 ]
                kernel_verpatch="$(echo ${kernel_var} | awk -F '.' '{print $1"."$2}')"

                # Check the kernel <SUBLEVEL>, such as [ 125 ]
                if [[ -n "${gh_token}" ]]; then
                    kernel_sub="$(curl --header "authorization: Bearer ${gh_token}" -s "${server_kernel_url}/${k}" | grep "name" | grep -oE "${kernel_verpatch}.[0-9]+" | sed -e "s/${kernel_verpatch}.//g" | sort -n | sed -n '$p')"
                    query_api="Authenticated user request"
                else
                    kernel_sub="$(curl -s "${server_kernel_url}/${k}" | grep "name" | grep -oE "${kernel_verpatch}.[0-9]+" | sed -e "s/${kernel_verpatch}.//g" | sort -n | sed -n '$p')"
                    query_api="Unauthenticated user request"
                fi

                if [[ "${?}" -eq "0" && -n "${kernel_sub}" ]]; then
                    tmp_arr_kernels[${i}]="${kernel_verpatch}.${kernel_sub}"
                else
                    tmp_arr_kernels[${i}]="${kernel_var}"
                fi

                echo -e "${INFO} (${x}.${i}) [ ${k} - ${tmp_arr_kernels[$i]} ] is latest kernel (${query_api}). \n"

                let i++
            done

            # Reset the kernel array to the latest kernel version
            if [[ "${k}" == "rk3588" ]]; then
                unset rk3588_kernel
                rk3588_kernel=(${tmp_arr_kernels[*]})
            else
                unset stable_kernel
                stable_kernel=(${tmp_arr_kernels[*]})
            fi

            let x++
        }
    done

    echo -e "${INFO} The latest version of the stable_kernel: [ ${stable_kernel[*]} ]"
    echo -e "${INFO} The latest version of the rk3588_kernel: [ ${rk3588_kernel[*]} ]\n"
}

check_kernel() {
    [[ -n "${1}" ]] && check_path="${1}" || error_msg "Invalid kernel path to check."
    check_files=($(cat "${check_path}/sha256sums" | awk '{print $2}'))
    m="1"
    for cf in ${check_files[*]}; do
        {
            # Check if file exists
            [[ -s "${check_path}/${cf}" ]] || error_msg "The [ ${cf} ] file is missing."
            # Check if the file sha256sum is correct
            tmp_sha256sum="$(sha256sum "${check_path}/${cf}" | awk '{print $1}')"
            tmp_checkcode="$(cat ${check_path}/sha256sums | grep ${cf} | awk '{print $1}')"
            [[ "${tmp_sha256sum}" == "${tmp_checkcode}" ]] || error_msg "[ ${cf} ]: sha256sum verification failed."
            let m++
        }
    done
    echo -e "${INFO} All [ ${#check_files[*]} ] kernel files are sha256sum checked to be complete.\n"
}

download_kernel() {
    cd ${current_path}
    echo -e "${STEPS} Start downloading the kernel files..."

    x="1"
    for k in ${kernel_dir[*]}; do
        {
            # Set the kernel download list
            if [[ "${k}" == "rk3588" ]]; then
                down_kernel_list=(${rk3588_kernel[*]})
            else
                down_kernel_list=(${stable_kernel[*]})
            fi

            # Download the kernel to the storage directory
            i="1"
            for kernel_var in ${down_kernel_list[*]}; do
                if [[ ! -d "${kernel_path}/${k}/${kernel_var}" ]]; then
                    echo -e "${INFO} (${x}.${i}) [ ${k} - ${kernel_var} ] Kernel loading from [ ${kernel_repo/trunk/tree\/main}/${k}/${kernel_var} ]"
                    svn export ${kernel_repo}/${k}/${kernel_var} ${kernel_path}/${k}/${kernel_var} --force
                else
                    echo -e "${INFO} (${x}.${i}) [ ${k} - ${kernel_var} ] Kernel is in the local directory."
                fi

                # If the kernel contains the sha256sums file, check the files integrity
                [[ -f "${kernel_path}/${k}/${kernel_var}/sha256sums" ]] && check_kernel "${kernel_path}/${k}/${kernel_var}"

                let i++
            done
            sync

            let x++
        }
    done
}

confirm_version() {
    cd ${current_path}

    # Find [ the first ] configuration information with [ the same BOARD name ] and [ BUILD as yes ] in the ${model_conf} file.
    [[ -f "${model_conf}" ]] || error_msg "[ ${model_conf} ] file is missing!"
    board_conf="$(cat ${model_conf} | sed -e 's/NA//g' -e 's/NULL//g' -e 's/[ ][ ]*//g' | grep -E "^[^#].*:${board}:yes$" | head -n 1)"
    [[ -n "${board_conf}" ]] || error_msg "[ ${board} ] config is missing!"

    # 1.ID  2.MODEL  3.SOC  4.FDTFILE  5.UBOOT_OVERLOAD  6.MAINLINE_UBOOT  7.BOOTLOADER_IMG  8.DESCRIPTION  9.KERNEL_BRANCH  10.PLATFORM  11.FAMILY  12.BOOT_CONF  13.BOARD  14.BUILD
    SOC="$(echo ${board_conf} | awk -F':' '{print $3}')"
    FDTFILE="$(echo ${board_conf} | awk -F':' '{print $4}')"
    UBOOT_OVERLOAD="$(echo ${board_conf} | awk -F':' '{print $5}')"
    MAINLINE_UBOOT="$(echo ${board_conf} | awk -F':' '{print $6}')" && MAINLINE_UBOOT="${MAINLINE_UBOOT##*/}"
    BOOTLOADER_IMG="$(echo ${board_conf} | awk -F':' '{print $7}')" && BOOTLOADER_IMG="${BOOTLOADER_IMG##*/}"
    KERNEL_BRANCH="$(echo ${board_conf} | awk -F':' '{print $9}')"
    PLATFORM="$(echo ${board_conf} | awk -F':' '{print $10}')"
    FAMILY="$(echo ${board_conf} | awk -F':' '{print $11}')"
    BOOT_CONF="$(echo ${board_conf} | awk -F':' '{print $12}')"

    # Confirm BOOT_UUID
    BOOT_UUID="$(cat /proc/sys/kernel/random/uuid)"
    [[ -z "${BOOT_UUID}" ]] && BOOT_UUID="$(uuidgen)"
    [[ -z "${BOOT_UUID}" ]] && error_msg "The uuidgen is invalid, cannot continue."
    # Confirm ROOTFS_UUID
    ROOTFS_UUID="$(cat /proc/sys/kernel/random/uuid)"
    [[ -z "${ROOTFS_UUID}" ]] && ROOTFS_UUID="$(uuidgen)"
    [[ -z "${ROOTFS_UUID}" ]] && error_msg "The uuidgen is invalid, cannot continue."

    # Define platform variables for Amlogic boxes
    [[ "${PLATFORM}" == "amlogic" ]] && {
        # Set up the welcome board
        bd_name="Amlogic ${SOC}"
        # Set Armbian image file parameters
        partition_table_type="msdos"
        bootfs_type="fat32"
        # Set directory name
        platform_bootfs="${platform_files}/amlogic/bootfs"
        platform_rootfs="${platform_files}/amlogic/rootfs"
        bootloader_dir="${uboot_path}/amlogic/bootloader"
        # Set the type of file system
        uenv_rootdev="UUID=${ROOTFS_UUID} rootflags=compress=zstd:6 rootfstype=btrfs"
        fstab_string="discard,defaults,noatime,compress=zstd:6"
    }

    # Define platform variables for Rockchip boxes
    [[ "${PLATFORM}" == "rockchip" ]] && {
        # Set up the welcome board
        bd_name="Rockchip ${board}"
        # Set Armbian image file parameters
        partition_table_type="gpt"
        bootfs_type="ext4"
        # Set directory name
        platform_bootfs="${platform_files}/rockchip/bootfs/${board}"
        platform_rootfs="${platform_files}/rockchip/rootfs"
        bootloader_dir="${uboot_path}/rockchip/${board}"
        # Set the type of file system
        uenv_rootflags="compress=zstd:6"
        uenv_rootdev="UUID=${ROOTFS_UUID}"
        fstab_string="discard,defaults,noatime,compress=zstd:6"
    }
}

make_image() {
    process_msg " (1/5) Make openwrt image."
    cd ${current_path}

    # Set openwrt filename
    build_image_file="${out_path}/openwrt${source_codename}_${PLATFORM}_${board}_k${kernel}_$(date +"%Y.%m.%d").img"
    rm -f ${build_image_file}

    [[ -d "${out_path}" ]] || mkdir -p ${out_path}

    [[ "${PLATFORM}" == "amlogic" ]] && SKIP_MB="4"
    [[ "${PLATFORM}" == "rockchip" ]] && SKIP_MB="16"

    IMG_SIZE="$((SKIP_MB + BOOT_MB + ROOT_MB))"

    truncate -s ${IMG_SIZE}M ${build_image_file} >/dev/null 2>&1

    parted -s ${build_image_file} mklabel ${partition_table_type} 2>/dev/null
    parted -s ${build_image_file} mkpart primary ${bootfs_type} $((SKIP_MB))MiB $((SKIP_MB + BOOT_MB - 1))MiB 2>/dev/null
    parted -s ${build_image_file} mkpart primary btrfs $((SKIP_MB + BOOT_MB))MiB 100% 2>/dev/null

    # Mount the openwrt image file
    loop_new="$(losetup -P -f --show "${build_image_file}")"
    [[ -n "${loop_new}" ]] || error_msg "losetup ${build_image_file} failed."

    # Format bootfs partition
    [[ "${PLATFORM}" == "amlogic" ]] && mkfs.vfat -F 32 -n "BOOT" ${loop_new}p1 >/dev/null 2>&1
    [[ "${PLATFORM}" == "rockchip" ]] && mkfs.ext4 -F -q -U ${BOOT_UUID} -L "BOOT" -b 4k -m 0 ${loop_new}p1 >/dev/null 2>&1

    # Format rootfs partition
    mkfs.btrfs -f -U ${ROOTFS_UUID} -L "ROOTFS" -m single ${loop_new}p2 >/dev/null 2>&1

    # Write the specified bootloader for Amlogic boxes
    [[ "${PLATFORM}" == "amlogic" ]] && {
        if [[ -n "${MAINLINE_UBOOT}" && -f "${uboot_path}/amlogic/bootloader/${MAINLINE_UBOOT}" ]]; then
            dd if="${uboot_path}/amlogic/bootloader/${MAINLINE_UBOOT}" of="${loop_new}" conv=fsync bs=1 count=444 2>/dev/null
            dd if="${uboot_path}/amlogic/bootloader/${MAINLINE_UBOOT}" of="${loop_new}" conv=fsync bs=512 skip=1 seek=1 2>/dev/null
            #echo -e "${INFO} For [ ${board} ] write Mainline u-boot: ${MAINLINE_UBOOT}"
        elif [[ -n "${BOOTLOADER_IMG}" && -f "${uboot_path}/amlogic/bootloader/${BOOTLOADER_IMG}" ]]; then
            dd if="${uboot_path}/amlogic/bootloader/${BOOTLOADER_IMG}" of="${loop_new}" conv=fsync bs=1 count=444 2>/dev/null
            dd if="${uboot_path}/amlogic/bootloader/${BOOTLOADER_IMG}" of="${loop_new}" conv=fsync bs=512 skip=1 seek=1 2>/dev/null
            #echo -e "${INFO} For [ ${board} ] write bootloader: ${BOOTLOADER_IMG}"
        fi
    }

    # Write the specified bootloader for Rockchip boxes
    [[ "${PLATFORM}" == "rockchip" ]] && {
        if [[ -n "${BOOTLOADER_IMG}" && -f "${uboot_path}/rockchip/${board}/${BOOTLOADER_IMG}" ]] &&
            [[ -n "${MAINLINE_UBOOT}" && -f "${uboot_path}/rockchip/${board}/${MAINLINE_UBOOT}" ]]; then
            dd if="${uboot_path}/rockchip/${board}/${BOOTLOADER_IMG}" of="${loop_new}" conv=fsync,notrunc bs=512 seek=64 2>/dev/null
            dd if="${uboot_path}/rockchip/${board}/${MAINLINE_UBOOT}" of="${loop_new}" conv=fsync,notrunc bs=512 seek=16384 2>/dev/null
            #echo -e "${INFO} For [ ${board} ] write bootloader: ${BOOTLOADER_IMG}"
        elif [[ -n "${BOOTLOADER_IMG}" && -f "${uboot_path}/rockchip/${board}/${BOOTLOADER_IMG}" ]]; then
            dd if="${uboot_path}/rockchip/${board}/${BOOTLOADER_IMG}" of="${loop_new}" conv=fsync,notrunc bs=512 skip=64 seek=64 2>/dev/null
            #echo -e "${INFO} For [ ${board} ] write bootloader: ${BOOTLOADER_IMG}"
        fi
    }
}

extract_openwrt() {
    process_msg " (2/5) Extract openwrt files."
    cd ${current_path}

    # Create openwrt mirror partition
    tag_bootfs="${tmp_path}/${kernel}/${board}/bootfs"
    tag_rootfs="${tmp_path}/${kernel}/${board}/rootfs"
    mkdir -p ${tag_bootfs} ${tag_rootfs}

    # Mount bootfs
    if [[ "${PLATFORM}" == "amlogic" ]]; then
        mount -t vfat -o discard ${loop_new}p1 ${tag_bootfs}
    else
        mount -t ext4 -o discard ${loop_new}p1 ${tag_bootfs}
    fi
    [[ "${?}" -eq "0" ]] || error_msg "mount ${loop_new}p1 failed!"

    # Mount rootfs
    mount -t btrfs -o discard,compress=zstd:6 ${loop_new}p2 ${tag_rootfs}
    [[ "${?}" -eq "0" ]] || error_msg "mount ${loop_new}p2 failed!"

    # Create snapshot directory
    btrfs subvolume create ${tag_rootfs}/etc >/dev/null 2>&1

    # Unzip the openwrt package
    tar -xzf ${openwrt_path}/${openwrt_file_name} -C ${tag_rootfs}
    rm -rf ${tag_rootfs}/lib/modules/*
    rm -f ${tag_rootfs}/rom/sbin/firstboot

    # Copy the same files
    [[ -d "${platform_bootfs}" ]] && cp -rf ${platform_bootfs}/* ${tag_bootfs}
    [[ -d "${platform_rootfs}" ]] && cp -rf ${platform_rootfs}/* ${tag_rootfs}
    [[ -d "${common_files}" ]] && cp -rf ${common_files}/* ${tag_rootfs}

    # Copy the bootloader files
    [[ -d "${tag_rootfs}/lib/u-boot" ]] || mkdir -p "${tag_rootfs}/lib/u-boot"
    [[ -d "${bootloader_dir}" ]] && cp -rf ${bootloader_dir}/* ${tag_rootfs}/lib/u-boot

    # Copy the overload files
    [[ "${PLATFORM}" == "amlogic" ]] && cp -f ${uboot_path}/${PLATFORM}/overload/* ${tag_bootfs}
}

replace_kernel() {
    process_msg " (3/5) Replace the kernel."
    cd ${current_path}

    # Determine custom kernel filename
    kernel_boot="$(ls ${kernel_path}/${kd}/${kernel}/boot-${kernel}*.tar.gz 2>/dev/null | head -n 1)"
    kernel_name="${kernel_boot##*/}" && kernel_name="${kernel_name:5:-7}"
    [[ -n "${kernel_name}" ]] || error_msg "Missing kernel files for [ ${kernel} ]"
    kernel_dtb="${kernel_path}/${kd}/${kernel}/dtb-${PLATFORM}-${kernel_name}.tar.gz"
    kernel_modules="${kernel_path}/${kd}/${kernel}/modules-${kernel_name}.tar.gz"
    [[ -s "${kernel_boot}" && -s "${kernel_dtb}" && -s "${kernel_modules}" ]] || error_msg "The 3 kernel missing."

    # 01. For /boot five files
    tar -xzf ${kernel_boot} -C ${tag_bootfs}
    [[ "${PLATFORM}" == "amlogic" ]] && (cd ${tag_bootfs} && cp -f uInitrd-${kernel_name} uInitrd && cp -f vmlinuz-${kernel_name} zImage)
    [[ "${PLATFORM}" == "rockchip" ]] && (cd ${tag_bootfs} && ln -sf uInitrd-${kernel_name} uInitrd && ln -sf vmlinuz-${kernel_name} Image)
    [[ "$(ls ${tag_bootfs}/*${kernel_name} -l 2>/dev/null | grep "^-" | wc -l)" -ge "2" ]] || error_msg "The /boot files is missing."
    [[ "${PLATFORM}" == "amlogic" ]] && get_textoffset "${tag_bootfs}/zImage"

    # 02. For /boot/dtb/${PLATFORM}/*
    [[ -d "${tag_bootfs}/dtb/${PLATFORM}" ]] || mkdir -p ${tag_bootfs}/dtb/${PLATFORM}
    tar -xzf ${kernel_dtb} -C ${tag_bootfs}/dtb/${PLATFORM}
    [[ "${PLATFORM}" == "rockchip" ]] && ln -sf dtb ${tag_bootfs}/dtb-${kernel_name}
    [[ "$(ls ${tag_bootfs}/dtb/${PLATFORM} -l 2>/dev/null | grep "^-" | wc -l)" -ge "2" ]] || error_msg "/boot/dtb/${PLATFORM} files is missing."

    # 03. For /lib/modules/${kernel_name}
    tar -xzf ${kernel_modules} -C ${tag_rootfs}/lib/modules
    (cd ${tag_rootfs}/lib/modules/${kernel_name}/ && rm -f build source *.ko 2>/dev/null && find ./ -type f -name '*.ko' -exec ln -s {} ./ \;)
    [[ "$(ls ${tag_rootfs}/lib/modules/${kernel_name} -l 2>/dev/null | grep "^d" | wc -l)" -eq "1" ]] || error_msg "/usr/lib/modules kernel folder is missing."
}

refactor_files() {
    process_msg " (4/5) Refactor related files."
    cd ${tag_bootfs}

    # Process Amlogic series boot partition files
    [[ "${PLATFORM}" == "amlogic" ]] && {
        # Add u-boot.ext for Amlogic 5.10 kernel
        if [[ "${need_overload}" == "yes" && -n "${UBOOT_OVERLOAD}" && -f "${UBOOT_OVERLOAD}" ]]; then
            cp -f ${UBOOT_OVERLOAD} u-boot.ext
            chmod +x u-boot.ext
        elif [[ "${need_overload}" == "yes" ]] && [[ -z "${UBOOT_OVERLOAD}" || ! -f "${UBOOT_OVERLOAD}" ]]; then
            error_msg "${board} Board does not support using ${kernel} kernel, missing u-boot."
        fi

        # Edit the uEnv.txt
        boot_conf_file="uEnv.txt"
        [[ -f "${boot_conf_file}" ]] || error_msg "The [ ${boot_conf_file} ] file does not exist."
        sed -i "s|LABEL=ROOTFS|${uenv_rootdev}|g" ${boot_conf_file}
        sed -i "s|meson.*.dtb|${FDTFILE}|g" ${boot_conf_file}

        # Add an alternate file (/boot/extlinux/extlinux.conf)
        boot_extlinux_file="extlinux/extlinux.conf.bak"
        rename_extlinux_file="extlinux/extlinux.conf"
        [[ -f "${boot_extlinux_file}" ]] && {
            sed -i "s|LABEL=ROOTFS|${uenv_rootdev}|g" ${boot_extlinux_file}
            sed -i "s|meson.*.dtb|${FDTFILE}|g" ${boot_extlinux_file}
        }
        # If needed, such as t95z(s905x), rename delete .bak
        [[ "${BOOT_CONF}" == "extlinux.conf" ]] && mv -f ${boot_extlinux_file} ${rename_extlinux_file}
    }

    # Process Rockchip series boot partition files
    [[ "${PLATFORM}" == "rockchip" ]] && {
        # Edit the armbianEnv.txt
        boot_conf_file="armbianEnv.txt"
        [[ -f "${boot_conf_file}" ]] || error_msg "The [ ${boot_conf_file} ] file does not exist."
        sed -i "s|fdtfile.*|fdtfile=rockchip/${FDTFILE}|g" ${boot_conf_file}
        sed -i "s|rootdev=.*|rootdev=${uenv_rootdev}|g" ${boot_conf_file}
        sed -i "s|rootfstype=.*|rootfstype=btrfs|g" ${boot_conf_file}
        sed -i "s|rootflags.*|rootflags=${uenv_rootflags}|g" ${boot_conf_file}
    }

    cd ${tag_rootfs}

    # Add directory
    mkdir -p .reserved boot run

    # Edit fstab
    sed -i "s|LABEL=ROOTFS|UUID=${ROOTFS_UUID}|" etc/fstab
    sed -i "s|option label 'ROOTFS'|option uuid '${ROOTFS_UUID}'|" etc/config/fstab

    # Add firmware information
    echo "PLATFORM='${PLATFORM}'" >>${op_release}
    echo "SOC='${SOC}'" >>${op_release}
    echo "FDTFILE='${FDTFILE}'" >>${op_release}
    echo "UBOOT_OVERLOAD='${UBOOT_OVERLOAD}'" >>${op_release}
    echo "MAINLINE_UBOOT='/lib/u-boot/${MAINLINE_UBOOT}'" >>${op_release}
    echo "ANDROID_UBOOT='/lib/u-boot/${BOOTLOADER_IMG}'" >>${op_release}
    echo "FAMILY='${FAMILY}'" >>${op_release}
    echo "BOARD='${board}'" >>${op_release}
    echo "KERNEL_VERSION='${kernel}'" >>${op_release}
    echo "KERNEL_BRANCH='${KERNEL_BRANCH}'" >>${op_release}
    echo "BOOT_CONF='${BOOT_CONF}'" >>${op_release}

    # Add firmware version information to the terminal page
    [[ -f "etc/banner" ]] && {
        op_version=$(echo $(ls lib/modules/ 2>/dev/null))
        op_production_date=$(date +%Y-%m-%d)
        echo " Install OpenWrt: System → Amlogic Service → Install OpenWrt" >>etc/banner
        echo " Update  OpenWrt: System → Amlogic Service → Online  Update" >>etc/banner
        echo " Board: ${bd_name} | OpenWrt Kernel: ${op_version}" >>etc/banner
        echo " Production Date: ${op_production_date}" >>etc/banner
        echo "───────────────────────────────────────────────────────────────────────" >>etc/banner
    }

    # Add cpustat
    cpustat_file="${patches_path}/cpustat"
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
    balethirq_file="${common_files}/usr/sbin/balethirq.pl"
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

    cd ${current_path}

    # Create snapshot
    mkdir -p ${tag_rootfs}/.snapshots
    btrfs subvolume snapshot -r ${tag_rootfs}/etc ${tag_rootfs}/.snapshots/etc-000 >/dev/null 2>&1

    sync && sleep 3
}

clean_tmp() {
    process_msg " (5/5) Cleanup tmp files."
    cd ${current_path}

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
    pigz -f *.img && sync

    cd ${current_path}

    # Clear temporary files directory
    rm -rf ${tmp_path}
}

loop_make() {
    cd ${current_path}
    echo -e "${STEPS} Start making OpenWrt firmware..."

    j="1"
    for b in ${build_openwrt[*]}; do
        {

            # Set specific configuration for building OpenWrt system
            board="${b}"
            confirm_version

            # Determine kernel branch
            if [[ "${KERNEL_BRANCH}" == "rk3588" ]]; then
                kernel_list=(${rk3588_kernel[*]})
                kd="rk3588"
            else
                kernel_list=(${stable_kernel[*]})
                kd="$(echo "${kernel_dir[@]}" | sed -e "s|rk3588||" | xargs)"
            fi

            i="1"
            for k in ${kernel_list[*]}; do
                {
                    kernel="${k}"

                    # Skip inapplicable kernels
                    if { [[ "${KERNEL_BRANCH}" == "rk3588" ]] && [[ "${kernel:0:5}" != "5.10." ]]; } ||
                        { [[ "${KERNEL_BRANCH}" == "6.x.y" ]] && [[ "${kernel:0:2}" != "6." ]]; } ||
                        { [[ "${KERNEL_BRANCH}" == "5.15.y" ]] && [[ "${kernel:0:5}" != "5.15." && "${kernel:0:4}" != "5.4." ]]; }; then
                        echo -e "(${j}.${i}) ${TIPS} The [ ${board} ] device cannot use [ ${kd}/${kernel} ] kernel, skip."
                        let i++
                        continue
                    fi

                    # Check disk space size
                    echo -ne "(${j}.${i}) Start making OpenWrt [ ${board} - ${kd}/${kernel} ]. "
                    now_remaining_space="$(df -Tk ${current_path} | grep '/dev/' | awk '{print $5}' | echo $(($(xargs) / 1024 / 1024)))"
                    if [[ "${now_remaining_space}" -le "3" ]]; then
                        echo -e "${WARNING} Remaining space is less than 3G, exit this build."
                        break
                    else
                        echo "Remaining space is ${now_remaining_space}G."
                    fi

                    # Execute the following functions in sequence
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
        }
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
echo -e "${INFO} Server space usage before starting to compile: \n$(df -hT ${current_path}) \n"
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
echo -e "${INFO} [ ${#build_openwrt[*]} ] lists of OpenWrt board: [ $(echo ${build_openwrt[*]} | xargs) ]"
echo -e "${INFO} [ ${#stable_kernel[*]} ] lists of stable kernel: [ $(echo ${stable_kernel[*]} | xargs) ]"
echo -e "${INFO} [ ${#rk3588_kernel[*]} ] lists of rk3588 Kernel: [ $(echo ${rk3588_kernel[*]} | xargs) ]"
echo -e "${INFO} Use the latest kernel version: [ ${auto_kernel} ] \n"
#
# Loop to make OpenWrt firmware
loop_make
#
# Show server end information
echo -e "${STEPS} Server space usage after compilation: \n$(df -hT ${current_path}) \n"
echo -e "${SUCCESS} All process completed successfully."
# All process completed
wait
