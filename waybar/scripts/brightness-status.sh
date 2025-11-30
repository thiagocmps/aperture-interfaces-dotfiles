#!/bin/bash
# retorna {"percent":NN}
p=$(brightnessctl -m | grep -o "[0-9][0-9]*%" | head -n1 | tr -d '%')
echo "{\"percent\": $p}"
