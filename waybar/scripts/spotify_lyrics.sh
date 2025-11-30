#!/usr/bin/env bash
# spotify_lyrics.sh - Waybar custom module for Spotify lyrics (robust)

# CONFIG
MAX_CHARS=160    # limite antes de cortar (o waybar tem também max-length)
SEP=" | "        # separador para substituir newlines nas lyrics

# Dependências verificadas
command -v playerctl >/dev/null 2>&1 || { echo "[SPOTIFY: playerctl missing]"; exit 0; }
command -v curl >/dev/null 2>&1 || { echo "[SPOTIFY: curl missing]"; exit 0; }
command -v jq >/dev/null 2>&1 || { 
  # jq não é obrigatório — vamos tentar extrair sem jq mais abaixo, mas avisamos
  JQ_MISSING=true
}

# Ver status do player (pode precisar de -p spotify se houver múltiplos players)
status=$(playerctl status 2>/dev/null || true)
if [[ -z "$status" || "$status" != "Playing" ]]; then
    echo "[SPOTIFY: OFF]"
    exit 0
fi

# Pegar title e artist — tenta especificar o player "spotify" primeiro, senão sem especificar.
title=$(playerctl metadata xesam:title 2>/dev/null || true)
artist=$(playerctl metadata xesam:artist 2>/dev/null || true)

# Se estiver vazio, tenta com -p spotify (alguns setups precisam disto)
if [[ -z "$title" || -z "$artist" ]]; then
  title=$(playerctl -p spotify metadata xesam:title 2>/dev/null || true)
  artist=$(playerctl -p spotify metadata xesam:artist 2>/dev/null || true)
fi

# Se ainda nada, aborta com fallback
if [[ -z "$title" || -z "$artist" ]]; then
  echo "[♪ unknown track]"
  exit 0
fi

# Trim
title="$(echo -e "${title}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
artist="$(echo -e "${artist}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

# URL-encode (usa python se disponível, senão fallback simples)
urlencode() {
  if command -v python3 >/dev/null 2>&1; then
    python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$1"
  elif command -v python >/dev/null 2>&1; then
    python -c "import urllib,sys; print(urllib.quote(sys.argv[1]))" "$1"
  else
    # fallback: troca espaços por %20 e remove caracteres problemáticos
    echo "$1" | sed -e 's/ /%20/g' -e 's/\"//g' -e 's/\\//%2F/g' -e 's/#/%23/g' -e 's/?/%3F/g'
  fi
}

enc_artist=$(urlencode "$artist")
enc_title=$(urlencode "$title")

# Chamada à API (lyrics.ovh)
api_url="https://api.lyrics.ovh/v1/${enc_artist}/${enc_title}"

# Cabeçalhos (alguns serviços bloqueiam user-agent padrão)
response=$(curl -sL -A "Mozilla/5.0 (Waybar-SpotifyLyrics)" --retry 2 --connect-timeout 5 "$api_url" 2>/dev/null)

# Se jq está disponível, usa-o
if [[ -z "${JQ_MISSING}" ]]; then
  lyrics=$(echo "$response" | jq -r '.lyrics // empty' 2>/dev/null || true)
else
  # tenta extrair sem jq: procura "lyrics" seguido de : " ... "
  lyrics=$(echo "$response" | sed -n 's/.*"lyrics"[[:space:]]*:[[:space:]]*"\(.*\)".*/\1/p' | sed 's/\\n/\n/g' 2>/dev/null || true)
fi

# Substitui quebras de linha por SEP e normaliza espaços
if [[ -n "$lyrics" ]]; then
  # Remove sequences de \r; converte novas linhas para SEP; compacta espaços
  lyrics=$(echo -e "$lyrics" | tr '\r' '\n' | awk -v SEP="$SEP" 'BEGIN{ORS=""; first=1} {gsub(/^[ \t]+|[ \t]+$/,""); if(length($0)>0){ if(!first) printf SEP; printf $0; first=0 }}')
  # corta se necessário
  if [[ ${#lyrics} -gt $MAX_CHARS ]]; then
    lyrics="${lyrics:0:MAX_CHARS}..."
  fi
fi

# Output final — sem caracteres extras, Waybar vai receber só esta string
if [[ -z "$lyrics" ]]; then
  echo "[♪ $artist - $title]"
else
  echo "[♪ $artist - $title | $lyrics]"
fi

exit 0
