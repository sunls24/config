#!/bin/ash

set -e

api_token="!!replace!!"   # cloudflare api token
zone_name="!!replace!!"   # example.com
record_name="!!replace!!" # ddns.example.com

ip4_file="ip4.txt"
ip6_file="ip6.txt"
log_file="ddns.log"
id_file="cloudflare.ids"

cd "$(dirname "$0")" || exit

log() {
    if [ "$1" ]; then
        echo -e "[$(date +'%Y/%m/%d %H:%M:%S')] - $1" >>"$log_file"
    fi
}

cf_zones_id() {
    curl -s -X GET "https://api.cloudflare.com/client/v4/zones$1" -H "Authorization: Bearer $api_token" | sed -E "s/.+\"result\":\[\{\"id\":\"([a-f0-9]+)\".+/\1/g"
}

update_ip() {
    local ip=$1
    local ip_file=$2
    local record_type=$3
    local record_id=$4

    if [ -f "$ip_file" ]; then
        old_ip=$(cat "$ip_file")
        if [ "$ip" = "$old_ip" ]; then
            log "$record_type IP has not changed."
            return
        fi
    fi

    update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id" -H "Authorization: Bearer $api_token" -H "Content-Type: application/json" --data "{\"id\":\"$zone_id\",\"type\":\"$record_type\",\"name\":\"$record_name\",\"content\":\"$ip\"}")

    success=$(echo "$update" | sed -E "s/.+\"success\":[ ]*([a-z]+).+/\1/g")
    if [ "$success" = "false" ]; then
        log "API UPDATE FAILED for $record_type. DUMPING RESULTS:\n$update"
    else
        echo "$ip" >"$ip_file"
        log "$record_type IP changed to: $ip"
    fi
}

log "Check Initiated"

if [ -f "$id_file" ] && [ "$(wc -l "$id_file" | awk '{print $1}')" -ge 3 ]; then
    zone_id=$(head -1 "$id_file")
    record_v4=$(head -2 "$id_file" | tail -1)
    record_v6=$(tail -1 "$id_file")
else
    zone_id=$(cf_zones_id "?name=$zone_name")
    record_v4=$(cf_zones_id "/$zone_id/dns_records?name=$record_name&type=A")
    record_v6=$(cf_zones_id "/$zone_id/dns_records?name=$record_name&type=AAAA")
    echo "$zone_id" >"$id_file"
    echo "$record_v4" >>"$id_file"
    echo "$record_v6" >>"$id_file"
fi

ip4=$(curl -s "http://ipv4.icanhazip.com")
update_ip "$ip4" "$ip4_file" "A" "$record_v4"

ip6=$(curl -s "http://ipv6.icanhazip.com")
update_ip "$ip6" "$ip6_file" "AAAA" "$record_v6"
