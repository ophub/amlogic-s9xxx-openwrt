#!/bin/bash

#======================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Packaged OpenWrt for Amlogic S9xxx STB
# Function: Use Flippy's amlogic-s9xxx *.img files to build kernel
# Copyright (C) 2020 Flippy
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-openwrt
#======================================================================================================================
#
# example: ~/*/amlogic-s9xxx/amlogic-kernel/build_kernel/
# ├── flippy
# │   └── S9***_Openwrt*.img
# └── make_use_img.sh
#
# Usage: Use Ubuntu 18 LTS 64-bit
# 01. Log in to the home directory of the local Ubuntu system.
# 02. git clone https://github.com/ophub/amlogic-s9xxx-openwrt.git
# 03. cd ~/*/amlogic-s9xxx/amlogic-kernel/build_kernel/
# 04. Prepare Flippy's ${flippy_file}, support: S9***_Openwrt*.img, Armbian_*_Aml-s9xxx_buster*.img
#     Support to put the original .7z/.img.xz file into the directory and use it directly.
# 05. Put Flippy's ${flippy_file} file into ${flippy_folder}
# 06. Modify ${flippy_file} to kernel file name. E.g: flippy_file="N1_Openwrt_R20.10.20_k5.9.5-flippy-48+.img"
#     If the file of ${flippy_file} is not found, Will search for other *.img and *.img.xz files in directory.
# 07. Run: sudo ./make_use_img.sh
# 08. The generated files path: ~/*/amlogic-s9xxx/amlogic-kernel/kernel/${build_save_folder}
#
# Tips: If run 'sudo ./make_use_img.sh' is 'Command not found'. Run: sudo chmod +x make_use_img.sh
#
#======================================================================================================================

# Modify Flippy's kernel folder & *.img file name
build_path=${PWD}
flippy_folder=${build_path}/"flippy"
flippy_file="N1_Openwrt_R20.10.20_k5.9.5-flippy-48+.img"

# Default setting ( Don't modify )
build_tmp_folder=${build_path}/"build_tmp"
boot_tmp=${build_tmp_folder}/boot
root_tmp=${build_tmp_folder}/root
kernel_tmp=${build_tmp_folder}/kernel_tmp
modules_tmp=${build_tmp_folder}/modules_tmp/lib
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

# Check files
check_build_files() {
    echo "Check files ..."
    if  [ -f ${flippy_folder}/${flippy_file} ]; then
        echo_color "blue" "(1/7) The specified file exists." "USE: ${flippy_file} ..."
    elif [ $( ls ${flippy_folder}/*.img -l 2>/dev/null | grep "^-" | wc -l ) -ge 1 ]; then
        unset flippy_file
        flippy_file=$( ls ${flippy_folder}/*.img | head -n 1 )
        flippy_file=${flippy_file##*/}
        echo_color "yellow" "(1/7) Unset flippy_file is [ ${flippy_file} ]"  "\n \
        Try to extract the kernel using this file."
    elif [ $( ls ${flippy_folder}/*.img.xz -l 2>/dev/null | grep "^-" | wc -l ) -ge 1 ]; then
        xz_file=$( ls ${flippy_folder}/*.img.xz | head -n 1 )
        xz_file=${xz_file##*/}
        cd ${flippy_folder} && xz -d ${xz_file} && cd ../
        unset flippy_file
        flippy_file=$( ls ${flippy_folder}/*.img | head -n 1 )
        flippy_file=${flippy_file##*/}
        echo_color "yellow" "(1/7) Unset flippy_file is [ ${flippy_file} ]"  "\n \
        Try to extract the kernel using this file."
    elif [ $( ls ${flippy_folder}/*.7z -l 2>/dev/null | grep "^-" | wc -l ) -ge 1 ]; then
        xz_file=$( ls ${flippy_folder}/*.7z | head -n 1 )
        xz_file=${xz_file##*/}
        cd ${flippy_folder} && 7z x ${xz_file} -aoa -y && cd ../
        unset flippy_file
        flippy_file=$( ls ${flippy_folder}/*.img | head -n 1 )
        flippy_file=${flippy_file##*/}
        echo_color "yellow" "(1/7) Unset flippy_file is [ ${flippy_file} ]"  "\n \
        Try to extract the kernel using this file."
    else
        echo_color "red" "(1/7) Error: Please put the compiled files in the [ ${flippy_folder} ] directory." "..."
    fi

    # begin run the script
    echo_color "purple" "Start building" "..."
    echo_color "green" "(1/7) End check_build_files"  "..."
}

#losetup & mount ${flippy_file} boot:kernel.tar.xz root:modules.tar.xz
losetup_mount_img() {
   [ $(id -u) = 0 ] || echo_color "red" "(2/7) Error: Please run this script as root: " "[ sudo ./make_use_img.sh ]"

   [ -d ${build_tmp_folder} ] && rm -rf ${build_tmp_folder} 2>/dev/null
   mkdir -p ${boot_tmp} ${root_tmp} ${kernel_tmp} ${modules_tmp}

   lodev=$(losetup -P -f --show ${flippy_folder}/${flippy_file})
   [ $? = 0 ] || echo_color "red" "(2/7) losetup ${flippy_file} failed!" "..."
   mount ${lodev}p1 ${boot_tmp}
   [ $? = 0 ] || echo_color "red" "(2/7) mount ${lodev}p1 failed!" "..."
   mount ${lodev}p2 ${root_tmp}
   [ $? = 0 ] || echo_color "red" "(2/7) mount ${lodev}p2 failed!" "..."

   echo_color "green" "(2/7) End losetup_mount_img"  "Use: ${lodev} ..."
}

#copy ${boot_tmp} & ${root_tmp} Related files to ${kernel_tmp} & ${modules_tmp}
copy_boot_root() {
   cp -rf ${boot_tmp}/{dtb,config*,initrd.img*,System.map*,uInitrd,zImage} ${kernel_tmp}
   cp -rf ${root_tmp}/lib/modules ${modules_tmp}
   #Add drivers
   cp -rf ${amlogic_path}/common-files/patches/wireless/* ${modules_tmp}/modules/*/kernel/drivers/net/wireless/
   sync

   #Check core files
   if [ ! -f ${kernel_tmp}/config* -o ! -f ${kernel_tmp}/initrd.img* -o ! -f ${kernel_tmp}/System.map* -o ! -f ${kernel_tmp}/uInitrd -o ! -f ${kernel_tmp}/zImage ]; then
      echo_color "red" "(3/7) The five boot kernel files is Missing!" "..."
   fi

   if [ ! -f ${kernel_tmp}/dtb/amlogic/meson-gxl-s905d-phicomm-n1.dtb ]; then
      cp -f ${amlogic_path}/amlogic-dtb/*phicomm-n1* ${kernel_tmp}/dtb/amlogic/
      echo_color "yellow" "(3/7) The phicomm-n1 .dtb files is Missing. Has been copied from the dtb library!" "..."
   fi

   if [ ! -f ${kernel_tmp}/dtb/amlogic/meson-sm1-x96-max-plus-100m.dtb ]; then
      cp -f ${amlogic_path}/amlogic-dtb/*x96-max* ${kernel_tmp}/dtb/amlogic/
      echo_color "yellow" "(3/7) The X96 .dtb core files is Missing. Has been copied from the dtb library!" "..."
   fi

   if [ ! -f ${kernel_tmp}/dtb/amlogic/meson-sm1-hk1box-vontar-x3.dtb ]; then
      cp -f ${amlogic_path}/amlogic-dtb/*hk1box* ${kernel_tmp}/dtb/amlogic/
      echo_color "yellow" "(3/7) Some HX1 .dtb files is Missing. Has been copied from the dtb library!" "..."
   fi

   if [ ! -f ${kernel_tmp}/dtb/amlogic/meson-sm1-h96-max-x3.dtb ]; then
      cp -f ${amlogic_path}/amlogic-dtb/*h96-max* ${kernel_tmp}/dtb/amlogic/
      echo_color "yellow" "(3/7) Some H96 .dtb files is Missing. Has been copied from the dtb library!" "..."
   fi

   if [ ! -f ${kernel_tmp}/dtb/amlogic/meson-gxm-octopus-planet.dtb ]; then
      cp -f ${amlogic_path}/amlogic-dtb/*octopus* ${kernel_tmp}/dtb/amlogic/
      echo_color "yellow" "(3/7) The octopus-planet .dtb files is Missing. Has been copied from the dtb library!" "..."
   fi

   if [ ! -f ${kernel_tmp}/dtb/amlogic/meson-g12b-gtking-pro.dtb ]; then
      cp -f ${amlogic_path}/amlogic-dtb/*gtking* ${kernel_tmp}/dtb/amlogic/
      echo_color "yellow" "(3/7) The gtking .dtb files is Missing. Has been copied from the dtb library!" "..."
   fi

   if [ ! -f ${kernel_tmp}/dtb/amlogic/meson-g12b-ugoos-am6.dtb ]; then
      cp -f ${amlogic_path}/amlogic-dtb/*ugoos* ${kernel_tmp}/dtb/amlogic/
      echo_color "yellow" "(3/7) The ugoos .dtb files is Missing. Has been copied from the dtb library!" "..."
   fi

   sync
   echo_color "green" "(3/7) End copy_boot_root"  "..."
}

#get version
get_flippy_version() {
    flippy_version=$(ls ${modules_tmp}/modules/)
    build_save_folder=$(echo ${flippy_version} | grep -oE '^[1-9].[0-9]{1,2}.[0-9]+')
    mkdir -p ${build_save_folder}

    echo_color "green" "(4/7) End get_flippy_version"  "flippy_version: ${flippy_version} / build_save_folder: ${build_save_folder} ..."
}

# build kernel.tar.xz & modules.tar.xz
build_kernel_modules() {
  cd ${kernel_tmp}
     tar -cf kernel.tar *
     xz -z kernel.tar
     mv -f kernel.tar.xz ${build_path}/${build_save_folder}

  cd ${modules_tmp}/modules/${flippy_version}/
     rm -f *.ko
     x=0
     find ./ -type f -name '*.ko' -exec ln -s {} ./ \;
     sync && sleep 3
     x=$( ls *.ko -l 2>/dev/null | grep "^l" | wc -l )
     
     if [ $x -eq 0 ]; then
        echo_color "red" "(5/7) Error *.ko Files not found"  "..."
     else
        echo_color "blue" "(5/7) Have [ ${x} ] files make *.ko link"  "..."
     fi

  cd ${build_tmp_folder}/modules_tmp/
     tar -cf modules.tar *
     xz -z modules.tar
     mv -f modules.tar.xz ${build_path}/${build_save_folder}
     sync

     echo_color "green" "(5/7) End build_kernel_modules"  "..."
}

# copy kernel.tar.xz & modules.tar.xz to amlogic-s9xxx/amlogic-kernel/kernel/${build_save_folder}
copy_kernel_modules() {
    cd ${build_path}/
    cp -rf ${build_save_folder} ../kernel/ && sync
    echo_color "green" "(6/7) End copy_kernel_modules"  "Copy ${build_save_folder}/kernel.tar.xz & modules.tar.xz to ../kernel/"
}

#umount& del losetup
umount_ulosetup() {
    umount -f ${boot_tmp} 2>/dev/null
    umount -f ${root_tmp} 2>/dev/null
    losetup -d ${lodev} 2>/dev/null

    rm -rf ${build_tmp_folder} ${build_save_folder} ${flippy_folder}/* 2>/dev/null

    echo_color "green" "(7/7) End umount_ulosetup"  "..."
}

check_build_files
losetup_mount_img
copy_boot_root
get_flippy_version
build_kernel_modules
copy_kernel_modules
umount_ulosetup

echo_color "purple" "Build completed"  "${build_save_folder} ..."

# end run the script

