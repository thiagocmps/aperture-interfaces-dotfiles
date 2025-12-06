#!/usr/bin/env bash
set -euo pipefail

THEME="$HOME/.config/waybar/theme.css"

# lista de cores para ciclar (podes adicionar/remover)
COLORS=(
  "#df3079"  # cor 1
  "#89b4fa"  # cor 2
  "#f38ba8"  # cor 3
  "#a6e3a1"  # cor 4
)

# lê valor atual da --primary
CURRENT=$(grep -Po '(?<=--primary:\s*)#[0-9A-Fa-f]{6}' "$THEME" | head -n1 || echo "")

if [ -z "$CURRENT" ]; then
  # se não existir, insere :root com a variável
  sed -i "1i:root { --primary: ${COLORS[0]}; }" "$THEME"
  pkill -SIGUSR1 waybar || true
  exit 0
fi

# encontra índice atual e escolhe próximo
NEXT="$CURRENT"
for i in "${!COLORS[@]}"; do
  if [ "${COLORS[$i],,}" = "${CURRENT,,}" ]; then
    # calcula próximo índice
    next_index=$(( (i + 1) % ${#COLORS[@]} ))
    NEXT="${COLORS[$next_index]}"
    break
  fi
done

# se não encontrou corrente na lista, escolhe primeiro
if [ "$NEXT" = "$CURRENT" ]; then
  NEXT="${COLORS[0]}"
fi

# substitui apenas a linha da --primary no bloco :root
# mais robusto: substitui a primeira ocorrência de --primary: #xxxxxx
sed -i -E "0,/(--primary:[[:space:]]*)#[0-9A-Fa-f]{6}/s//\1$NEXT/" "$THEME"

# recarrega waybar
pkill -SIGUSR1 waybar || true
