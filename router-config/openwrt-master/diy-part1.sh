#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic S9xxx STB
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
#========================================================================================================================

# Add a feed source
# sed -i 's/src-git packages/#src-git packages/g' ./feeds.conf.default
# sed -i '$a src-git packages https://github.com/immortalwrt/packages.git;openwrt-21.02' feeds.conf.default

# other
# rm -rf package/lean/{samba4,luci-app-samba4,luci-app-ttyd}

