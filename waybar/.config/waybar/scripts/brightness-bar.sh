#!/usr/bin/env bash

# lê brilho atual em %
p=$(brightnessctl -m | awk -F, '{gsub("%","",$4); print $4}')

# cria barra estilo ASCII
if [ "$p" -le 10 ]; then bar="▒▒▒▒▒"
elif [ "$p" -le 30 ]; then bar="▓▒▒▒▒"
elif [ "$p" -le 50 ]; then bar="▓▓▒▒▒"
elif [ "$p" -le 70 ]; then bar="▓▓▓▒▒"
elif [ "$p" -le 90 ]; then bar="▓▓▓▓▒"
else bar="▓▓▓▓▓"
fi

# imprime resultado
echo "BRI $p% [$bar]"
