#!/bin/ash

cd "$(dirname "$0")" || exit

# shellcheck disable=SC1091
. ./script/ipt.sh && ipt_stop && ipt_start
