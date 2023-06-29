#!/usr/bin/env bash
set -euo pipefail

COMMENT="PORT-HOPPING"

usage() {
    cat <<EOF
Usage:
  $0 start <FROM> <TO> <TARGET_PORT>   # 开启端口跳跃
  $0 stop                              # 关闭端口跳跃
EOF
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

del_rule() {
    local ipt_cmd=$1
    local table=nat
    local chain=PREROUTING

    $ipt_cmd -t $table -S $chain | grep "$COMMENT" | while read -r line; do
        local rule="${line#-A "$chain" }"
        eval "$ipt_cmd -t $table -D $chain $rule" || true
    done
}

cmd=$1

case "$cmd" in
start)
    if [ $# -ne 4 ]; then
        usage
    fi
    FROM=$2
    TO=$3
    TARGET=$4

    echo "添加 UDP 端口跳跃：${FROM}-${TO} -> ${TARGET}"
    # IPv4
    iptables -t nat -A PREROUTING \
        -p udp --dport "${FROM}:${TO}" \
        -m comment --comment "${COMMENT} ${FROM}-${TO} to ${TARGET}" \
        -j DNAT --to-destination ":${TARGET}"

    # IPv6
    ip6tables -t nat -A PREROUTING \
        -p udp --dport "${FROM}:${TO}" \
        -m comment --comment "${COMMENT} ${FROM}-${TO} to ${TARGET}" \
        -j DNAT --to-destination ":${TARGET}"

    echo "done."
    ;;

stop)
    echo "移除所有端口跳跃规则..."

    del_rule iptables
    del_rule ip6tables

    echo "done."
    ;;

*)
    usage
    ;;
esac

