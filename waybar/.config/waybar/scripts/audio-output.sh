#!/bin/bash

# Sempre funciona porque @DEFAULT_AUDIO_SINK@ existe em qualquer setup PipeWire
OUTPUT=$(wpctl inspect @DEFAULT_AUDIO_SINK@)

# Primeiro tenta node.description
NAME=$(echo "$OUTPUT" | grep 'node.description' | sed 's/.*= "//;s/"$//')

# Se não achar, tenta media.name
if [ -z "$NAME" ]; then
    NAME=$(echo "$OUTPUT" | grep 'media.name' | sed 's/.*= "//;s/"$//')
fi

# fallback (não deve acontecer)
if [ -z "$NAME" ]; then
    NAME="Unknown Device"
fi

echo "{\"text\": \"$NAME\", \"class\": \"ok\"}"
