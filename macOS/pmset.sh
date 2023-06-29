#!/usr/bin/env bash

# All
sudo pmset -a proximitywake 0 # only macmini?
sudo pmset -a tcpkeepalive 0
sudo pmset -a powernap 0
sudo pmset -a womp 0

# AC Power
sudo pmset -c sleep 0
sudo pmset -c displaysleep 10
sudo pmset -c hibernatemode 0
sudo pmset -c autopoweroff 0
sudo pmset -c standby 0

# Battery Power
sudo pmset -b displaysleep 5
