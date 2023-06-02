#!/bin/bash
#================================================================================================
#
# This file is licensed under the terms of the GNU General Public
# License version 2. This program is licensed "as is" without any
# warranty of any kind, whether express or implied.
#
# This file is a part of the make OpenWrt for Amlogic and Rockchip
# https://github.com/ophub/amlogic-s9xxx-openwrt
#
# Description: Automatically Packaged OpenWrt for Amlogic and Rockchip
# Copyright (C) 2020~ https://github.com/openwrt/openwrt
# Copyright (C) 2020~ https://github.com/coolsnowwolf/lede
# Copyright (C) 2020~ https://github.com/immortalwrt/immortalwrt
# Copyright (C) 2020~ https://github.com/unifreq/openwrt_packit
# Copyright (C) 2021~ https://github.com/ophub/amlogic-s9xxx-armbian/blob/main/CONTRIBUTORS.md
# Copyright (C) 2020~ https://github.com/ophub/amlogic-s9xxx-openwrt
#
# Command: sudo ./make
# Command optional parameters please refer to the source code repository
#
#======================================== Functions list ========================================
#
# error_msg          : Output error message
# process_msg        : Output process message
# mount_try          : Mount the image file, fail again
# get_textoffset     : Get kernel TEXT_OFFSET
#
# init_var           : Initialize all variables
# check_data         : Check the validity of the data
# find_openwrt       : Find OpenWrt file (openwrt-armvirt/*rootfs.tar.gz)
# download_depends   : Download the dependency files
# query_kernel       : Query the latest kernel version
# check_kernel       : Check kernel files integrity
# download_kernel    : Download the latest kernel
#
# confirm_version    : Confirm version type
# make_image         : Making OpenWrt file
# extract_openwrt    : Extract OpenWrt files
# replace_kernel     : Replace the kernel
# refactor_bootfs    : Refactor bootfs files
# refactor_rootfs    : Refactor rootfs files
# clean_tmp          : Clear temporary files
#
# loop_make          : Loop to make OpenWrt files
#
#================================ Set make environment variables ================================
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
different_files="${make_path}/openwrt-files/different-files"
firmware_path="${common_files}/lib/firmware"
model_conf="${common_files}/etc/model_database.conf"
model_txt="${common_files}/etc/model_database.txt"

# System operation environment
arch_info="$(uname -m)"
host_release="$(cat /etc/os-release | grep '^VERSION_CODENAME=.*' | cut -d'=' -f2)"
# Add custom OpenWrt firmware information
op_release="etc/flippy-openwrt-release"

# Dependency files download repository
depends_repo="https://github.com/ophub/amlogic-s9xxx-armbian/tree/main/build-armbian"
# Convert depends repository address to svn format
depends_repo="${depends_repo//tree\/main/trunk}"

# Firmware files download repository
firmware_repo="https://github.com/ophub/firmware/tree/main/firmware"
# Convert firmware repository address to svn format
firmware_repo="${firmware_repo//tree\/main/trunk}"

# Install/Update script files download repository
script_repo="https://github.com/ophub/luci-app-amlogic/tree/main/luci-app-amlogic"
# Convert script repository address to svn format
script_repo="${script_repo//tree\/main/trunk}"

# Set the kernel download repository from github.com
kernel_repo="https://github.com/ophub/kernel"
# Set the tags(kernel_xxx) of the default kernel that can be replaced via the [ -u ] parameter
default_tags="stable"
# Set the tags(kernel_xxx) of the specific kernel, such as 5.15.y, 6.1.y, etc.
specific_tags="${default_tags}"
# Set the list of kernels used by default
stable_kernel=("6.1.1" "5.15.1")
flippy_kernel=("6.1.1" "5.15.1")
dev_kernel=("6.1.1" "5.15.1")
rk3588_kernel=("5.10.1")
# Set to automatically use the latest kernel
auto_kernel="true"

# Initialize the build device
make_board="all"

# Set OpenWrt firmware size (Unit: MiB, boot_mb >= 256, root_mb >= 512)
boot_mb="256"
root_mb="1024"

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
#================================================================================================

error_msg() {
    echo -e " [💔] ${1}"
    exit 1
}

process_msg() {
    echo -e " [🌿] ${1}"
}

mount_try() {
    # Check mount parameters
    m_type="${1}"
    m_dev="${2}"
    m_target="${3}"
    [[ -n "${m_type}" && -n "${m_dev}" && -n "${m_target}" ]] || {
        error_msg "Mount parameter is missing: [ ${m_type}, ${m_dev}, ${m_target} ]"
    }

    t="1"
    max_try="10"
    while [[ "${t}" -le "${max_try}" ]]; do
        # Mount according to the image partition format
        if [[ "${m_type}" == "btrfs" ]]; then
            mount -t ${m_type} -o discard,compress=zstd:6 ${m_dev} ${m_target}
        else
            mount -t ${m_type} -o discard ${m_dev} ${m_target}
        fi

        # Mount failed and continue trying
        if [[ "${?}" -eq "0" ]]; then
            break
        else
            sync && sleep 3
            umount -f ${m_target} 2>/dev/null
            t="$((t + 1))"
        fi
    done
    [[ "${t}" -gt "${max_try}" ]] && error_msg "[ ${t} ] attempts to mount failed."
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
    get_all_ver="$(getopt "b:r:u:k:a:s:g:" "${@}")"

    while [[ -n "${1}" ]]; do
        case "${1}" in
        -b | --Board)
            if [[ -n "${2}" ]]; then
                make_board="${2}"
                shift
            else
                error_msg "Invalid -b parameter [ ${2} ]!"
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
        -u | --kernelUsage)
            if [[ -n "${2}" ]]; then
                kernel_usage="${2//kernel_/}"
                shift
            else
                error_msg "Invalid -u parameter [ ${2} ]!"
            fi
            ;;
        -k | --Kernel)
            if [[ -n "${2}" ]]; then
                oldIFS="${IFS}"
                IFS="_"
                flippy_kernel=(${2})
                stable_kernel=(${2})
                dev_kernel=(${2})
                IFS="${oldIFS}"
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
        -s | --Size)
            if [[ -n "${2}" && "${2}" -ge "512" ]]; then
                root_mb="${2}"
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
}

check_data() {
    # Columns of ${model_conf}:
    # 1.ID  2.MODEL  3.SOC  4.FDTFILE  5.UBOOT_OVERLOAD  6.MAINLINE_UBOOT  7.BOOTLOADER_IMG  8.DESCRIPTION
    # 9.KERNEL_TAGS  10.PLATFORM  11.FAMILY  12.BOOT_CONF  13.BOARD  14.BUILD
    [[ -f "${model_conf}" ]] || error_msg "Missing model config file: [ ${model_conf} ]"

    # Convert ${model_conf} to ${model_txt} for [ openwrt-install-amlogic ], Just the first 8 columns.
    cat ${model_conf} |
        sed -e 's/NULL/NA/g' -e 's/[ ][ ]*//g' |
        grep -E "^[^#ar].*" |
        awk -F':' '{if ($6 != "NA") $6 = "/lib/u-boot/"$6; if ($7 != "NA") $7 = "/lib/u-boot/"$7; NF = 8; print}' OFS=':' \
            >${model_txt}

    # Get a list of build devices
    if [[ "${make_board}" == "all" ]]; then
        board_list=":(yes)"
        make_openwrt=($(
            cat ${model_conf} |
                sed -e 's/NA//g' -e 's/NULL//g' -e 's/[ ][ ]*//g' |
                grep -E "^[^#].*:yes$" | awk -F':' '{print $13}' |
                sort -u | xargs
        ))
    else
        board_list=":($(echo ${make_board} | sed -e 's/_/\|/g')):(yes|no)"
        make_openwrt=($(echo ${make_board} | sed -e 's/_/ /g'))
    fi
    [[ "${#make_openwrt[*]}" -eq "0" ]] && error_msg "The board is missing, stop making."

    # Get a list of kernel
    kernel_from=($(
        cat ${model_conf} |
            sed -e 's/NA//g' -e 's/NULL//g' -e 's/[ ][ ]*//g' -e 's/\.y/\.1/g' |
            grep -E "^[^#].*${board_list}$" | awk -F':' '{print $9}' |
            sort -u | xargs
    ))
    [[ "${#kernel_from[*]}" -eq "0" ]] && error_msg "Missing [ KERNEL_TAGS ] settings, stop building."
    # Replace custom kernel tags
    [[ -n "${kernel_usage}" ]] && {
        specific_tags="${kernel_usage}"
        kernel_from=(${kernel_from[*]//${default_tags}/${kernel_usage}})
    }

    # The [ specific kernel ], Use the [ kernel version number ], such as 5.15.y, 6.1.y, etc. download from [ kernel_stable ].
    specific_kernel=($(echo ${kernel_from[*]} | sed -e 's/[ ][ ]*/\n/g' | grep -E "^[0-9]+" | sort -u | xargs))

    # The [ suffix ] of KERNEL_TAGS starts with a [ letter ], such as kernel_stable, kernel_rk3588, etc.
    tags_list=($(echo ${kernel_from[*]} | sed -e 's/[ ][ ]*/\n/g' | grep -E "^[a-z]" | sort -u | xargs))
    # Add the specific kernel to the list
    [[ "${#specific_kernel[*]}" -ne "0" ]] && tags_list=(${tags_list[*]} "specific")
    # Check the kernel list
    [[ "${#tags_list[*]}" -eq "0" ]] && error_msg "The [ tags_list ] is missing, stop building."

    # Convert kernel repository address to api format
    [[ "${kernel_repo}" =~ ^https: ]] && kernel_repo="$(echo ${kernel_repo} | awk -F'/' '{print $4"/"$5}')"
    kernel_api="https://api.github.com/repos/${kernel_repo}"
}

find_openwrt() {
    cd ${current_path}
    echo -e "${STEPS} Start searching for OpenWrt file..."

    # Find whether the OpenWrt file exists
    openwrt_default_file="$(ls ${openwrt_path}/${openwrt_rootfs_file} 2>/dev/null | head -n 1 | awk -F "/" '{print $NF}')"
    if [[ -n "${openwrt_default_file}" ]]; then
        echo -e "${INFO} OpenWrt file: [ ${openwrt_default_file} ]"
    else
        error_msg "There is no [ ${openwrt_rootfs_file} ] file in the [ ${openwrt_path} ] directory."
    fi

    # Extract the OpenWrt release information file
    source_codename=""
    source_release_file="etc/openwrt_release"
    temp_dir="$(mktemp -d)"
    (cd ${temp_dir} && tar -mxzf "${openwrt_path}/${openwrt_default_file}" "./${source_release_file}" 2>/dev/null)
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

    # Download platform files
    svn co ${depends_repo}/armbian-files/platform-files ${platform_files} --force
    # Remove the special files in the [ sbin ] directory of the Armbian system
    rm -rf $(find ${platform_files} -type d -name "sbin")

    # Download different files
    svn co ${depends_repo}/armbian-files/different-files ${different_files} --force

    # Download u-boot files
    if [[ -d "${uboot_path}" ]]; then
        svn up ${uboot_path} --force
    else
        svn co ${depends_repo}/u-boot ${uboot_path} --force
    fi

    # Download Armbian firmware files
    svn co ${firmware_repo} ${firmware_path} --force

    # Download balethirq related files
    svn export ${depends_repo}/armbian-files/common-files/usr/sbin/balethirq.pl ${common_files}/usr/sbin --force
    svn export ${depends_repo}/armbian-files/common-files/etc/balance_irq ${common_files}/etc --force

    # Download install/update and other related files
    svn export ${script_repo}/root/usr/sbin ${common_files}/usr/sbin --force
    chmod +x ${common_files}/usr/sbin/*
    svn export ${script_repo}/root/usr/share/amlogic ${common_files}/usr/share/amlogic --force
    chmod +x ${common_files}/usr/share/amlogic/*
}

query_kernel() {
    echo -e "${STEPS} Start querying the latest kernel version..."

    # Check the version on the kernel repository
    x="1"
    for k in ${tags_list[*]}; do
        {
            # Select the kernel list
            kd="${k}"
            case "${k}" in
            stable)
                down_kernel_list=(${stable_kernel[*]})
                ;;
            flippy)
                down_kernel_list=(${flippy_kernel[*]})
                ;;
            dev)
                down_kernel_list=(${dev_kernel[*]})
                ;;
            rk3588)
                down_kernel_list=(${rk3588_kernel[*]})
                ;;
            specific)
                down_kernel_list=(${specific_kernel[*]})
                kd="${specific_tags}"
                ;;
            *) error_msg "Invalid tags." ;;
            esac

            # Query the name of the latest kernel version
            tmp_arr_kernels=()
            i=1
            for kernel_var in ${down_kernel_list[*]}; do
                echo -e "${INFO} (${x}.${i}) Auto query the latest kernel version for [ ${k} - ${kernel_var} ]"

                # Identify the kernel <VERSION> and <PATCHLEVEL>, such as [ 6.1 ]
                kernel_verpatch="$(echo ${kernel_var} | awk -F '.' '{print $1"."$2}')"

                if [[ -n "${gh_token}" ]]; then
                    latest_version="$(
                        curl -s \
                            -H "Accept: application/vnd.github+json" \
                            -H "Authorization: Bearer ${gh_token}" \
                            ${kernel_api}/releases/tags/kernel_${kd} |
                            jq -r '.assets[].name' |
                            grep -oE "${kernel_verpatch}\.[0-9]+" |
                            sort -rV | head -n 1
                    )"
                    query_api="Authenticated user request"
                else
                    latest_version="$(
                        curl -s \
                            -H "Accept: application/vnd.github+json" \
                            ${kernel_api}/releases/tags/kernel_${kd} |
                            jq -r '.assets[].name' |
                            grep -oE "${kernel_verpatch}\.[0-9]+" |
                            sort -rV | head -n 1
                    )"
                    query_api="Unauthenticated user request"
                fi

                if [[ "${?}" -eq "0" && -n "${latest_version}" ]]; then
                    tmp_arr_kernels[${i}]="${latest_version}"
                else
                    tmp_arr_kernels[${i}]="${kernel_var}"
                fi

                echo -e "${INFO} (${x}.${i}) [ ${k} - ${tmp_arr_kernels[$i]} ] is latest kernel (${query_api}). \n"

                let i++
            done

            # Reset the kernel array to the latest kernel version
            case "${k}" in
            stable)
                unset stable_kernel
                stable_kernel=(${tmp_arr_kernels[*]})
                ;;
            flippy)
                unset flippy_kernel
                flippy_kernel=(${tmp_arr_kernels[*]})
                ;;
            dev)
                unset dev_kernel
                dev_kernel=(${tmp_arr_kernels[*]})
                ;;
            rk3588)
                unset rk3588_kernel
                rk3588_kernel=(${tmp_arr_kernels[*]})
                ;;
            specific)
                unset specific_kernel
                specific_kernel=(${tmp_arr_kernels[*]})
                ;;
            *) error_msg "Invalid tags." ;;
            esac

            let x++
        }
    done
}

check_kernel() {
    [[ -n "${1}" ]] && check_path="${1}" || error_msg "Invalid kernel path to check."
    check_files=($(cat "${check_path}/sha256sums" | awk '{print $2}'))
    for cf in ${check_files[*]}; do
        {
            # Check if file exists
            [[ -s "${check_path}/${cf}" ]] || error_msg "The [ ${cf} ] file is missing."
            # Check if the file sha256sum is correct
            tmp_sha256sum="$(sha256sum "${check_path}/${cf}" | awk '{print $1}')"
            tmp_checkcode="$(cat ${check_path}/sha256sums | grep ${cf} | awk '{print $1}')"
            [[ "${tmp_sha256sum}" == "${tmp_checkcode}" ]] || error_msg "[ ${cf} ]: sha256sum verification failed."
        }
    done
    echo -e "${INFO} All [ ${#check_files[*]} ] kernel files are sha256sum checked to be complete.\n"
}

download_kernel() {
    cd ${current_path}
    echo -e "${STEPS} Start downloading the kernel files..."

    x="1"
    for k in ${tags_list[*]}; do
        {
            # Set the kernel download list
            kd="${k}"
            case "${k}" in
            stable)
                down_kernel_list=(${stable_kernel[*]})
                ;;
            flippy)
                down_kernel_list=(${flippy_kernel[*]})
                ;;
            dev)
                down_kernel_list=(${dev_kernel[*]})
                ;;
            rk3588)
                down_kernel_list=(${rk3588_kernel[*]})
                ;;
            specific)
                down_kernel_list=(${specific_kernel[*]})
                kd="${specific_tags}"
                ;;
            *) error_msg "Invalid tags." ;;
            esac

            # Download the kernel to the storage directory
            i="1"
            for kernel_var in ${down_kernel_list[*]}; do
                if [[ ! -d "${kernel_path}/${kd}/${kernel_var}" ]]; then
                    kernel_down_from="https://github.com/${kernel_repo}/releases/download/kernel_${kd}/${kernel_var}.tar.gz"
                    echo -e "${INFO} (${x}.${i}) [ ${k} - ${kernel_var} ] Kernel download from [ ${kernel_down_from} ]"

                    mkdir -p ${kernel_path}/${kd}
                    wget "${kernel_down_from}" -q -P "${kernel_path}/${kd}"
                    [[ "${?}" -ne "0" ]] && error_msg "Failed to download the kernel files from the server."

                    tar -mxzf "${kernel_path}/${kd}/${kernel_var}.tar.gz" -C "${kernel_path}/${kd}"
                    [[ "${?}" -ne "0" ]] && error_msg "[ ${kernel_var} ] kernel decompression failed."
                else
                    echo -e "${INFO} (${x}.${i}) [ ${k} - ${kernel_var} ] Kernel is in the local directory."
                fi

                # If the kernel contains the sha256sums file, check the files integrity
                [[ -f "${kernel_path}/${kd}/${kernel_var}/sha256sums" ]] && check_kernel "${kernel_path}/${kd}/${kernel_var}"

                let i++
            done

            # Delete downloaded kernel temporary files
            rm -f ${kernel_path}/${kd}/*.tar.gz
            sync

            let x++
        }
    done
}

confirm_version() {
    cd ${current_path}

    # Columns of ${model_conf}:
    # 1.ID  2.MODEL  3.SOC  4.FDTFILE  5.UBOOT_OVERLOAD  6.MAINLINE_UBOOT  7.BOOTLOADER_IMG  8.DESCRIPTION
    # 9.KERNEL_TAGS  10.PLATFORM  11.FAMILY  12.BOOT_CONF  13.BOARD  14.BUILD
    # Column 5, called <UBOOT_OVERLOAD> in Amlogic, <TRUST_IMG> in Rockchip, Not used in Allwinner.

    # Find [ the first ] configuration information with [ the same BOARD name ] and [ BUILD as yes ] in the ${model_conf} file.
    board_conf="$(
        cat ${model_conf} |
            sed -e 's/NA//g' -e 's/NULL//g' -e 's/[ ][ ]*//g' |
            grep -E "^[^#].*:${board}:(yes|no)$" |
            head -n 1
    )"
    [[ -n "${board_conf}" ]] || error_msg "[ ${board} ] config is missing!"

    # Get device settings options
    SOC="$(echo ${board_conf} | awk -F':' '{print $3}')"
    FDTFILE="$(echo ${board_conf} | awk -F':' '{print $4}')"
    UBOOT_OVERLOAD="$(echo ${board_conf} | awk -F':' '{print $5}')"
    TRUST_IMG="${UBOOT_OVERLOAD}"
    MAINLINE_UBOOT="$(echo ${board_conf} | awk -F':' '{print $6}')"
    BOOTLOADER_IMG="$(echo ${board_conf} | awk -F':' '{print $7}')"
    KERNEL_TAGS="$(echo ${board_conf} | awk -F':' '{print $9}')"
    PLATFORM="$(echo ${board_conf} | awk -F':' '{print $10}')"
    FAMILY="$(echo ${board_conf} | awk -F':' '{print $11}')"
    BOOT_CONF="$(echo ${board_conf} | awk -F':' '{print $12}')"

    # Check whether the key parameters are correct
    [[ -n "${PLATFORM}" ]] || error_msg "Invalid PLATFORM parameter: [ ${PLATFORM} ]"
    # Set supported platform name
    support_platform=("amlogic" "rockchip" "allwinner")
    [[ -n "$(echo "${support_platform[*]}" | grep -w "${PLATFORM}")" ]] || error_msg "[ ${PLATFORM} ] not supported."

    # Replace custom kernel tags
    [[ -n "${kernel_usage}" && "${KERNEL_TAGS}" == "${default_tags}" ]] && KERNEL_TAGS="${kernel_usage}"
}

make_image() {
    process_msg "(1/6) Make OpenWrt image."
    cd ${current_path}

    # Set Armbian image file parameters
    [[ "${PLATFORM}" == "amlogic" ]] && {
        skip_mb="4"
        partition_table_type="msdos"
        bootfs_type="fat32"
    }
    [[ "${PLATFORM}" == "rockchip" ]] && {
        skip_mb="16"
        partition_table_type="gpt"
        bootfs_type="ext4"
    }
    [[ "${PLATFORM}" == "allwinner" ]] && {
        skip_mb="16"
        partition_table_type="msdos"
        bootfs_type="fat32"
    }

    # Set OpenWrt filename
    [[ -d "${out_path}" ]] || mkdir -p ${out_path}
    openwrt_filename="openwrt${source_codename}_${PLATFORM}_${board}_k${kernel}_$(date +"%Y.%m.%d").img"
    build_image_file="${out_path}/${openwrt_filename}"
    rm -f ${build_image_file}

    IMG_SIZE="$((skip_mb + boot_mb + root_mb))"
    truncate -s ${IMG_SIZE}M ${build_image_file} >/dev/null 2>&1

    parted -s ${build_image_file} mklabel ${partition_table_type} 2>/dev/null
    parted -s ${build_image_file} mkpart primary ${bootfs_type} $((skip_mb))MiB $((skip_mb + boot_mb - 1))MiB 2>/dev/null
    parted -s ${build_image_file} mkpart primary btrfs $((skip_mb + boot_mb))MiB 100% 2>/dev/null

    # Mount the OpenWrt image file
    loop_new="$(losetup -P -f --show "${build_image_file}")"
    [[ -n "${loop_new}" ]] || error_msg "losetup ${build_image_file} failed."

    # Confirm BOOT_UUID
    BOOT_UUID="$(cat /proc/sys/kernel/random/uuid)"
    [[ -z "${BOOT_UUID}" ]] && BOOT_UUID="$(uuidgen)"
    [[ -z "${BOOT_UUID}" ]] && error_msg "The uuidgen is invalid, cannot continue."
    # Confirm ROOTFS_UUID
    ROOTFS_UUID="$(cat /proc/sys/kernel/random/uuid)"
    [[ -z "${ROOTFS_UUID}" ]] && ROOTFS_UUID="$(uuidgen)"
    [[ -z "${ROOTFS_UUID}" ]] && error_msg "The uuidgen is invalid, cannot continue."

    # Format bootfs partition
    if [[ "${bootfs_type}" == "fat32" ]]; then
        mkfs.vfat -F 32 -n "BOOT" ${loop_new}p1 >/dev/null 2>&1
    else
        mkfs.ext4 -F -q -U ${BOOT_UUID} -L "BOOT" -b 4k -m 0 ${loop_new}p1 >/dev/null 2>&1
    fi

    # Format rootfs partition
    mkfs.btrfs -f -U ${ROOTFS_UUID} -L "ROOTFS" -m single ${loop_new}p2 >/dev/null 2>&1

    # Write the specific bootloader for [ Amlogic ] boxes
    [[ "${PLATFORM}" == "amlogic" ]] && {
        bootloader_path="${uboot_path}/${PLATFORM}/bootloader"
        if [[ -n "${MAINLINE_UBOOT}" && -f "${bootloader_path}/${MAINLINE_UBOOT}" ]]; then
            dd if="${bootloader_path}/${MAINLINE_UBOOT}" of="${loop_new}" conv=fsync bs=1 count=444 2>/dev/null
            dd if="${bootloader_path}/${MAINLINE_UBOOT}" of="${loop_new}" conv=fsync bs=512 skip=1 seek=1 2>/dev/null
            #echo -e "${INFO} 01. For [ ${board} ] write bootloader: ${MAINLINE_UBOOT}"
        elif [[ -n "${BOOTLOADER_IMG}" && -f "${bootloader_path}/${BOOTLOADER_IMG}" ]]; then
            dd if="${bootloader_path}/${BOOTLOADER_IMG}" of="${loop_new}" conv=fsync bs=1 count=444 2>/dev/null
            dd if="${bootloader_path}/${BOOTLOADER_IMG}" of="${loop_new}" conv=fsync bs=512 skip=1 seek=1 2>/dev/null
            #echo -e "${INFO} 02. For [ ${board} ] write bootloader: ${BOOTLOADER_IMG}"
        fi
    }

    # Write the specific bootloader for [ Rockchip ] boxes
    [[ "${PLATFORM}" == "rockchip" ]] && {
        bootloader_path="${uboot_path}/${PLATFORM}/${board}"
        if [[ -n "${BOOTLOADER_IMG}" && -f "${bootloader_path}/${BOOTLOADER_IMG}" ]] &&
            [[ -n "${MAINLINE_UBOOT}" && -f "${bootloader_path}/${MAINLINE_UBOOT}" ]] &&
            [[ -n "${TRUST_IMG}" && -f "${bootloader_path}/${TRUST_IMG}" ]]; then
            dd if="${bootloader_path}/${BOOTLOADER_IMG}" of="${loop_new}" conv=fsync,notrunc bs=512 seek=64 2>/dev/null
            dd if="${bootloader_path}/${MAINLINE_UBOOT}" of="${loop_new}" conv=fsync,notrunc bs=512 seek=16384 2>/dev/null
            dd if="${bootloader_path}/${TRUST_IMG}" of="${loop_new}" conv=fsync,notrunc bs=512 seek=24576 2>/dev/null
            #echo -e "${INFO} 01. For [ ${board} ] write bootloader: ${TRUST_IMG}"
        elif [[ -n "${BOOTLOADER_IMG}" && -f "${bootloader_path}/${BOOTLOADER_IMG}" ]] &&
            [[ -n "${MAINLINE_UBOOT}" && -f "${bootloader_path}/${MAINLINE_UBOOT}" ]]; then
            dd if="${bootloader_path}/${BOOTLOADER_IMG}" of="${loop_new}" conv=fsync,notrunc bs=512 seek=64 2>/dev/null
            dd if="${bootloader_path}/${MAINLINE_UBOOT}" of="${loop_new}" conv=fsync,notrunc bs=512 seek=16384 2>/dev/null
            #echo -e "${INFO} 02. For [ ${board} ] write bootloader: ${MAINLINE_UBOOT}"
        elif [[ -n "${BOOTLOADER_IMG}" && -f "${bootloader_path}/${BOOTLOADER_IMG}" ]]; then
            dd if="${bootloader_path}/${BOOTLOADER_IMG}" of="${loop_new}" conv=fsync,notrunc bs=512 skip=64 seek=64 2>/dev/null
            #echo -e "${INFO} 03. For [ ${board} ] write bootloader: ${BOOTLOADER_IMG}"
        fi
    }

    # Write the specific bootloader for [ Allwinner ] boxes
    [[ "${PLATFORM}" == "allwinner" ]] && {
        bootloader_path="${uboot_path}/${PLATFORM}/${board}"
        if [[ -n "${BOOTLOADER_IMG}" && -f "${bootloader_path}/${BOOTLOADER_IMG}" ]] &&
            [[ -n "${MAINLINE_UBOOT}" && -f "${bootloader_path}/${MAINLINE_UBOOT}" ]]; then
            dd if="${bootloader_path}/${BOOTLOADER_IMG}" of="${loop_new}" conv=fsync,notrunc bs=8k seek=1 2>/dev/null
            dd if="${bootloader_path}/${MAINLINE_UBOOT}" of="${loop_new}" conv=fsync,notrunc bs=8k seek=5 2>/dev/null
            #echo -e "${INFO} 01. For [ ${board} ] write bootloader: ${MAINLINE_UBOOT}"
        elif [[ -n "${BOOTLOADER_IMG}" && -f "${bootloader_path}/${BOOTLOADER_IMG}" ]]; then
            dd if="${bootloader_path}/${BOOTLOADER_IMG}" of="${loop_new}" conv=fsync,notrunc bs=8k seek=1 2>/dev/null
            #echo -e "${INFO} 02. For [ ${board} ] write bootloader: ${BOOTLOADER_IMG}"
        fi
    }
}

extract_openwrt() {
    process_msg "(2/6) Extract OpenWrt files."
    cd ${current_path}

    # Create a dual-partition general directory
    tag_bootfs="${tmp_path}/${kernel}/${board}/bootfs"
    tag_rootfs="${tmp_path}/${kernel}/${board}/rootfs"
    mkdir -p ${tag_bootfs} ${tag_rootfs}

    # Mount bootfs
    if [[ "${bootfs_type}" == "fat32" ]]; then
        mount_try vfat ${loop_new}p1 ${tag_bootfs}
    else
        mount_try ext4 ${loop_new}p1 ${tag_bootfs}
    fi

    # Mount rootfs
    mount_try btrfs ${loop_new}p2 ${tag_rootfs}

    # Create snapshot directory
    btrfs subvolume create ${tag_rootfs}/etc >/dev/null 2>&1

    # Unzip the OpenWrt rootfs file
    tar -mxzf ${openwrt_path}/${openwrt_default_file} -C ${tag_rootfs}
    rm -rf ${tag_rootfs}/lib/modules/*
    rm -f ${tag_rootfs}/rom/sbin/firstboot

    # Copy the common files
    [[ -d "${common_files}" ]] && cp -af ${common_files}/* ${tag_rootfs}

    # Copy the platform files
    platform_bootfs="${platform_files}/${PLATFORM}/bootfs"
    platform_rootfs="${platform_files}/${PLATFORM}/rootfs"
    [[ -d "${platform_bootfs}" ]] && cp -rf ${platform_bootfs}/* ${tag_bootfs}
    [[ -d "${platform_rootfs}" ]] && cp -af ${platform_rootfs}/* ${tag_rootfs}

    # Copy the different files
    different_bootfs="${different_files}/${board}/bootfs"
    different_rootfs="${different_files}/${board}/rootfs"
    [[ -d "${different_bootfs}" ]] && cp -rf ${different_bootfs}/* ${tag_bootfs}
    [[ -d "${different_rootfs}" ]] && cp -af ${different_rootfs}/* ${tag_rootfs}

    # Copy the bootloader files
    [[ -d "${tag_rootfs}/lib/u-boot" ]] || mkdir -p "${tag_rootfs}/lib/u-boot"
    rm -rf ${tag_rootfs}/lib/u-boot/*
    [[ -d "${bootloader_path}" ]] && cp -af ${bootloader_path}/* ${tag_rootfs}/lib/u-boot

    # Copy the overload files
    [[ "${PLATFORM}" == "amlogic" ]] && cp -rf ${uboot_path}/${PLATFORM}/overload/* ${tag_bootfs}

    # Remove the .svn and .git directories
    rm -rf $(find ${tmp_path} -type d -name '.svn' -o -name '.git')
}

replace_kernel() {
    process_msg "(3/6) Replace the kernel."
    cd ${current_path}

    # Determine custom kernel filename
    kernel_boot="$(ls ${kernel_path}/${kd}/${kernel}/boot-${kernel}*.tar.gz 2>/dev/null | head -n 1)"
    kernel_name="${kernel_boot##*/}" && kernel_name="${kernel_name:5:-7}"
    [[ -n "${kernel_name}" ]] || error_msg "Missing kernel files for [ ${kernel} ]"
    kernel_dtb="${kernel_path}/${kd}/${kernel}/dtb-${PLATFORM}-${kernel_name}.tar.gz"
    kernel_modules="${kernel_path}/${kd}/${kernel}/modules-${kernel_name}.tar.gz"
    [[ -s "${kernel_boot}" && -s "${kernel_dtb}" && -s "${kernel_modules}" ]] || error_msg "The 3 kernel missing."

    # 01. For /boot five files
    tar -mxzf ${kernel_boot} -C ${tag_bootfs}
    [[ "${PLATFORM}" == "amlogic" ]] && (cd ${tag_bootfs} && cp -f uInitrd-${kernel_name} uInitrd && cp -f vmlinuz-${kernel_name} zImage)
    [[ "${PLATFORM}" == "rockchip" ]] && (cd ${tag_bootfs} && ln -sf uInitrd-${kernel_name} uInitrd && ln -sf vmlinuz-${kernel_name} Image)
    [[ "${PLATFORM}" == "allwinner" ]] && (cd ${tag_bootfs} && cp -f uInitrd-${kernel_name} uInitrd && cp -f vmlinuz-${kernel_name} Image)
    [[ "$(ls ${tag_bootfs}/*${kernel_name} -l 2>/dev/null | grep "^-" | wc -l)" -ge "2" ]] || error_msg "The /boot files is missing."
    [[ "${PLATFORM}" == "amlogic" ]] && get_textoffset "${tag_bootfs}/zImage"

    # 02. For /boot/dtb/${PLATFORM}/*
    [[ -d "${tag_bootfs}/dtb/${PLATFORM}" ]] || mkdir -p ${tag_bootfs}/dtb/${PLATFORM}
    tar -mxzf ${kernel_dtb} -C ${tag_bootfs}/dtb/${PLATFORM}
    [[ "${PLATFORM}" == "rockchip" ]] && ln -sf dtb ${tag_bootfs}/dtb-${kernel_name}
    [[ "$(ls ${tag_bootfs}/dtb/${PLATFORM} -l 2>/dev/null | grep "^-" | wc -l)" -ge "2" ]] || error_msg "/boot/dtb/${PLATFORM} files is missing."

    # 03. For /lib/modules/${kernel_name}
    tar -mxzf ${kernel_modules} -C ${tag_rootfs}/lib/modules
    (cd ${tag_rootfs}/lib/modules/${kernel_name}/ && rm -f build source *.ko 2>/dev/null && find ./ -type f -name '*.ko' -exec ln -s {} ./ \;)
    [[ "$(ls ${tag_rootfs}/lib/modules/${kernel_name} -l 2>/dev/null | grep "^d" | wc -l)" -eq "1" ]] || error_msg "/usr/lib/modules kernel folder is missing."
}

refactor_bootfs() {
    process_msg "(4/6) Refactor bootfs files."
    cd ${tag_bootfs}

    # Process Amlogic series boot partition files
    [[ "${PLATFORM}" == "amlogic" && "${need_overload}" == "yes" ]] && {
        # Add u-boot.ext for Amlogic 5.10 kernel
        if [[ -n "${UBOOT_OVERLOAD}" && -f "${UBOOT_OVERLOAD}" ]]; then
            cp -f ${UBOOT_OVERLOAD} u-boot.ext
            chmod +x u-boot.ext
        elif [[ -z "${UBOOT_OVERLOAD}" || ! -f "${UBOOT_OVERLOAD}" ]]; then
            error_msg "${board} Board does not support using ${kernel} kernel, missing u-boot."
        fi
    }

    # Set uEnv.txt & extlinux.conf mount parameters
    uenv_rootdev="UUID=${ROOTFS_UUID} rootflags=compress=zstd:6 rootfstype=btrfs"
    # Set armbianEnv.txt mount parameters
    armbianenv_rootdev="UUID=${ROOTFS_UUID}"
    armbianenv_rootflags="compress=zstd:6"

    # Edit the uEnv.txt
    uenv_conf_file="uEnv.txt"
    [[ -f "${uenv_conf_file}" ]] && {
        sed -i "s|LABEL=ROOTFS|${uenv_rootdev}|g" ${uenv_conf_file}
        sed -i "s|meson.*.dtb|${FDTFILE}|g" ${uenv_conf_file}
        sed -i "s|sun.*.dtb|${FDTFILE}|g" ${uenv_conf_file}
        sed -i "s|rk.*.dtb|${FDTFILE}|g" ${uenv_conf_file}
    }

    # Add an alternate file (/boot/extlinux/extlinux.conf)
    boot_extlinux_file="extlinux/extlinux.conf.bak"
    rename_extlinux_file="extlinux/extlinux.conf"
    [[ -f "${boot_extlinux_file}" ]] && {
        sed -i "s|LABEL=ROOTFS|${uenv_rootdev}|g" ${boot_extlinux_file}
        sed -i "s|meson.*.dtb|${FDTFILE}|g" ${boot_extlinux_file}
        sed -i "s|sun.*.dtb|${FDTFILE}|g" ${boot_extlinux_file}
        sed -i "s|rk.*.dtb|${FDTFILE}|g" ${boot_extlinux_file}
        # If needed, such as t95z(s905x), rename delete .bak
        [[ "${BOOT_CONF}" == "extlinux.conf" ]] && mv -f ${boot_extlinux_file} ${rename_extlinux_file}
    }

    # Edit the armbianEnv.txt
    armbianenv_conf_file="armbianEnv.txt"
    [[ -f "${armbianenv_conf_file}" ]] && {
        sed -i "s|^fdtfile=.*|fdtfile=${PLATFORM}/${FDTFILE}|g" ${armbianenv_conf_file}
        sed -i "s|^rootdev=.*|rootdev=${armbianenv_rootdev}|g" ${armbianenv_conf_file}
        sed -i "s|^rootfstype=.*|rootfstype=btrfs|g" ${armbianenv_conf_file}
        sed -i "s|^rootflags=.*|rootflags=${armbianenv_rootflags}|g" ${armbianenv_conf_file}
        sed -i "s|^overlay_prefix=.*|overlay_prefix=${FAMILY}|g" ${armbianenv_conf_file}
    }

    # Check device configuration files
    [[ -f "${uenv_conf_file}" || -f "${rename_extlinux_file}" || -f "${armbianenv_conf_file}" ]] || error_msg "Missing [ /boot/*Env.txt ]"
}

refactor_rootfs() {
    process_msg "(5/6) Refactor rootfs files."
    cd ${tag_rootfs}

    # Add directory
    mkdir -p .reserved boot run

    # Edit fstab
    [[ -f "etc/fstab" && -f "etc/config/fstab" ]] || error_msg "The [ fstab ] files does not exist."
    sed -i "s|LABEL=ROOTFS|UUID=${ROOTFS_UUID}|g" etc/fstab
    sed -i "s|option label 'ROOTFS'|option uuid '${ROOTFS_UUID}'|g" etc/config/fstab

    # Modify the default script to [ bash ] for [ cpustat ]
    [[ -x "bin/bash" ]] && {
        sed -i "s/\/bin\/ash/\/bin\/bash/" etc/passwd
        sed -i "s/\/bin\/ash/\/bin\/bash/" usr/libexec/login.sh
    }

    # Turn off hw_flow by default
    [[ -f "etc/config/turboacc" ]] && {
        sed -i "s|option hw_flow.*|option hw_flow '0'|g" etc/config/turboacc
        sed -i "s|option sw_flow.*|option sw_flow '0'|g" etc/config/turboacc
    }

    # Add custom startup script
    custom_startup_script="etc/custom_service/start_service.sh"
    [[ -x "${custom_startup_script}" && -f "etc/rc.local" ]] && {
        sed -i '/^exit 0/i\bash /etc/custom_service/start_service.sh' etc/rc.local
    }

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
    echo "bcmdhd" >etc/modules.d/bcmdhd
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
    echo "mt76x2e" >etc/modules.d/mt76x2e
    echo "mt7921e" >etc/modules.d/mt7921e
    # GPU Driver
    echo "panfrost" >etc/modules.d/panfrost
    # PWM Driver
    echo "pwm_meson" >etc/modules.d/pwm_meson
    # Ath10k Driver
    echo "ath10k_core" >etc/modules.d/ath10k_core
    echo "ath10k_sdio" >etc/modules.d/ath10k_sdio
    echo "ath10k_usb" >etc/modules.d/ath10k_usb
    echo "ath10k_pci" >etc/modules.d/ath10k-pci
    echo "ath10k_core frame_mode=2" >etc/modules.d/ath10k
    # Enable watchdog driver
    echo "meson_gxbb_wdt" >etc/modules.d/watchdog
    # For rk3588
    echo "bifrost_kbase" >etc/modules.d/rk_gpu
    echo "rknpu" >etc/modules.d/rk_npu
    # For rk3568
    echo "rockchipdrm" >etc/modules.d/drm-rockchip
    echo "rk_crypto2" >etc/modules.d/rk_crypto
    echo -e "snd_soc_simple_card_utils\nsnd_soc_simple_card\nsnd_soc_rockchip_i2s" >etc/modules.d/snd-rk3568
    echo "pwm_fan" >etc/modules.d/pwm-fan
    # For rk3328
    echo -e "snd_soc_simple_card_utils\nsnd_soc_simple_card\nsnd_soc_rockchip_i2s" >etc/modules.d/snd-rk3328

    # Add blacklist
    mkdir -p etc/modprobe.d
    cat >etc/modprobe.d/99-local.conf <<EOF
blacklist snd_soc_meson_aiu_i2s
alias brnf br_netfilter
alias pwm pwm_meson
alias wifi brcmfmac
EOF

    # Adjust startup settings
    [[ -f "etc/init.d/boot" ]] && {
        if ! grep -q 'ulimit -n' etc/init.d/boot; then
            sed -i '/kmodloader/i \\tulimit -n 51200\n' etc/init.d/boot
        fi
        if ! grep -q '/tmp/update' etc/init.d/boot; then
            sed -i '/mkdir -p \/tmp\/.uci/a \\tmkdir -p \/tmp\/update' etc/init.d/boot
        fi
    }
    [[ -f "etc/inittab" ]] && {
        sed -i 's/ttyAMA0/ttyAML0/' etc/inittab
        sed -i 's/ttyS0/tty0/' etc/inittab
    }

    # Automatic expansion of the third and fourth partitions
    echo "yes" >root/.todo_rootfs_resize

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
    mac_end=$(for i in {1..6}; do echo -n ${mac_hexchars:$((${RANDOM} % 16)):1}; done | sed -e 's/\(..\)/:\1/g')
    random_macaddr="9E:62${mac_end}"

    # Optimize wifi/bluetooth module
    [[ -d "lib/firmware/brcm" ]] && (
        cd lib/firmware/brcm/ && rm -f ../*.hcd

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
        # ct2000 s922x is brm4359
        sed -i "s/macaddr=.*/macaddr=${random_macaddr}:08/" "brcmfmac4359-sdio.ali,ct2000.txt"
    )

    # Add firmware version information to the terminal page
    [[ -f "etc/banner" ]] && {
        echo " Install OpenWrt: System → Amlogic Service → Install OpenWrt" >>etc/banner
        echo " Update  OpenWrt: System → Amlogic Service → Online  Update" >>etc/banner
        echo " Board: ${board} | OpenWrt Kernel: ${kernel_name}" >>etc/banner
        echo " Production Date: $(date +%Y-%m-%d)" >>etc/banner
        echo "───────────────────────────────────────────────────────────────────────" >>etc/banner
    }

    # Add firmware information
    echo "PLATFORM='${PLATFORM}'" >>${op_release}
    echo "SOC='${SOC}'" >>${op_release}
    echo "FDTFILE='${FDTFILE}'" >>${op_release}
    echo "FAMILY='${FAMILY}'" >>${op_release}
    echo "BOARD='${board}'" >>${op_release}
    echo "KERNEL_VERSION='${kernel}'" >>${op_release}
    echo "KERNEL_TAGS='${KERNEL_TAGS}'" >>${op_release}
    echo "BOOT_CONF='${BOOT_CONF}'" >>${op_release}
    echo "PACKAGED_DATE='$(date +%Y-%m-%d)'" >>${op_release}
    echo "MAINLINE_UBOOT='/lib/u-boot/${MAINLINE_UBOOT}'" >>${op_release}
    echo "ANDROID_UBOOT='/lib/u-boot/${BOOTLOADER_IMG}'" >>${op_release}
    if [[ "${PLATFORM}" == "rockchip" ]]; then
        echo "TRUST_IMG='/lib/u-boot/${TRUST_IMG}'" >>${op_release}
    elif [[ "${PLATFORM}" == "amlogic" ]]; then
        echo "UBOOT_OVERLOAD='${UBOOT_OVERLOAD}'" >>${op_release}
    fi
    if [[ "${PLATFORM}" == "rockchip" ]]; then
        echo "SHOW_INSTALL_MENU='no'" >>${op_release}
    else
        echo "SHOW_INSTALL_MENU='yes'" >>${op_release}
    fi

    cd ${current_path}

    # Create snapshot
    mkdir -p ${tag_rootfs}/.snapshots
    btrfs subvolume snapshot -r ${tag_rootfs}/etc ${tag_rootfs}/.snapshots/etc-000 >/dev/null 2>&1

    sync && sleep 3
}

clean_tmp() {
    process_msg "(6/6) Cleanup tmp files."
    cd ${current_path}

    # Unmount the OpenWrt image file
    fstrim ${tag_bootfs} 2>/dev/null
    fstrim ${tag_rootfs} 2>/dev/null
    umount -f ${tag_bootfs} 2>/dev/null
    umount -f ${tag_rootfs} 2>/dev/null
    losetup -d ${loop_new} 2>/dev/null

    cd ${out_path}
    # Compress the OpenWrt image file
    pigz -qf ${openwrt_filename} || gzip -qf ${openwrt_filename}

    cd ${current_path}
    # Clear temporary files directory
    rm -rf ${tmp_path} && sync
}

loop_make() {
    cd ${current_path}
    echo -e "${STEPS} Start making OpenWrt firmware..."

    j="1"
    for b in ${make_openwrt[*]}; do
        {

            # Set specific configuration for building OpenWrt system
            board="${b}"
            confirm_version

            # Determine kernel tags
            kd="${KERNEL_TAGS}"
            case "${KERNEL_TAGS}" in
            stable)
                kernel_list=(${stable_kernel[*]})
                ;;
            flippy)
                kernel_list=(${flippy_kernel[*]})
                ;;
            dev)
                kernel_list=(${dev_kernel[*]})
                ;;
            rk3588)
                kernel_list=(${rk3588_kernel[*]})
                ;;
            [0-9]*)
                kernel_list=(${specific_kernel[*]})
                kd="${specific_tags}"
                ;;
            *) error_msg "Invalid tags." ;;
            esac

            i="1"
            for k in ${kernel_list[*]}; do
                {
                    kernel="${k}"

                    # Skip inapplicable kernels
                    if [[ "${KERNEL_TAGS}" =~ ^[0-9]{1,2}\.[0-9]+ ]]; then
                        [[ "${kernel}" != "$(echo ${KERNEL_TAGS} | awk -F'.' '{print $1"."$2"."}')"* ]] && {
                            echo -e "(${j}.${i}) ${TIPS} The [ ${board} ] device cannot use [ ${kd}/${kernel} ] kernel, skip."
                            let i++
                            continue
                        }
                    fi

                    # Check disk space size
                    echo -ne "(${j}.${i}) Start making OpenWrt [\033[92m ${board} - ${kd}/${kernel} \033[0m]. "
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
                    refactor_bootfs
                    refactor_rootfs
                    clean_tmp

                    echo -e "(${j}.${i}) OpenWrt made successfully. \n"
                    let i++
                }
            done

            let j++
        }
    done
}

# Show welcome message
echo -e "${STEPS} Welcome to make OpenWrt!"
echo -e "${INFO} Server running on Ubuntu: [ Release: ${host_release} / Host: ${arch_info} ] \n"
# Check script permission
[[ "$(id -u)" == "0" ]] || error_msg "please run this script as root: [ sudo ./${0} ]"

# Initialize variables and download the kernel
init_var "${@}"
check_data
# Find OpenWrt file
find_openwrt
# Download the dependency files
download_depends
# Query the latest kernel version
[[ "${auto_kernel}" == "true" ]] && query_kernel
# Download the kernel files
download_kernel

# Show make settings
echo -e "${INFO} [ ${#make_openwrt[*]} ] lists of OpenWrt board: [ $(echo ${make_openwrt[*]} | xargs) ]"
echo -e "${INFO} Kernel Repo: [ ${kernel_repo} ], Kernel Usage: [ ${kernel_usage} ] \n"
# Show server start information
echo -e "${INFO} Server space usage before starting to compile: \n$(df -hT ${current_path}) \n"

# Loop to make OpenWrt firmware
loop_make

# Show server end information
echo -e "${STEPS} Server space usage after compilation: \n$(df -hT ${current_path}) \n"
echo -e "${SUCCESS} All process completed successfully."
# All process completed
wait
