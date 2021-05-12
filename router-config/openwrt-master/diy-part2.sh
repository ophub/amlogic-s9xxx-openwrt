#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic S9xxx STB
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Copyright (C) 2020 https://github.com/P3TERX/Actions-OpenWrt
# Copyright (C) 2020 https://github.com/ophub/amlogic-s9xxx-openwrt
#========================================================================================================================

# Modify default IP（FROM 192.168.1.1 CHANGE TO 192.168.31.4）
# sed -i 's/192.168.1.1/192.168.31.4/g' package/base-files/files/bin/config_generate

# Modify default theme（FROM uci-theme-bootstrap CHANGE TO luci-theme-material）
# sed -i 's/luci-theme-bootstrap/luci-theme-material/g' ./feeds/luci/collections/luci/Makefile

# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root::0:0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.:0:0:99999:7:::/g' package/base-files/files/etc/shadow

# Add branches package from Lienol/openwrt/branches/21.02/package
svn co https://github.com/Lienol/openwrt/branches/21.02/package/{lean,default-settings} package
# Remove duplicate packages
rm -rf package/lean/{luci-app-frpc,luci-app-frps,libtorrent-rasterbar} 2>/dev/null
# Add firewall rules
zzz_iptables_row=$(sed -n '/iptables/=' package/default-settings/files/zzz-default-settings | head -n 1)
zzz_iptables_tcp=$(sed -n ${zzz_iptables_row}p  package/default-settings/files/zzz-default-settings | sed 's/udp/tcp/g')
sed -i "${zzz_iptables_row}a ${zzz_iptables_tcp}" package/default-settings/files/zzz-default-settings
sed -i 's/# iptables/iptables/g' package/default-settings/files/zzz-default-settings
# Set default language and time zone
sed -i 's/luci.main.lang=zh_cn/luci.main.lang=auto/g' package/default-settings/files/zzz-default-settings
#sed -i 's/zonename=Asia\/Shanghai/zonename=Asia\/Jayapura/g' package/default-settings/files/zzz-default-settings
#sed -i 's/timezone=CST-8/timezone=CST-9/g' package/default-settings/files/zzz-default-settings
# Add autocore support for armvirt
sed -i 's/TARGET_rockchip/TARGET_rockchip\|\|TARGET_armvirt/g' package/lean/autocore/Makefile
# Correct translation for Transmission
sed -i 's/发送/Transmission/g' feeds/luci/applications/luci-app-transmission/po/zh_Hans/transmission.po

# Add luci-app-passwall
svn co https://github.com/xiaorouji/openwrt-passwall/trunk package/openwrt-passwall
rm -rf package/openwrt-passwall/{kcptun,xray-core} 2>/dev/null

# Add luci-app-openclash
svn co https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/openwrt-openclash
pushd package/openwrt-openclash/tools/po2lmo && make && sudo make install 2>/dev/null && popd

# Add luci-app-ssr-plus
svn co https://github.com/fw876/helloworld/trunk/{luci-app-ssr-plus,shadowsocksr-libev} package/openwrt-ssrplus
rm -rf package/openwrt-ssrplus/luci-app-ssr-plus/po/zh_Hans 2>/dev/null

# Add luci-app-rclone
svn co https://github.com/ElonH/Rclone-OpenWrt/trunk package/openWrt-rclone

# Add luci-app-diskman
svn co https://github.com/lisaac/luci-app-diskman/trunk/applications/luci-app-diskman package/openwrt-diskman/luci-app-diskman
wget https://raw.githubusercontent.com/lisaac/luci-app-diskman/master/Parted.Makefile -q -P package/openwrt-diskman/parted
pushd package/openwrt-diskman/parted && mv -f Parted.Makefile Makefile 2>/dev/null && popd

# Replace the default software source
# sed -i 's#openwrt.proxy.ustclug.org#mirrors.bfsu.edu.cn\\/openwrt#' package/lean/default-settings/files/zzz-default-settings

# Default software package replaced with Lienol related software package
# rm -rf feeds/packages/utils/{containerd,libnetwork,runc,tini} 2>/dev/null
# svn co https://github.com/Lienol/openwrt-packages/trunk/utils/{containerd,libnetwork,runc,tini} feeds/packages/utils

# Apply patch
# git apply ../router-config/patches/{0001*,0002*}.patch --directory=feeds/luci

# Modify some code adaptation
# sed -i 's/LUCI_DEPENDS.*/LUCI_DEPENDS:=\@\(arm\|\|aarch64\)/g' package/lean/luci-app-cpufreq/Makefile

# Add luci-theme
# svn co https://github.com/Lienol/openwrt-package/trunk/lienol/luci-theme-bootstrap-mod package/luci-theme-bootstrap-mod

# Convert translation files zh-cn to zh_Hans
convert_translation=${GITHUB_WORKSPACE}/router-config/openwrt-master/convert_translation.sh
chmod +x ${convert_translation} && ${convert_translation}

