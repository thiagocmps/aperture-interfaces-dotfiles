#!/bin/bash

# detect WM / launcher
LAUNCHER="wofi -dmenu -p Bluetooth"

# check bluetooth state
powered=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [[ "$powered" == "yes" ]]; then
    options="Desligar\nListar dispositivos"
else
    options="Ligar"
fi

choice=$(echo -e "$options" | $LAUNCHER)

case "$choice" in
  "Ligar")
    bluetoothctl power on
    ;;
  "Desligar")
    bluetoothctl power off
    ;;
  "Listar dispositivos")
    device=$(bluetoothctl devices | sed 's/Device //' | $LAUNCHER)
    mac=$(echo "$device" | awk '{print $1}')

    [ -z "$mac" ] && exit

    # submenu
    action=$(echo -e "Conectar\nDesconectar\nEmparelhar" | $LAUNCHER)

    case "$action" in
        "Conectar")
            bluetoothctl connect "$mac"
            ;;
        "Desconectar")
            bluetoothctl disconnect "$mac"
            ;;
        "Emparelhar")
            bluetoothctl pair "$mac"
            ;;
    esac
    ;;
esac
