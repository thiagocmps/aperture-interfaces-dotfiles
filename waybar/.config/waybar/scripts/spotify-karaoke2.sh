#!/usr/bin/env bash

MAX_CHARS=180

# Dependências
for dep in playerctl jq curl awk; do
  if ! command -v "$dep" >/dev/null 2>&1; then
    echo "[ erro: '$dep' não encontrado ]"
    exit 1
  fi
done

title=$(playerctl metadata xesam:title 2>/dev/null)
artist=$(playerctl metadata xesam:artist 2>/dev/null)

if [[ -z "$title" || -z "$artist" ]]; then
    echo "[ MUSIC: OFF ]"
    exit 0
fi

# Arquivos de cache
TRACK_ID="${artist} - ${title}"
CURRENT="/tmp/karaoke_current_track.txt"
CACHE_LYRICS="/tmp/karaoke_cache_lrc.txt"
CACHE_PARSED="/tmp/karaoke_cache_parsed.txt"

# Se a música mudou → baixa novamente
if [[ ! -f "$CURRENT" || "$(cat "$CURRENT")" != "$TRACK_ID" ]]; then
    echo "$TRACK_ID" > "$CURRENT"

    # URL encode básico
    query_artist=$(printf "%s" "$artist" | sed 's/ /%20/g')
    query_title=$(printf "%s" "$title" | sed 's/ /%20/g')

    lyrics_raw=$(curl -s "https://lrclib.net/api/get?artist_name=$query_artist&track_name=$query_title" | jq -r '.syncedLyrics // empty')
    echo "$lyrics_raw" > "$CACHE_LYRICS"

    # Parsear uma vez só
    awk '
    /^\[[0-9]/ {
        match($0, /\[([0-9]{1,2}):([0-9]{2})\.([0-9]{1,3})\](.*)/, m)
        if (m[1] != "") {
            min = m[1]
            sec = m[2]
            dec = m[3]
            txt = m[4]

            # força decimal como decimal (sem octal)
            dec_val = dec + 0

            # normalizar ms pela quantidade de dígitos
            if (length(dec) == 1)      ms = dec_val * 100
            else if (length(dec) == 2) ms = dec_val * 10
            else                       ms = dec_val

            total = (min * 60 + sec) * 1000 + ms
            printf("%d|%s\n", total, txt)
        }
    }
    ' "$CACHE_LYRICS" > "$CACHE_PARSED"
fi

# Se não há LRC
if [[ ! -s "$CACHE_PARSED" ]]; then
    echo "[ $artist - $title | (no synced lyrics) ]"
    exit 0
fi

# Posição atual
pos_sec=$(playerctl position 2>/dev/null)
pos_sec=${pos_sec:-0}
position_ms=$(awk -v s="$pos_sec" 'BEGIN{printf "%d", s*1000}')

# Achar a linha correspondente
current_line="..."
while IFS="|" read -r t w; do
    if (( t <= position_ms )); then
        current_line="$w"
    else
        break
    fi
done < "$CACHE_PARSED"

output="[$artist - $title | $current_line]"

# Limitar tamanho
[[ ${#output} -gt $MAX_CHARS ]] && output="${output:0:MAX_CHARS}..."

echo "$output"
exit 0
