#!/bin/bash
#========================================================================================================================
# https://github.com/ophub/amlogic-s9xxx-openwrt
# Description: Automatically Build OpenWrt
# Function: DIY script (After updating feeds — modify the default IP, hostname, theme, add/remove packages, etc.)
# Source code repository: https://github.com/immortalwrt/immortalwrt / Branch: master
#========================================================================================================================

# ------------------------------- 原作者内容（完整保留） -------------------------------

# Set the default LAN IP address
default_ip="192.168.1.1"
ip_regex="^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
[[ -n "${1}" && "${1}" != "${default_ip}" && "${1}" =~ ${ip_regex} ]] && {
    echo "Modify default IP address to: ${1}"
    sed -i "/lan) ipad=\${ipaddr:-/s/\${ipaddr:-\"[^\"]*\"}/\${ipaddr:-\"${1}\"}/" package/base-files/*/bin/config_generate
}

# Set the default password for the 'root' user (change empty password to 'password')
sed -i 's/root:::0:99999:7:::/root:$1$V4UetPzk$CYXluq4wUazHjmCDBCqXF.::0:99999:7:::/g' package/base-files/files/etc/shadow

# Append source repository information to etc/openwrt_release
sed -i "s|DISTRIB_REVISION='.*'|DISTRIB_REVISION='R$(date +%Y.%m.%d)'|g" package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCEREPO='github.com/immortalwrt/immortalwrt'" >>package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCECODE='immortalwrt'" >>package/base-files/files/etc/openwrt_release
echo "DISTRIB_SOURCEBRANCH='master'" >>package/base-files/files/etc/openwrt_release

# Configure ccache for build acceleration
sed -i '/CONFIG_DEVEL/d' .config
sed -i '/CONFIG_CCACHE/d' .config
if [[ "${2}" == "true" ]]; then
    echo "CONFIG_DEVEL=y" >>.config
    echo "CONFIG_CCACHE=y" >>.config
    echo 'CONFIG_CCACHE_DIR="$(TOPDIR)/.ccache"' >>.config
else
    echo '# CONFIG_DEVEL is not set' >>.config
    echo "# CONFIG_CCACHE is not set" >>.config
    echo 'CONFIG_CCACHE_DIR=""' >>.config
fi

# Add luci-app-amlogic
rm -rf package/luci-app-amlogic
git clone https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic

# ------------------------------- 原作者内容结束 -------------------------------



# ============================================================================================================
# ⭐⭐⭐ 以下是追加内容（你的功能） —— 不修改原作者任何内容，只追加 ⭐⭐⭐
# ============================================================================================================

echo ">>> Apply custom config options for TX8 Max (S912) ..."

# ------------------------------- 网络加速（SFE / FlowOffload / FullCone / BBR） -------------------------------
cat >> .config << "EOF"
CONFIG_PACKAGE_kmod-shortcut-fe=y
CONFIG_PACKAGE_kmod-fast-classifier=y
CONFIG_PACKAGE_kmod-nf-flow=y
CONFIG_PACKAGE_kmod-ipt-offload=y
CONFIG_PACKAGE_fullconenat=y
CONFIG_PACKAGE_kmod-tcp-bbr=y
EOF

# ------------------------------- Docker -------------------------------
cat >> .config << "EOF"
CONFIG_PACKAGE_dockerd=y
CONFIG_PACKAGE_docker=y
CONFIG_PACKAGE_luci-app-dockerman=y
CONFIG_PACKAGE_kmod-veth=y
CONFIG_PACKAGE_kmod-br-netfilter=y
EOF

# ------------------------------- OpenClash -------------------------------
cat >> .config << "EOF"
CONFIG_PACKAGE_luci-app-openclash=y
CONFIG_PACKAGE_coreutils=y
CONFIG_PACKAGE_ipset=y
CONFIG_PACKAGE_kmod-tun=y
EOF

# ------------------------------- Daed（dae） -------------------------------
cat >> .config << "EOF"
CONFIG_PACKAGE_daed=y
CONFIG_PACKAGE_luci-app-daed=y
EOF

# ------------------------------- MosDNS -------------------------------
cat >> .config << "EOF"
CONFIG_PACKAGE_mosdns=y
CONFIG_PACKAGE_luci-app-mosdns=y
EOF

# ------------------------------- 深度内核调优（BBR 等） -------------------------------
cat >> package/base-files/files/etc/sysctl.conf << "EOF"

net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
net.ipv4.tcp_fastopen=3

net.core.netdev_max_backlog=16384
net.core.somaxconn=4096

net.netfilter.nf_conntrack_max=262144

EOF

# ------------------------------- 清理旧 targets -------------------------------
rm -rf bin/targets

echo ">>> DIY-PART2 完成：所有功能已成功追加到 .config"