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
# Version: 1.1
#
#========================================================================================

# A helper function for logging with a timestamp.
custom_log="/tmp/ophub_start_service.log"
log_message() {
    echo "[$(date +"%Y.%m.%d.%H:%M:%S")] $1" >>"${custom_log}"
}

# Clear previous log and start new session.
log_message "Start the custom service..."

# System Identification
# Set the release check file to identify the device type.
ophub_release_file="/etc/ophub-release"
FDT_FILE="" # Initialize FDT_FILE to be empty.

[[ -f "${ophub_release_file}" ]] && { FDT_FILE="$(grep -oE 'meson.*dtb' "${ophub_release_file}")"; }
[[ -z "${FDT_FILE}" && -f "/boot/uEnv.txt" ]] && { FDT_FILE="$(grep -E '^FDT=.*\.dtb$' /boot/uEnv.txt | sed -E 's#.*/##')"; }
[[ -z "${FDT_FILE}" && -f "/boot/extlinux/extlinux.conf" ]] && { FDT_FILE="$(grep -E '/dtb/.*\.dtb$' /boot/extlinux/extlinux.conf | sed -E 's#.*/##')"; }
[[ -z "${FDT_FILE}" && -f "/boot/armbianEnv.txt" ]] && { FDT_FILE="$(grep -E '^fdtfile=.*\.dtb$' /boot/armbianEnv.txt | sed -E 's#.*/##')"; }
log_message "Detected FDT file: ${FDT_FILE:-'not found'}"

# Find the partition where the root filesystem is located.
ROOT_PTNAME="$(df -h /boot | tail -n1 | awk '{print $1}' | awk -F '/' '{print $3}')"
PARTITION_PATH=""
if [[ -n "${ROOT_PTNAME}" ]]; then
    log_message "Detected root partition name: ${ROOT_PTNAME}"
    # Find the disk where the partition is located, supporting multi-digit partition numbers
    case "${ROOT_PTNAME}" in
    mmcblk?p[0-9]*)
        # Using sed to remove the trailing 'p' and all numbers
        # For example, mmcblk0p1 -> mmcblk0
        DISK_NAME=$(echo "${ROOT_PTNAME}" | sed -E 's/p[0-9]+$//')
        PARTITION_NAME="p"
        ;;
    [hsv]d[a-z][0-9]*)
        # Using sed to remove all trailing numbers
        # For example, sda1 -> sda
        DISK_NAME=$(echo "${ROOT_PTNAME}" | sed -E 's/[0-9]+$//')
        PARTITION_NAME=""
        ;;
    nvme?n?p[0-9]*)
        # Using sed to remove the trailing 'p' and all numbers
        # For example, nvme0n1p1 -> nvme0n1
        DISK_NAME=$(echo "${ROOT_PTNAME}" | sed -E 's/p[0-9]+$//')
        PARTITION_NAME="p"
        ;;
    *)
        DISK_NAME=""
        PARTITION_NAME=""
        log_message "Warning: Unrecognized root partition format '${ROOT_PTNAME}'."
        ;;
    esac

    if [[ -n "${DISK_NAME}" ]]; then
        # The 4th partition is assumed for swap/data.
        PARTITION_PATH="/mnt/${DISK_NAME}${PARTITION_NAME}4"
        log_message "Derived disk name: ${DISK_NAME}. Target data partition path: ${PARTITION_PATH}"
    fi
else
    log_message "Error: Could not determine root partition."
fi

# Add network performance optimization
if [[ -x "/usr/sbin/balethirq.pl" ]]; then
    (perl /usr/sbin/balethirq.pl >/dev/null 2>&1) &
    log_message "Network optimization service (balethirq.pl) execution attempted."
fi

# Led display control
openvfd_enable="no"
openvfd_boxid="15"
if [[ "${openvfd_enable}" == "yes" && -n "${openvfd_boxid}" && -x "/usr/sbin/openwrt-openvfd" ]]; then
    (openwrt-openvfd "${openvfd_boxid}" >/dev/null 2>&1) &
    log_message "OpenVFD service execution attempted."
fi

# For vplus(Allwinner h6) led color lights
if [[ -x "/usr/bin/rgb-vplus" ]]; then
    rgb-vplus --RedName=RED --GreenName=GREEN --BlueName=BLUE &
    log_message "Vplus RGB LED service started in background."
fi

# For fan control service
if [[ -x "/usr/bin/pwm-fan.pl" ]]; then
    perl /usr/bin/pwm-fan.pl >/dev/null 2>&1 &
    log_message "Fan control service (pwm-fan.pl) started in background."
fi

# For oes(A311d) SATA LED status monitoring
if [[ -x "/usr/bin/oes_sata_leds.sh" ]]; then
    /usr/bin/oes_sata_leds.sh >/var/log/oes-sata-leds.log 2>&1 &
    log_message "SATA status check service (oes_sata_leds.sh) started in background."
fi

# Automatic expansion of the third and fourth partitions
todo_rootfs_resize="/root/.todo_rootfs_resize"
if [[ -f "${todo_rootfs_resize}" && "$(cat "${todo_rootfs_resize}" 2>/dev/null | xargs)" == "yes" ]]; then
    (openwrt-tf >/dev/null 2>&1) &
    log_message "Automatic partition expansion (openwrt-tf) attempted."
fi

# For nsy-g16-plus/nsy-g68-plus/bdy-g18-pro board
if [[ "${FDT_FILE}" =~ ^(rk3568-nsy-g16-plus\.dtb|rk3568-nsy-g68-plus\.dtb|rk3568-bdy-g18-pro\.dtb)$ ]]; then
    (
        # Wait for network to be up
        sleep 10

        # Set MTU to 1500 for eth0 and br-lan
        set_mtu() {
            [[ -d "/sys/class/net/${1}" ]] && ip link set "${1}" mtu 1500 >/dev/null 2>&1
        }
        set_mtu eth0
        set_mtu br-lan

        # Close offloading features to improve stability
        if [[ -d "/sys/class/net/eth0" ]] && command -v ethtool >/dev/null 2>&1; then
            ethtool -K eth0 tso off gso off gro off tx off rx off >/dev/null 2>&1
        fi

        # Disable firewall flow offloading
        uci set firewall.@defaults[0].flow_offloading='0'
        uci set firewall.@defaults[0].flow_offloading_hw='0'
        uci commit firewall
        /etc/init.d/firewall restart
    ) &
    log_message "Network optimizations for ${FDT_FILE} applied."
fi

# Set swap space
(
    # Wait for disk mount (max 30 seconds)
    for i in {1..10}; do
        [[ -d "${PARTITION_PATH}" ]] && break
        sleep 3
    done

    # Check and enable swap file if it exists
    if [[ -n "${PARTITION_PATH}" && -d "${PARTITION_PATH}" ]]; then
        swap_check_file="${PARTITION_PATH}/.swap/swapfile"
        if [[ -f "${swap_check_file}" ]]; then
            log_message "Swap file found at ${swap_check_file}. Attempting to enable."

            # 'local' keyword removed, as we are in the main script body.
            swap_loopdev="$(losetup -f)"
            if [[ -z "${swap_loopdev}" ]]; then
                log_message "Error: Could not find a free loop device. Skipping swap setup."
            else
                # Only proceed if a loop device was found.
                # The '&&' ensures that 'swapon' is only attempted if 'losetup' succeeds.
                if losetup "${swap_loopdev}" "${swap_check_file}" && swapon "${swap_loopdev}"; then
                    log_message "Swap file enabled successfully on ${swap_loopdev}."
                else
                    # If the chain fails at any point, log the error and clean up.
                    log_message "Error: Failed to setup swap on ${swap_loopdev}. Cleaning up..."
                    losetup -d "${swap_loopdev}" 2>/dev/null # Attempt to detach the loop device.
                fi
            fi
        fi
    else
        log_message "Warning: Swap partition path '${PARTITION_PATH}' does not exist."
    fi
) &

# Finalization
log_message "All custom services have been processed."
