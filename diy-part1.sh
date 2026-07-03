#!/bin/bash
# 清除源码自带冲突插件，避免和small-package重复
rm -rf package/smartdns package/luci-app-smartdns
rm -rf package/adguardhome package/luci-app-adguardhome
rm -rf package/vlmcsd package/luci-app-vlmcsd

# 原生添加kenzok8插件源，无国内加速（Actions海外环境原生访问）
cat >> feeds.conf.default <<EOF
src-git kenzo https://github.com/kenzok8/openwrt-packages
src-git small https://github.com/kenzok8/small-package
EOF

# 更新软件源
./scripts/feeds update -a

# 仅安装.config里勾选=y的插件，不批量全量安装
FEED_LIST=$(grep "CONFIG_PACKAGE_" .config | grep "=y" | awk -F "_" '{print $3}')
./scripts/feeds install ${FEED_LIST}
