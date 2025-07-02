#!/bin/bash
#========================================================================================
#
# This file is licensed under the terms of the GNU General Public
# License version 2. This program is licensed "as is" without any
# warranty of any kind, whether express or implied.
#
# This file is a part of the make OpenWrt for Amlogic, Rockchip and Allwinner
# https://github.com/ophub/amlogic-s9xxx-openwrt
#
# Function: Customize the startup script, adding content as needed.
# Dependent script: /etc/rc.local
# File path: /etc/custom_service/start_service.sh
#
#========================================================================================
#
# Find the partition where root is located
ROOT_PTNAME="$(df -h /boot | tail -n1 | awk '{print $1}' | awk -F '/' '{print $3}')"
if [[ -n "${ROOT_PTNAME}" ]]; then

    # Find the disk where the partition is located, only supports mmcblk?p? sd?? hd?? vd?? and other formats
    case "${ROOT_PTNAME}" in
    mmcblk?p[1-9])
        DISK_NAME="${ROOT_PTNAME:0:-2}"
        PARTITION_NAME="p"
        ;;
    [hsv]d[a-z][1-9])
        DISK_NAME="${ROOT_PTNAME:0:-1}"
        PARTITION_NAME=""
        ;;
    nvme?n?p[1-9])
        DISK_NAME="${ROOT_PTNAME:0:-2}"
        PARTITION_NAME="p"
        ;;
    *)
        DISK_NAME=""
        PARTITION_NAME=""
        ;;
    esac

    PARTITION_PATH="/mnt/${DISK_NAME}${PARTITION_NAME}4"
else
    PARTITION_PATH=""
fi
#
#========================================================================================

# Custom Service Log
custom_log="/tmp/ophub_start_service.log"

# Add custom log
echo "[$(date +"%Y.%m.%d.%H:%M:%S")] Start the custom service..." >${custom_log}

# Add network performance optimization
[[ -x "/usr/sbin/balethirq.pl" ]] && {
    perl /usr/sbin/balethirq.pl 2>/dev/null &&
        echo "[$(date +"%Y.%m.%d.%H:%M:%S")] The network optimization service started successfully." >>${custom_log}
}

# Led display control
openvfd_enable="no"
openvfd_boxid="15"
[[ "${openvfd_enable}" == "yes" && -n "${openvfd_boxid}" && -x "/usr/sbin/openwrt-openvfd" ]] && {
    openwrt-openvfd ${openvfd_boxid} &&
        echo "[$(date +"%Y.%m.%d.%H:%M:%S")] The openvfd service started successfully." >>${custom_log}
}

# For vplus(Allwinner h6) led color lights
[[ -x "/usr/bin/rgb-vplus" ]] && {
    rgb-vplus --RedName=RED --GreenName=GREEN --BlueName=BLUE &
    echo "[$(date +"%Y.%m.%d.%H:%M:%S")] The LED of Vplus is enabled successfully." >>${custom_log}
}

# For fan control service
[[ -x "/usr/bin/pwm-fan.pl" ]] && {
    perl /usr/bin/pwm-fan.pl 2>/dev/null &
    echo "[$(date +"%Y.%m.%d.%H:%M:%S")] The fan control service enabled successfully." >>${custom_log}
}

# Automatic expansion of the third and fourth partitions
todo_rootfs_resize="/root/.todo_rootfs_resize"
[[ -f "${todo_rootfs_resize}" && "$(cat ${todo_rootfs_resize} 2>/dev/null | xargs)" == "yes" ]] && {
    openwrt-tf 2>/dev/null &&
        echo "[$(date +"%Y.%m.%d.%H:%M:%S")] Automatically expand the partition successfully." >>${custom_log}
}

# Set swap check file
sawp_check_file="${PARTITION_PATH}/.swap/swapfile"
[[ -f "${sawp_check_file}" ]] && {
    # Set swap space
    swap_loopdev="$(losetup -f)"
    # Mount swap file
    losetup ${swap_loopdev} ${sawp_check_file}
    # Enable swap
    swapon ${swap_loopdev}
    [[ "${?}" == 0 ]] && echo "[$(date +"%Y.%m.%d.%H:%M:%S")] The swap file enabled successfully." >>${custom_log}
}

# Add custom log
echo "[$(date +"%Y.%m.%d.%H:%M:%S")] All custom services executed successfully!" >>${custom_log}
