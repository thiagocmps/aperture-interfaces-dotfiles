#!/bin/bash

powered=$(bluetoothctl show | grep "Powered" | awk '{print $2}')

if [ "$powered" = "yes" ]; then
    echo "{\"text\": \"◉\", \"class\": \"on\"}"
    else
    echo "{\"text\": \"○\", \"class\": \"off\"}"
    fi