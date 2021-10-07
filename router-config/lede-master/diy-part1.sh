#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt for Amlogic S9xxx STB
# Function: Diy script (Before Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/coolsnowwolf/lede / Branch: master
#========================================================================================================================

# Uncomment a feed source
# sed -i 's/#src-git helloworld/src-git helloworld/g' ./feeds.conf.default
# sed -i 's/\"#src-git\"/\"src-git\"/g' feeds.conf.default

# Add a feed source
# sed -i '$a src-git lienol https://github.com/Lienol/openwrt-package' feeds.conf.default
<<<<<<< HEAD
# sed -i '$a src-git liuran001_packages https://github.com/onwingslnz/openwrt-packages' feeds.conf.default

# Add dockerman
sed -i '$a src-git lienol https://github.com/lisaac/luci-app-dockerman/trunk/applications/luci-app-dockerman' feeds.conf.default
sed -i '$a src-git lienol https://github.com/lisaac/luci-lib-docker/trunk/collections/luci-lib-docker' feeds.conf.default
=======
>>>>>>> parent of 94ec725 (20211007 update)

# other
# rm -rf package/lean/{samba4,luci-app-samba4,luci-app-ttyd}

