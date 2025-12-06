#!/usr/bin/env bash

# Palavras que queremos detectar no título
KEYWORDS=("YouTube" "Netflix" "Disney" "Instagram" "Crunchyroll")

# Classes das janelas a monitorar
APP_CLASS="firefox"

currently_streaming=false

while true; do
    # Pegar janela ativa
    active_class=$(hyprctl activewindow -j | jq -r '.class')
    active_title=$(hyprctl activewindow -j | jq -r '.title')

    if [[ "$active_class" == "$APP_CLASS" ]]; then
        match=false
        for word in "${KEYWORDS[@]}"; do
            if [[ "$active_title" == *"$word"* ]]; then
                match=true
                break
            fi
        done

        if [[ "$match" == true && "$currently_streaming" == false ]]; then
            # DESATIVA blur/transparência
            hyprctl keyword decoration:blur:enabled false
            hyprctl keyword decoration:active_opacity 1.0
            hyprctl keyword decoration:inactive_opacity 1.0
            currently_streaming=true
        fi

        if [[ "$match" == false && "$currently_streaming" == true ]]; then
            # REATIVA blur/transparência
            hyprctl keyword decoration:blur:enabled true
            hyprctl keyword decoration:active_opacity 0.9
            hyprctl keyword decoration:inactive_opacity 0.8
            currently_streaming=false
        fi
    else
        # Saiu do Firefox, volta o blur se estava desativado
        if [[ "$currently_streaming" == true ]]; then
            hyprctl keyword decoration:blur:enabled true
            hyprctl keyword decoration:active_opacity 0.9
            hyprctl keyword decoration:inactive_opacity 0.8
            currently_streaming=false
        fi
    fi

    sleep 0.5
done
