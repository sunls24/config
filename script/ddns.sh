#!/bin/ash

api_token=""
zone_name="x.xx"
record_name="x.x.xx"

base_dir="/data/ddns"
cd ${base_dir} || exit

# MAYBE CHANGE THESE
ip=$(curl -s http://ipv4.icanhazip.com)
ip_file="ip.txt"
id_file="cloudflare.ids"
log_file="ddns.log"

# LOGGER
log() {
    if [ "$1" ]; then
        echo -e "[$(date +'%Y/%m/%d %H:%M:%S')] - $1" >> $log_file
    fi
}

# SCRIPT START
log "Check Initiated"

if [ -f $ip_file ]; then
    old_ip=$(cat $ip_file)
    if [ "$ip" = "$old_ip" ]; then
        log "IP has not changed."
        exit 0
    fi
fi

if [ -f $id_file ] && [ "$(wc -l $id_file | cut -d " " -f 1)" = 2 ]; then
    zone_id=$(head -1 $id_file)
    record_id=$(tail -1 $id_file)
else
    zone_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone_name" -H "Authorization: Bearer $api_token" -H "Content-Type: application/json" | sed -E "s/.+\"result\":\[\{\"id\":\"([a-f0-9]+)\".+/\1/g")
    record_id=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records?name=$record_name" -H "Authorization: Bearer $api_token" -H "Content-Type: application/json" | sed -E "s/.+\{\"id\":\"([a-f0-9]+)\".+\"type\":\"A\".+/\1/g")
    echo "$zone_id" > $id_file
    echo "$record_id" >> $id_file
fi

update=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id" -H "Authorization: Bearer $api_token" -H "Content-Type: application/json" --data "{\"id\":\"$zone_id\",\"type\":\"A\",\"name\":\"$record_name\",\"content\":\"$ip\"}")

success=$(echo "$update" | sed -E "s/.+\"success\":[ ]*([a-z]+).+/\1/g")
if [ "$success" = "false" ]; then
    log "API UPDATE FAILED. DUMPING RESULTS:\n$update"
    exit 1
else
    echo "$ip" > $ip_file
    log "IP changed to: $ip"
fi
