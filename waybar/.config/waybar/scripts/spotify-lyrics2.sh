#!/usr/bin/env bash

CACHE_DIR="$HOME/.cache/lyrics"
mkdir -p "$CACHE_DIR"

# Info da música
TITLE=$(playerctl metadata xesam:title 2>/dev/null)
ARTIST=$(playerctl metadata xesam:artist 2>/dev/null)

# Se nada está tocando
if [[ -z "$TITLE" ]]; then
    echo ""
    exit 0
fi

# Arquivo cache
FILE="$CACHE_DIR/${ARTIST} - ${TITLE}.lrc"

# Baixar LRC se não existir
if [[ ! -f "$FILE" ]]; then
    curl -s \
      "https://lrclib.net/api/get?artist_name=$(printf '%s' "$ARTIST" | sed 's/ /%20/g')&track_name=$(printf '%s' "$TITLE" | sed 's/ /%20/g')" \
    | jq -r '.syncedLyrics // empty' > "$FILE"
fi

# Se mesmo assim não existir
if [[ ! -s "$FILE" ]]; then
    echo ""
    exit 0
fi

# Posição atual da música em float
POS=$(playerctl position 2>/dev/null)

# Extrai minutos e segundos **sem bc**
MIN=$(printf "%02d" "$(echo "$POS" | cut -d. -f1 | awk '{print int($1/60)}')")
SEC_FLOAT=$(echo "$POS" | awk '{printf "%.2f", $1%60}')

# Forma timestamp no formato LRC MM:SS.xx
STAMP="$MIN:$SEC_FLOAT"

# Procura linha anterior ao timestamp
LINE=$(grep -B1 "\[$STAMP" "$FILE" | head -n 1 | sed 's/\[[0-9:.]*\]//')

echo "$LINE"
