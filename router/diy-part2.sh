#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-kernel-for-openwrt
# Description: Automatically Build OpenWrt for S905x3-Boxs and Phicomm-N1
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Copyright (C) 2020 https://github.com/P3TERX/Actions-OpenWrt
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-kernel-for-openwrt
#========================================================================================================================

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate
# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile
# Modify default root's password（FROM 'password'[$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.] CHANGE TO 'your password'）
# sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' /etc/shadow
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings

# Mydiy-luci-app-and-theme（use to /.config luci-app&theme）
# ==========luci-app-url==========
# git clone https://github.com/kenzok8/openwrt-packages.git package/openwrt-packages
# ==========luci-theme-url==========
# svn co https://github.com/Lienol/openwrt-package/trunk/lienol/luci-theme-bootstrap-mod package/luci-theme-bootstrap-mod


#===== Recommended packages, Start =====
packages=" \
brcmfmac-firmware-43430-sdio brcmfmac-firmware-43455-sdio kmod-brcmfmac wpad kmod-fs-ext4 kmod-fs-vfat kmod-fs-exfat dosfstools e2fsprogs antfs-mount \
kmod-usb2 kmod-usb3 kmod-usb-storage kmod-usb-storage-extras kmod-usb-storage-uas kmod-usb-net kmod-usb-net-asix-ax88179 kmod-usb-net-rtl8150 kmod-usb-net-rtl8152 \
blkid lsblk parted fdisk cfdisk losetup resize2fs tune2fs pv unzip lscpu htop iperf3 curl lm-sensors 
"

sed -i '/FEATURES+=/ { s/cpiogz //; s/ext4 //; s/ramdisk //; s/squashfs //; }' target/linux/armvirt/Makefile
for x in $packages; do
    sed -i "/DEFAULT_PACKAGES/ s/$/ $x/" target/linux/armvirt/Makefile
done
#===== Recommended packages, End =====

