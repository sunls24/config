#!/bin/ash

set -e

config_file="ddns.conf"
ip4_file="ip4.txt"
ip6_file="ip6.txt"
log_file="ddns.log"
id_file="cloudflare.ids"
max_log_lines=100
keep_log_lines=10
fetch_timeout=20

cd "$(dirname "$0")" || exit

rotate_log() {
	local lines tmp_log

	if [ -f "$log_file" ]; then
		lines=$(wc -l <"$log_file")
		if [ "$lines" -gt "$max_log_lines" ] 2>/dev/null; then
			tmp_log="$log_file.$$"
			if ! tail -n "$keep_log_lines" "$log_file" >"$tmp_log" 2>/dev/null; then
				: >"$tmp_log"
			fi
			mv "$tmp_log" "$log_file"
		fi
	fi
}

log() {
	if [ "$1" ]; then
		printf '[%s] - %s\n' "$(date +'%Y/%m/%d %H:%M:%S')" "$1" >>"$log_file"
	fi
}

if [ ! -f "$config_file" ]; then
	log "$config_file is required."
	exit 1
fi

# shellcheck disable=SC1090
. "./$config_file"

need_cmd() {
	command -v "$1" >/dev/null 2>&1 || {
		log "$1 is required."
		exit 1
	}
}

cf_api_get() {
	uclient-fetch -4 -q -T "$fetch_timeout" -O - \
		--header="Authorization: Bearer $api_token" \
		"https://api.cloudflare.com/client/v4/zones$1" 2>>"$log_file" || true
}

cf_zones_id() {
	cf_api_get "$1" | jsonfilter -e '@.result[0].id' 2>/dev/null || true
}

fetch_ip() {
	local version=$1

	uclient-fetch -"$version" -q -T "$fetch_timeout" -O - "http://ipv$version.icanhazip.com" 2>/dev/null
}

trim_ip() {
	printf '%s' "$1" | tr -d ' \t\r\n'
}

update_ip() {
	local ip=$1
	local ip_file=$2
	local record_type=$3
	local record_id=$4
	local old_ip data update success

	if [ -z "$record_id" ]; then
		log "$record_type record id is empty. Skipping."
		return
	fi

	if [ -f "$ip_file" ]; then
		old_ip=$(cat "$ip_file")
		if [ "$ip" = "$old_ip" ]; then
			log "$record_type IP has not changed."
			return
		fi
	fi

	data="{\"type\":\"$record_type\",\"name\":\"$record_name\",\"content\":\"$ip\"}"
	if ! update=$(uclient-fetch -4 -q -T "$fetch_timeout" -O - \
		--method=PUT \
		--header="Authorization: Bearer $api_token" \
		--header="Content-Type: application/json" \
		--body-data="$data" \
		"https://api.cloudflare.com/client/v4/zones/$zone_id/dns_records/$record_id" 2>>"$log_file"); then
		return 1
	fi

	success=$(printf '%s' "$update" | jsonfilter -e '@.success' 2>/dev/null || true)
	if [ "$success" != "true" ]; then
		return 1
	else
		printf '%s\n' "$ip" >"$ip_file"
		log "$record_type IP changed to: $ip"
	fi
}

update_record() {
	local version=$1
	local ip_file=$2
	local record_type=$3
	local record_id=$4
	local ip

	if ! ip=$(fetch_ip "$version"); then
		log "Failed to fetch IPv$version. Skipping $record_type update."
		return 1
	fi

	ip=$(trim_ip "$ip")
	if [ -z "$ip" ]; then
		log "Fetched IPv$version is empty. Skipping $record_type update."
		return 1
	fi

	update_ip "$ip" "$ip_file" "$record_type" "$record_id"
}

rotate_log
need_cmd uclient-fetch
need_cmd jsonfilter

trigger="manual"
if [ -n "$ACTION" ] || [ -n "$INTERFACE" ]; then
	trigger="${ACTION:-unknown}/${INTERFACE:-unknown}"
fi

log "Start. trigger=$trigger"

if [ -f "$id_file" ] && [ "$(wc -l <"$id_file")" -ge 3 ]; then
	{
		read -r zone_id
		read -r record_v4
		read -r record_v6
	} <"$id_file"
else
	zone_id=$(cf_zones_id "?name=$zone_name")
	if [ -n "$zone_id" ]; then
		record_v4=$(cf_zones_id "/$zone_id/dns_records?name=$record_name&type=A")
		record_v6=$(cf_zones_id "/$zone_id/dns_records?name=$record_name&type=AAAA")
	fi
	if [ -n "$zone_id" ] && [ -n "$record_v4" ]; then
		{
			printf '%s\n' "$zone_id"
			printf '%s\n' "$record_v4"
			printf '%s\n' "$record_v6"
		} >"$id_file"
	fi
fi

if [ -z "$zone_id" ] || [ -z "$record_v4" ]; then
	log "Zone id or A record id is empty."
	exit 1
fi

status=0
update_record 4 "$ip4_file" "A" "$record_v4" || status=1
update_record 6 "$ip6_file" "AAAA" "$record_v6" || status=1
log "Done. status=$status"
exit "$status"
