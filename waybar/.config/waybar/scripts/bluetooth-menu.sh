#!/bin/bash

LAUNCHER="wofi --dmenu --prompt"

# Função para notificar (só se o serviço existir)
notify() {
    if command -v notify-send >/dev/null 2>&1 && pgrep -x mako >/dev/null 2>&1 || pgrep -x dunst >/dev/null 2>&1; then
        notify-send "Bluetooth" "$1"
    fi
}

# Verifica se bluetooth está ligado
powered=$(bluetoothctl show | awk '/Powered/ {print $2}')

if [[ "$powered" == "yes" ]]; then
    options="Desligar\nDispositivos emparelhados\nEmparelhar novo dispositivo"
else
    options="Ligar"
fi

choice=$(echo -e "$options" | $LAUNCHER "Bluetooth")
[ -z "$choice" ] && exit

case "$choice" in
    "Ligar")
        bluetoothctl power on >/dev/null
        notify "Bluetooth ligado"
        ;;
        
    "Desligar")
        bluetoothctl power off >/dev/null
        notify "Bluetooth desligado"
        ;;
        
    "Dispositivos emparelhados")
        paired=$(bluetoothctl devices Paired | sed 's/^Device //')
        
        if [ -z "$paired" ]; then
            echo -e "Nenhum dispositivo emparelhado" | $LAUNCHER "Aviso"
            exit
        fi
        
        device=$(echo "$paired" | $LAUNCHER "Selecione dispositivo")
        [ -z "$device" ] && exit
        
        mac=$(echo "$device" | awk '{print $1}')
        [ -z "$mac" ] && exit
        
        action=$(echo -e "Conectar\nDesconectar\nRemover" | $LAUNCHER "Ação")
        [ -z "$action" ] && exit
        
        case "$action" in
            "Conectar") 
                bluetoothctl connect "$mac" >/dev/null 2>&1
                notify "Conectando..."
                ;;
            "Desconectar") 
                bluetoothctl disconnect "$mac" >/dev/null 2>&1
                notify "Desconectado"
                ;;
            "Remover") 
                bluetoothctl remove "$mac" >/dev/null 2>&1
                notify "Dispositivo removido"
                ;;
        esac
        ;;
        
    "Emparelhar novo dispositivo")
        # Garante que bluetooth está ligado
        bluetoothctl power on >/dev/null 2>&1
        
        # Registra dispositivos conhecidos ANTES do scan
        known_devices=$(bluetoothctl devices | sed 's/^Device //' | awk '{print $1}' | sort)
        
        # Mostra mensagem de procura
        echo "🔍 Procurando dispositivos..." | $LAUNCHER "Bluetooth" &
        MSG_PID=$!
        
        # Para qualquer scan anterior
        bluetoothctl scan off >/dev/null 2>&1
        sleep 1
        
        # Inicia scan
        bluetoothctl scan on >/dev/null 2>&1 &
        SCAN_PID=$!
        
        # Mata a mensagem de procura
        kill $MSG_PID 2>/dev/null
        
        # Mostra progresso
        (
            for i in {1..15}; do
                echo "🔍 Escaneando... ($i/15s)"
                sleep 1
            done
        ) | $LAUNCHER "Bluetooth" &
        PROGRESS_PID=$!
        
        # Aguarda dispositivos aparecerem
        sleep 15
        
        # Para o scan e progresso
        kill $SCAN_PID 2>/dev/null
        kill $PROGRESS_PID 2>/dev/null
        bluetoothctl scan off >/dev/null 2>&1
        
        # Lista dispositivos atuais e filtra apenas os novos
        current_devices=$(bluetoothctl devices | sed 's/^Device //')
        new_devices=$(echo "$current_devices" | while read -r line; do
            mac=$(echo "$line" | awk '{print $1}')
            if ! echo "$known_devices" | grep -q "^$mac$"; then
                echo "$line"
            fi
        done)
        
        if [ -z "$new_devices" ]; then
            echo -e "❌ Nenhum dispositivo encontrado\n\nDicas:\n• Certifique-se que o dispositivo está em modo de pareamento\n• Aproxime o dispositivo\n• Tente novamente" | $LAUNCHER "Resultado da Busca"
            exit
        fi
        
        # Formata a lista com mais informações
        formatted_devices=$(echo "$new_devices" | while read -r line; do
            mac=$(echo "$line" | awk '{print $1}')
            name=$(echo "$line" | cut -d' ' -f2-)
            echo "📱 $name ($mac)"
        done)
        
        device=$(echo "$formatted_devices" | $LAUNCHER "Dispositivos Encontrados")
        [ -z "$device" ] && exit
        
        mac=$(echo "$device" | grep -oP '\(\K[^)]+')
        [ -z "$mac" ] && exit
        
        # Tenta emparelhar
        if bluetoothctl pair "$mac" 2>&1 | grep -q "successful"; then
            bluetoothctl trust "$mac" >/dev/null 2>&1
            sleep 1
            bluetoothctl connect "$mac" >/dev/null 2>&1
            notify "Dispositivo emparelhado!"
        else
            echo "Falha ao emparelhar. Tente novamente." | $LAUNCHER "Erro"
        fi
        ;;
esac