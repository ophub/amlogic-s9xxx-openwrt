#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: Diy script (After Update feeds, Modify the default IP, hostname, theme, add/remove software packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: master
#========================================================================================================================

# ------------------------------- Main source started -------------------------------
#
# Set default IP address
default_ip="192.168.1.1"
ip_regex="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
# Modify default IP if an argument is provided and it matches the IP format
[[ -n "${1}" && "${1}" != "${default_ip}" && "${1}" =~ ${ip_regex} ]] && {
    echo "Modify default IP address to: ${1}"
    sed -i "/lan) ipad=\${ipaddr:-/s/\${ipaddr:-\"[^\"]*\"}/\${ipaddr:-\"${1}\"}/" package/base-files/*/bin/config_generate
}

# Add the default password for the 'root' user（Change the empty password to 'password'）
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# Set etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCEREPO='github.com/immortalwrt/immortalwrt'" >>package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='immortalwrt'" >>package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCEBRANCH='master'" >>package/base-files/files/etc/openwrt_release

# Set ccache
# Remove existing ccache settings
sed -i '/CONFIG_DEVEL/d' .config
sed -i '/CONFIG_CCACHE/d' .config
# Apply new ccache configuration
if [[ "${2}" == "true" ]]; then
    echo "CONFIG_DEVEL=y" >>.config
    echo "CONFIG_CCACHE=y" >>.config
    echo 'CONFIG_CCACHE_DIR="$(TOPDIR)/.ccache"' >>.config
else
    echo '# CONFIG_DEVEL is not set' >>.config
    echo "# CONFIG_CCACHE is not set" >>.config
    echo 'CONFIG_CCACHE_DIR=""' >>.config
fi
#
# ------------------------------- Main source ends -------------------------------

# ------------------------------- Other started -------------------------------
#
# Add luci-app-amlogic
rm -rf package/luci-app-amlogic
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
#
# Apply patch
# git apply ../config/patches/{0001*,0002*}.patch --directory=feeds/luci
#
# ------------------------------- Other ends -------------------------------
curl -sSL https://raw.githubusercontent.com/chenmozhijin/turboacc/luci/add_turboacc.sh -o add_turboacc.sh && bash add_turboacc.sh


git clone https://github.com/zzsj0928/luci-app-pushbot package/luci-app-pushbot


# ---------- MosDNS v5 编译准备 (开始) ----------

# 1. 处理 Golang 环境 (MosDNS v5 需要新版 Go)
# 移除源码自带的旧版 Go
# rm -rf feeds/packages/lang/golang
# 拉取 sbwml 维护的新版 Go (22.x/23.x/24.x 分支通常通用，这里用 24.x)
# git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# 2. 处理 v2ray-geodata (防止与 feeds 中的旧版本冲突)
# 移除 feeds 里的 geodata
rm -rf feeds/packages/net/v2ray-geodata

# 3. 拉取 MosDNS v5 和 对应的 Geodata 到本地 package 目录
# 这样可以确保拥有最高优先级
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata

# ---------- MosDNS v5 编译准备 (结束) ----------


# ---------------------------------------------------------
# 自定义 LAN 口默认配置 (在第一次开机时生效)
# ---------------------------------------------------------

# 1. 创建 uci-defaults 目录 (如果不存在)
mkdir -p files/etc/uci-defaults

# 2. 生成自定义网络配置脚本 '99-custom-network'
# EOF 里的内容即为开机自动执行的命令
cat > files/etc/uci-defaults/99-custom-network << "EOF"
#!/bin/sh

# 设置 LAN 口 IP 地址
uci set network.lan.ipaddr='10.0.0.2'

# 设置子网掩码
uci set network.lan.netmask='255.255.255.0'

# 设置 DNS (多个 DNS 用空格分开)
uci set network.lan.dns='223.5.5.5 1.1.1.1'

# 设置 IPv6 分配长度
uci set network.lan.ip6assign='64'

# --- 关键：物理接口与桥接设置 ---
# 如果你想强制指定 eth0 并不使用桥接 (br-lan)，取消下面几行的注释：
uci set network.lan.device='eth0'
# uci delete network.lan.type   # 删除桥接类型

# 如果你想保持默认的桥接模式 (推荐，兼容性更好)，但确保包含 eth0：
# 新版 OpenWrt (DSA 架构) 通常不需要手动指定 eth0，系统会自动识别
# 但为了保险，可以强制设置：
uci set network.lan.proto='static'

# 提交应用更改
uci commit network

# 重启网络服务 (可选，让设置立即生效，但在启动过程中通常不需要)
# /etc/init.d/network restart

exit 0
EOF

# 3. 赋予脚本可执行权限 (虽然 uci-defaults 不需要 x 权限也能跑，但习惯加上)
chmod +x files/etc/uci-defaults/99-custom-network
