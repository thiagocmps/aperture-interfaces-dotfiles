#!/usr/bin/env bash
# Spotify Karaoke Lyrics for Waybar — usa DBus interno do Spotify
# Destaque da linha atual baseado no progresso do player

MAX_CHARS=180
SEP=" | "

# 1) Verifica se player está ativo
status=$(playerctl status 2>/dev/null)
[[ "$status" != "Playing" ]] && { echo "[MUSIC: OFF]"; exit 0; }

title=$(playerctl metadata xesam:title)
artist=$(playerctl metadata xesam:artist)

[[ -z "$title" || -z "$artist" ]] && { echo "[Unknown track]"; exit 0; }

# progresso atual em milissegundos
position_ms=$(playerctl metadata mpris:position 2>/dev/null)
position_ms=$((position_ms / 1000)) # spotify usa us, convertemos p/ ms

############################################
# 2) PEGAR LETRA SINCRONIZADA DO SPOTIFY VIA DBUS
############################################

# Spotify (desktop) expõe lyrics via DBus
lyrics_raw=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify \
  /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get \
  string:"org.mpris.MediaPlayer2.Player" string:"Lyrics" 2>/dev/null | \
  grep -Po '(?<=string ").*?(?=")' | sed 's/\\n/\n/g')

# Se DBus falhar → sem karaoke
if [[ -z "$lyrics_raw" ]]; then
    echo "♪ $artist - $title | (no synced lyrics)"
    exit 0
fi

############################################
# 3) CONVERTER LETRAS SPOTIFY PARA FORMATO:
#    [timestamp] texto
############################################

parsed=""
while read -r line; do
    # exemplo de linha:
    # {"time":12345,"words":"Hello world"}
    t=$(echo "$line" | grep -Po '"time":\d+' | cut -d: -f2)
    w=$(echo "$line" | grep -Po '"words":"[^"]*"' | cut -d\" -f4)

    [[ -n "$t" && -n "$w" ]] && parsed+="$t|$w"$'\n'
done <<< "$lyrics_raw"

############################################
# 4) descobrir qual linha está sendo "cantada"
############################################

current_line=""
next_time=9999999999
while IFS="|" read -r t w; do
    if [[ "$t" -le "$position_ms" ]]; then
        current_line="$w"
    fi
done <<< "$parsed"

[[ -z "$current_line" ]] && current_line="..."

############################################
# 5) formatação final para Waybar
############################################

output="♪ $artist - $title | > $current_line <"

# limitar tamanho
[[ ${#output} -gt $MAX_CHARS ]] && output="${output:0:MAX_CHARS}..."

echo "$output"
exit 0
