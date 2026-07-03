#!/bin/bash
# 修改默认后台IP，按需自行修改
# sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# Docker开机自启
sed -i '/exit 0/i dockerd start' package/base-files/files/etc/rc.local

# 清理编译冗余包，缩小固件体积
rm -rf bin/targets/*/*/*.rootfs.tar.gz
