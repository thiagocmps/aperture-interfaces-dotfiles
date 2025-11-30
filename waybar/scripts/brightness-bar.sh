#!/bin/bash
# Lê brilho atual
p=$(brightnessctl -m | awk -F, '{gsub("%","",$4); print $4}')
# Cria barra estilo bateria
if [ "$p" -le 10 ]; then bar="▒▒▒▒▒"
elif [ "$p" -le 30 ]; then bar="▓▒▒▒▒"
elif [ "$p" -le 50 ]; then bar="▓▓▒▒▒"
elif [ "$p" -le 70 ]; then bar="▓▓▓▒▒"
elif [ "$p" -le 90 ]; then bar="▓▓▓▓▒"
else bar="▓▓▓▓▓"
fi
# Imprime direto
echo "[BRI $p% $bar]"
