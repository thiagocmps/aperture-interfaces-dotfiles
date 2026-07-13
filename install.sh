#!/bin/bash
CONFIG_PATH="$HOME/.config"

#NVIM_PATH="$HOME/.config/nvim" 
ALT_PATH="$HOME/Documentos/caminho-alternativo"
ROOT_ALT_PATH="$HOME/Documentos"

set -e

function install_nvim {
  if [[ -d "$CONFIG_PATH"/nvim ]]; then
    echo "Há uma configuração ativa. Vai ser criado "nvim-backup" com as configurações antigas."
    mv "$CONFIG_PATH/nvim" "$CONFIG_PATH/nvim-backup" && echo "Backup criado!"
    
    if ! command -v stow >/dev/null 2>&1; then
      echo "Erro: GNU Stow não está instalado."
      exit 1
    fi 
    stow --target="$HOME" nvim
    #mkdir "$ALT_PATH" && touch "$ALT_PATH/instalado-aqui.txt" && echo "Instalado!"
  else 
    if ! command -v stow >/dev/null 2>&1; then
      echo "Erro: GNU Stow não está instalado."
      exit 1
    fi
    stow --target="$HOME" nvim
  fi 
}


printf '%*s\n' "$(tput cols)" '' | tr ' ' '='

printf "Bem-vindo, %s!\n\n" "$USER"
printf "Pretende instalar as configurações de quais programas?\n\n"
printf "[0] Instalar todos\n"
printf "[1] Neovim\n"
printf "[2] Hypr\n"
printf "[3] Waybar\n"
printf "[4] Wofi\n"
printf "[5] Kitty\n"

while true; do
  read -r -p "Escolha: " INPUT
  
  case "$INPUT" in
    0) 
      echo "Instalando tudo..."
      install_nvim
      break
      ;;  
    1)
      echo "Instalando neovim..."
      break
      ;;  
    2)
      echo "Instalando hypr..."
      break
      ;;
    3)
      echo "Instalando waybar..."
      break
      ;;  
    4)
      echo "Instalando wofi..."
      break
      ;;  
    5)
      echo "Instalando tudo..."
      break
      ;;
    *) 
      echo "Opção Inválida."
      break
      ;;  
  esac
done


# cria  backup das configuracoes caso tenha e instala por cima
#if [[ -d "$ALT_PATH" ]]; then
#  echo "A pasta existe. Criando Backup..."
#  mv "$ALT_PATH" "$ROOT_ALT_PATH/caminho-alternativo-backup" && echo "Backup criado!"
#  mkdir "$ALT_PATH" && touch "$ALT_PATH/instalado-aqui.txt" && echo "Instalado!"
#else
#  echo "A pasta não existe. Instalando...." 
#  mkdir "$ALT_PATH" && touch "$ALT_PATH/instalado-aqui.txt" && echo "Instalado com sucesso!"
#fi
