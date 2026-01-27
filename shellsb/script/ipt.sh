# shellcheck disable=SC2148
IPV6=1
REDIR_PORT=7890
DNS_REDIR_PORT=1053

FWMARK=0x64
TABLE=100
TUN=utun

ipt() {
    v=$1
    shift
    case $v in
    4) iptables -w "$@" ;;
    6) ip6tables -w "$@" ;;
    esac
}

ipt_route() {
    table=$1
    chain=$2
    proto=$3
    shift 3

    for v in 4 6; do
        [ $v = 6 ] && [ $IPV6 != 1 ] && continue

        # create chain
        ipt "$v" -t "$table" -N "$chain"

        # skip host ip and reserved ip
        ipt "$v" -t "$table" -A "$chain" -m set --match-set lo_ip"$v" dst -j RETURN

        # skip cn_ip
        ipt "$v" -t "$table" -A "$chain" -m set --match-set cn_ip"$v" dst -j RETURN

        # proxy
        ipt "$v" -t "$table" -A "$chain" -p "$proto" "$@"

        # jump
        ipt "$v" -t "$table" -I PREROUTING -p "$proto" -m set --match-set proxy_mac src -j "$chain"
    done
}

del_route() {
    table=$1
    chain=$2
    proto=$3
    for v in 4 6; do
        ipt "$v" -t "$table" -D PREROUTING -p "$proto" -m set --match-set proxy_mac src -j "$chain" 2>/dev/null
        ipt "$v" -t "$table" -F "$chain" 2>/dev/null
        ipt "$v" -t "$table" -X "$chain" 2>/dev/null
    done
}

ipt_dns() {
    for v in 4 6; do
        [ $v = 6 ] && [ $IPV6 != 1 ] && continue
        ipt "$v" -t nat -I PREROUTING -p tcp --dport 53 -m set --match-set proxy_mac src -j REDIRECT --to-ports $DNS_REDIR_PORT
        ipt "$v" -t nat -I PREROUTING -p udp --dport 53 -m set --match-set proxy_mac src -j REDIRECT --to-ports $DNS_REDIR_PORT
    done
}

del_dns() {
    for v in 4 6; do
        ipt "$v" -t nat -D PREROUTING -p tcp --dport 53 -m set --match-set proxy_mac src -j REDIRECT --to-ports $DNS_REDIR_PORT 2>/dev/null
        ipt "$v" -t nat -D PREROUTING -p udp --dport 53 -m set --match-set proxy_mac src -j REDIRECT --to-ports $DNS_REDIR_PORT 2>/dev/null
    done
}

start_ip_route() {
    ip route add default dev $TUN table $TABLE
    ip rule add fwmark $FWMARK table $TABLE
    iptables -I FORWARD -o $TUN -j ACCEPT
    if [ $IPV6 = 1 ]; then
        ip -6 route add default dev $TUN table $((TABLE + 1))
        ip -6 rule add fwmark $FWMARK table $((TABLE + 1))
        ip6tables -I FORWARD -o $TUN -j ACCEPT
    fi
}

stop_ip_route() {
    iptables -D FORWARD -o $TUN -j ACCEPT 2>/dev/null
    ip rule del fwmark $FWMARK table $TABLE 2>/dev/null
    ip route flush table $TABLE 2>/dev/null

    ip6tables -D FORWARD -o $TUN -j ACCEPT 2>/dev/null
    ip -6 rule del fwmark $FWMARK table $((TABLE + 1)) 2>/dev/null
    ip -6 route flush table $((TABLE + 1)) 2>/dev/null
}

create_ipset() {
    curl -s "https://www.sunls.de/x/cn_ip4.txt" >cn_ip4.txt
    echo "create cn_ip4 hash:net family inet" >cn_ip4.ipset
    awk '!/^[[:space:]]*(#|$)/ { print "add cn_ip4 " $0 }' cn_ip4.txt >>cn_ip4.ipset
    ipset -! restore <cn_ip4.ipset
    if [ $IPV6 = 1 ]; then
        curl -s "https://www.sunls.de/x/cn_ip6.txt" >cn_ip6.txt
        echo "create cn_ip6 hash:net family inet6" >cn_ip6.ipset
        awk '!/^[[:space:]]*(#|$)/ { print "add cn_ip6 " $0 }' cn_ip6.txt >>cn_ip6.ipset
        ipset -! restore <cn_ip6.ipset
    fi
    rm -rf cn_ip*

    HOST_IPV4=$(ip route show scope link | awk '/br-lan|lan[0-9]?/ {print $1}')
    HOST_IPV6=$(ip -6 route show default | awk '{print $3}' | tr '\n' ' ' | sed 's/ $//')
    RESERVE_IPV4='0.0.0.0/8 10.0.0.0/8 127.0.0.0/8 100.64.0.0/10 169.254.0.0/16 172.16.0.0/12 192.168.0.0/16 224.0.0.0/4 240.0.0.0/4'
    RESERVE_IPV6='::/128 ::1/128 ::ffff:0:0/96 64:ff9b::/96 100::/64 2001::/32 2001:20::/28 2001:db8::/32 2002::/16 fe80::/10 ff00::/8 fd00::/8'
    ipset -! create lo_ip4 hash:net family inet
    for ip in $HOST_IPV4 $RESERVE_IPV4; do
        ipset -! add lo_ip4 "$ip"
    done
    if [ $IPV6 = 1 ]; then
        ipset -! create lo_ip6 hash:net family inet6
        for ip in $HOST_IPV6 $RESERVE_IPV6; do
            ipset -! add lo_ip6 "$ip"
        done
    fi

    MAC=$(grep -oE '^([0-9A-Fa-f]{2}:){5}[0-9A-Fa-f]{2}' ./mac 2>/dev/null)
    ipset -! create proxy_mac hash:mac
    for mac in $MAC; do
        ipset -! add proxy_mac "$mac"
    done
}

remove_ipset() {
    ipset destroy cn_ip4 2>/dev/null
    ipset destroy cn_ip6 2>/dev/null
    ipset destroy lo_ip4 2>/dev/null
    ipset destroy lo_ip6 2>/dev/null
    ipset destroy proxy_mac 2>/dev/null
}

waitTun() {
    count=0
    while ! ip route list | grep -q $TUN; do
        if [ $count -ge 10 ]; then
            echo "not found $TUN"
            exit 1
        fi
        sleep 2
        count=$((count + 1))
    done
}

ipt_start() {
    waitTun
    create_ipset
    # redir tcp
    ipt_route nat sb_redir tcp -j REDIRECT --to-ports $REDIR_PORT

    # tun udp
    start_ip_route
    ipt_route mangle sb_tun udp -j MARK --set-mark $FWMARK

    # dns
    ipt_dns

    echo 'start done.'
}

ipt_stop() {
    del_dns
    del_route nat sb_redir tcp
    del_route mangle sb_tun udp
    stop_ip_route
    remove_ipset

    echo 'stop done.'
}
