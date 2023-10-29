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

# Add custom log
echo "[$(date +"%Y.%m.%d.%H:%M:%S")] All custom services executed successfully!" >>${custom_log}
