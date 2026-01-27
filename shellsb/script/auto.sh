#!/bin/ash

# uci delete firewall.shellsb 2>/dev/null
# uci set firewall.shellsb=include
# uci set firewall.shellsb.type='script'
# uci set firewall.shellsb.path='/data/shellsb/auto.sh'
# uci set firewall.shellsb.enabled='1'
# uci commit firewall

auto() {
    while ! ip a | grep -q lan; do
        sleep 2
    done
    [ -f /data/init.sh ] && /data/init.sh &
    cp -f /data/shellsb/script/shellsb.procd /etc/init.d/shellsb
    /etc/init.d/shellsb start
    /etc/init.d/shellsb enable
}

auto >/dev/null 2>&1 &
