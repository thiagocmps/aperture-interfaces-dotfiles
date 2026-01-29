#!/bin/bash
ARG=${1:-}
# Detect Wi-Fi interface dynamically
wifi_interface=$(nmcli dev | grep wifi | head -1 | awk '{print $1}')
if [ -z "$wifi_interface" ]; then
    notify-send "No Wi-Fi interface found"
    exit 1
fi

# Get current connection status
current_ssid=$(nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2)
if [ -n "$current_ssid" ]; then
    options="Disconnect from $current_ssid\nScan for networks"
else
    options="Scan for networks"
fi

chosen=$(echo -e "$options" | wofi -dmenu --prompt "Network →" --cache-file /dev/null)

[ -z "$chosen" ] && exit

if [[ "$chosen" == "Disconnect from "* ]]; then
    nmcli dev disconnect "$wifi_interface"
    notify-send "Disconnected from $current_ssid"
    exit
elif [[ "$chosen" == "Scan for networks" ]]; then
    # List available Wi-Fi networks
    wifi_list=$(nmcli -t -f SSID,SECURITY,SIGNAL dev wifi | awk -F: '
    {
      ssid=$1; sec=$2; signal=$3;
      if (ssid == "") ssid="[Hidden Network]";
      lock=(sec=="--") ? " " : "🔒";
      printf "%s (%s%%) %s\n", ssid, signal, lock
    }')

    chosen_network=$(echo "$wifi_list" | wofi -dmenu --prompt "Wi-Fi →" --cache-file /dev/null)

    [ -z "$chosen_network" ] && exit

    ssid=$(echo "$chosen_network" | sed 's/ (.*//; s/🔒//g' | sed 's/ *$//')

    # Check if a saved connection exists for this SSID
    saved=$(nmcli -t -f NAME,UUID connection show | grep "^$ssid:")

    if [ -n "$saved" ]; then
        # Connect automatically without asking password
        nmcli connection up "$ssid"
        notify-send "Connected to $ssid"
        exit
    fi

    # If no saved connection exists, then ask for password
    if echo "$chosen_network" | grep -q "🔒"; then
        password=$(wofi -dmenu --password --prompt "Password →")
        [ -z "$password" ] && exit
        nmcli dev wifi connect "$ssid" password "$password"
        notify-send "Connected to $ssid"
    else
        nmcli dev wifi connect "$ssid"
        notify-send "Connected to $ssid"
    fi
fi
