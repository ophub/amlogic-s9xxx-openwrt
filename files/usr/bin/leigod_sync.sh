#!/bin/bash
# 路径: /usr/bin/leigod_sync.sh
# 权限: chmod +x /usr/bin/leigod_sync.sh

# ================= 配置区域 =================
LIST_CONSOLE="10.0.0.160 10.0.0.197"  # 游戏机 IP 列表
LIST_PC="10.0.0.4"       # PC IP 列表

# 检测周期 (秒)
CHECK_INTERVAL=5
# ===========================================

# 常量定义
IPSET_CONSOLE="target_Game"
TUN_CONSOLE="tun_Game"
MARK_CONSOLE="0x103"

IPSET_PC="target_PC"
TUN_PC="tun_PC"
MARK_PC="0x102"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# --- 核心函数：检测雷神真实运行状态 ---
# 返回值: "tun" | "tproxy" | "off"
check_leishen_status() {
    local tun_iface=$1
    local ipset_name=$2
    
    # 1. 检测 TUN 模式
    # 如果网卡存在，且有IP地址，判定为 TUN 模式
    if ip addr show $tun_iface >/dev/null 2>&1; then
        echo "tun"
        return
    fi

    # 2. 检测 TProxy 模式 (基于你提供的日志特征)
    # 逻辑：读取 GAMEACC 链的所有规则，查找同时包含 "match-set ipset名" 和 "TPROXY" 的行
    # 只有当规则里真的有 TPROXY 动作时，才算开启
    if iptables -t mangle -S GAMEACC 2>/dev/null | grep -q -E "match-set $ipset_name src.*TPROXY"; then
        echo "tproxy"
        return
    fi

    # 既没网卡，也没 TPROXY 规则，判定为关闭
    echo "off"
}

# --- 动作：应用规则 ---
apply_rules() {
    local mode=$1
    local tun=$2
    local ipset_name=$3
    local mark=$4
    local ips=$5

    # 1. 确保 IP 被加入 IPSET (雷神开启时，我们负责把 N1 后面设备的 IP 加进去)
    # 因为状态检测通过，说明 IPSET 肯定已经存在
    for ip in $ips; do
        ipset test $ipset_name $ip >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            ipset add $ipset_name $ip >/dev/null 2>&1
        fi
    done

    # 2. 注入 iptables 规则 (针对 N1 的 eth0)
    if [ "$mode" == "tun" ]; then
        # === TUN 模式 ===
        # Mangle 表打标
        iptables -t mangle -C GAMEACC -i eth0 -m set --match-set $ipset_name src -j MARK --set-mark $mark 2>/dev/null
        if [ $? -ne 0 ]; then
            log "[TUN] 雷神已启动，添加 eth0 -> $tun 标记规则"
            iptables -t mangle -A GAMEACC -i eth0 -m set --match-set $ipset_name src -j MARK --set-mark $mark
        fi
        
        # Forward 表放行
        iptables -C FORWARD -i eth0 -o $tun -j ACCEPT 2>/dev/null || iptables -I FORWARD -i eth0 -o $tun -j ACCEPT
        iptables -C FORWARD -i $tun -o eth0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || iptables -I FORWARD -i $tun -o eth0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

    elif [ "$mode" == "tproxy" ]; then
        # === TProxy 模式 ===
        # 关键点：把 eth0 进来的流量，引入 GAMEACC 链
        # 只要流量进了 GAMEACC，就会匹配到你发出来的那些 TPROXY 规则
        iptables -t mangle -C PREROUTING -i eth0 -m set --match-set $ipset_name src -j GAMEACC 2>/dev/null
        if [ $? -ne 0 ]; then
            log "[TProxy] 雷神已启动，添加 eth0 -> GAMEACC 导流规则"
            iptables -t mangle -I PREROUTING -i eth0 -m set --match-set $ipset_name src -j GAMEACC
        fi
    fi
}

# --- 动作：清理规则 ---
clean_rules() {
    local tun=$1
    local ipset_name=$2
    local mark=$3

    local cleaned=0

    # 1. 清理 TUN 相关
    iptables -t mangle -D GAMEACC -i eth0 -m set --match-set $ipset_name src -j MARK --set-mark $mark 2>/dev/null && cleaned=1
    iptables -D FORWARD -i eth0 -o $tun -j ACCEPT 2>/dev/null && cleaned=1
    iptables -D FORWARD -i $tun -o eth0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null && cleaned=1

    # 2. 清理 TProxy 相关
    # 只要删掉 PREROUTING 里把 eth0 导向 GAMEACC 的那条规则即可
    iptables -t mangle -D PREROUTING -i eth0 -m set --match-set $ipset_name src -j GAMEACC 2>/dev/null && cleaned=1

    if [ $cleaned -eq 1 ]; then
        log "检测到雷神规则消失，已自动清理 eth0 相关规则。"
    fi
}

# --- 任务主逻辑 ---
sync_task() {
    local ips=$1
    local tun=$2
    local ipset=$3
    local mark=$4

    if [ -z "$ips" ]; then return; fi

    # 检测真实状态
    local state=$(check_leishen_status "$tun" "$ipset")

    if [ "$state" == "off" ]; then
        # 如果雷神没运行，执行清理
        clean_rules "$tun" "$ipset" "$mark"
    else
        # 如果雷神在运行，执行应用
        apply_rules "$state" "$tun" "$ipset" "$mark" "$ips"
    fi
}

log "雷神 N1 自动同步脚本 (规则特征检测版) 已启动..."

while true; do
    # 同步 Console
    sync_task "$LIST_CONSOLE" "$TUN_CONSOLE" "$IPSET_CONSOLE" "$MARK_CONSOLE"
    
    # 同步 PC
    sync_task "$LIST_PC"      "$TUN_PC"      "$IPSET_PC"      "$MARK_PC"
    
    sleep $CHECK_INTERVAL
done