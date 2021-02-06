#!/bin/bash

#======================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Packaged OpenWrt for S9xxx-Boxs and Phicomm-N1
# Function: Update kernel.tar.xz files in the kernel directory with the latest dtb file.
# Copyright (C) 2020 Flippy
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-openwrt
#======================================================================================================================
#
# Usage: Use Ubuntu 18 LTS 64-bit
# 01. Log in to the home directory of the local Ubuntu system.
# 02. git clone https://github.com/ophub/amlogic-s9xxx-openwrt.git
# 03. Put the new *.dtb file into ~/*/amlogic-s9xxx/amlogic-dtb/
# 04. The script will update all core files in directory: ~/*/amlogic-s9xxx/amlogic-kernel/kernel/
# 05. cd ~/*/amlogic-s9xxx/amlogic-kernel/build_kernel/
# 06. Run: sudo ./update_dtb.sh
# 07. The updated file will overwrite in the original path: ~/*/amlogic-s9xxx/amlogic-kernel/kernel/
#
# Tips: If run 'sudo ./update_dtb.sh' is 'Command not found'. Run: sudo chmod +x update_dtb.sh
#
#======================================================================================================================

# Default setting ( Don't modify )
build_path=${PWD}
build_tmp_folder=${build_path}/"build_tmp"
amlogic_path=${build_path%/amlogic-kernel*}

# echo color codes
echo_color() {
    this_color=${1}
        case "${this_color}" in
        red)
            echo -e " \033[1;31m[ ${2} ]\033[0m ${3}"
            echo -e "--------------------------------------------"
            echo -e "Current path -PWD-:-----------------\n${PWD}"
            echo -e "Situation -lsblk-:----------------\n$(lsblk)"
            echo -e "Directory file list -ls-:----------\n$(ls .)"
            echo -e "--------------------------------------------"
            exit 1
            ;;
        green)
            echo -e " \033[1;32m[ ${2} ]\033[0m ${3}"
            ;;
        yellow)
            echo -e " \033[1;33m[ ${2} ]\033[0m ${3}"
            ;;
        blue)
            echo -e " \033[1;34m[ ${2} ]\033[0m ${3}"
            ;;
        purple)
            echo -e " \033[1;35m[ ${2} ]\033[0m ${3}"
            ;;
        *)
            echo -e " \033[1;30m[ ${2} ]\033[0m ${3}"
            ;;
        esac
}

echo_color "purple" "Start Update dtb files"  "..."

# update kernel.tar.xz *.dtb
update_kernel_dtb() {
    [ -d ${build_tmp_folder} ] || mkdir -p ${build_tmp_folder}
    cd ${build_tmp_folder}
    cp -rf ../../kernel/* .

    if  [ $( ls . -l 2>/dev/null | grep "^d" | wc -l ) -eq 0 ]; then
        echo_color "red" "(1/1) Error: No core file." "..."
    else
        echo_color "blue" "A total of [ $( ls . -l 2>/dev/null | grep "^d" | wc -l ) ] kernels will update the *.dtb files."  "\n \
        The kernel list is as follows: \n \
        $( ls -d */ | head -c-2 ) \n \
        Start Update ..."

            total_kernel=$( ls . -l 2>/dev/null | grep "^d" | wc -l )
            current_kernel=1
            for kernel_folder in $( ls -d */ | head -c-2 ); do
                kernel_version=${kernel_folder%/*}
                cd ${kernel_version}
                mkdir -p tmp_kernel && tar -xJf kernel.tar.xz -C tmp_kernel
                cp -f ${amlogic_path}/amlogic-dtb/* tmp_kernel/dtb/amlogic/ && sync && cd tmp_kernel
                tar -cf kernel.tar *
                xz -z kernel.tar
                mv -f kernel.tar.xz ../kernel.tar.xz && sync && cd ../ && rm -rf tmp_kernel && cd ../
                echo_color "blue" "(${current_kernel}/${total_kernel}) ${kernel_version}"  "The *.dtb files update complete."
                current_kernel=$(($current_kernel + 1))
            done

        cp -rf * ../../kernel/
        sync
        cd ../ && rm -rf ${build_tmp_folder}
    fi

    echo_color "green" "(1/1) End update_kernel_dtb"  "..."
}


update_kernel_dtb

echo_color "purple" "Update dtb files completed"  "..."

# end run the script

