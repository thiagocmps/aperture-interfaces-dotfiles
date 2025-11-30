#!/bin/bash

# List available Wi-Fi networks
wifi_list=$(nmcli -t -f SSID,SECURITY,SIGNAL dev wifi | awk -F: '
{
  ssid=$1; sec=$2; signal=$3;
  if (ssid == "") ssid="[Hidden Network]";
  lock=(sec=="--") ? " " : "🔒";
  printf "%s (%s%%) %s\n", ssid, signal, lock
}')

chosen=$(echo "$wifi_list" | wofi -dmenu --prompt "Wi-Fi →" --cache-file /dev/null)

[ -z "$chosen" ] && exit

ssid=$(echo "$chosen" | sed 's/ (.*//; s/🔒//g' | sed 's/ *$//')

# Check if a saved connection exists for this SSID
saved=$(nmcli -t -f NAME,UUID connection show | grep "^$ssid:")

if [ -n "$saved" ]; then
    # Connect automatically without asking password
    nmcli connection up "$ssid"
    exit
fi

# If no saved connection exists, then ask for password
if echo "$chosen" | grep -q "🔒"; then
    password=$(wofi -dmenu --password --prompt "Password →")
    [ -z "$password" ] && exit
    nmcli dev wifi connect "$ssid" password "$password"
else
    nmcli dev wifi connect "$ssid"
fi
