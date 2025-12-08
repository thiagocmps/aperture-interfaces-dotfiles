#!/usr/bin/env bash
ARG=${1:-}
echo "PATH: $PATH" >> /tmp/karaoke-debug.log
which playerctl >> /tmp/karaoke-debug.log
which jq >> /tmp/karaoke-debug.log
which curl >> /tmp/karaoke-debug.log


MAX_CHARS=180

# checar dependências
if ! command -v playerctl >/dev/null 2>&1; then
  echo "[playerctl não encontrado][instala: sudo pacman -S playerctl]"
  exit 1
fi
if ! command -v jq >/dev/null 2>&1; then
  echo "[jq não encontrado][instala: sudo pacman -S jq]"
  exit 1
fi

title=$(playerctl metadata xesam:title 2>/dev/null)
artist=$(playerctl metadata xesam:artist 2>/dev/null)

if [[ -z "$title" || -z "$artist" ]]; then
    echo "[MUSIC: OFF]"
    exit 0
fi


# posição em milissegundos (playerctl position dá segundos com casas decimais)
pos_sec=$(playerctl position 2>/dev/null)
# fallback se playerctl falhar
pos_sec=${pos_sec:-0}
position_ms=$(awk -v s="$pos_sec" 'BEGIN{printf "%d", s*1000}')

# preparar query (url-encode básico para espaços)
query_artist=$(printf "%s" "$artist" | sed 's/ /%20/g')
query_title=$(printf "%s" "$title" | sed 's/ /%20/g')

# buscar synced lyrics (usar jq para decodificar corretamente o JSON)
lyrics_raw=$(curl -s "https://lrclib.net/api/get?artist_name=$query_artist&track_name=$query_title" | jq -r '.syncedLyrics // empty')

if [[ -z "$lyrics_raw" ]]; then
    echo "[$artist - $title | (no synced lyrics)]"
    exit 0
fi

# agora lyrics_raw contém linhas já com quebras de linha (jq -r decodifica \n)
parsed=""
while IFS= read -r line; do
    # aceitar mm:ss.decimals (1..3 decimais), espaço opcional depois do ]
    if [[ $line =~ \[([0-9]{1,2}):([0-9]{2})\.([0-9]{1,3})\]\s*(.*) ]]; then
        min=${BASH_REMATCH[1]}
        sec=${BASH_REMATCH[2]}
        dec=${BASH_REMATCH[3]}
        txt=${BASH_REMATCH[4]}

            dec_len=${#dec}
        # converter "08", "09", etc. sem octal
            dec=$((10#$dec))

            if (( dec_len == 1 )); then
                ms=$((dec * 100))
            elif (( dec_len == 2 )); then
                ms=$((dec * 10))
            else
                ms=$((dec))
            fi


        total_ms=$(( (10#$min * 60 + 10#$sec) * 1000 + ms ))

        parsed+="$total_ms|$txt"$'\n'
    fi
done <<< "$lyrics_raw"

# se não houve linhas válidas
if [[ -z "$parsed" ]]; then
    echo "[$artist - $title | (no valid LRC lines)]"
    exit 0
fi

current_line="..."
# percorre e guarda a última linha cujo tempo <= posição atual
while IFS="|" read -r t w; do
    if (( t <= position_ms )); then
        current_line="$w"
    else
        break
    fi
done <<< "$parsed"

output="[$artist - $title | $current_line]"

[[ ${#output} -gt $MAX_CHARS ]] && output="${output:0:MAX_CHARS}..."

echo "$output"
exit 0
