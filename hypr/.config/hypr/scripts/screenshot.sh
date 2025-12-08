#!/bin/bash
# Cria pasta se não existir
mkdir -p ~/Imagens/screenshots
# Nome do arquivo com timestamp
file=~/Imagens/screenshots/screenshot_$(date +%Y%m%d_%H%M%S).png
# Captura de área com slurp
grim -g "$(slurp)" "$file"
# Notificação
notify-send "Screenshot salva" "$file"
