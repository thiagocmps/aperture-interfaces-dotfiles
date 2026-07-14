#!/bin/bash
CONFIG_PATH="$HOME/.config"

set -e

#Caso nao tenha Stow instalado, fecha o programa
if ! command -v stow >/dev/null 2>&1; then
  echo "Erro: GNU Stow não está instalado."
  exit 1  
fi 

#Funções principais
#nvim
function install_nvim {
  if [[ -d "$CONFIG_PATH"/nvim ]]; then
    echo "Há uma configuração ativa. Vai ser criado "nvim-backup" com as configurações antigas."
    mv "$CONFIG_PATH/nvim" "$CONFIG_PATH/nvim-backup" && echo "Backup criado!" 
    stow --target="$HOME" nvim && echo "Configuração instalada com sucesso!"
  else 
   stow --target="$HOME" nvim && echo "Configuração instalada com sucesso!"
  fi 
}

#hypr
function install_hypr {
  if [[ -d "$CONFIG_PATH"/hypr ]]; then
    echo "Há uma configuração ativa. Vai ser criado "hypr-backup" com as configurações antigas."
    mv "$CONFIG_PATH/hypr" "$CONFIG_PATH/hypr-backup" && echo "Backup criado!" 
    stow --target="$HOME" hypr && echo "Configuração instalada com sucesso!"
  else 
   stow --target="$HOME" hypr && echo "Configuração instalada com sucesso!"
  fi 
}

function install_waybar {
  if [[ -d "$CONFIG_PATH"/waybar ]]; then
    echo "Há uma configuração ativa. Vai ser criado "waybar-backup" com as configurações antigas."
    mv "$CONFIG_PATH/waybar" "$CONFIG_PATH/waybar-backup" && echo "Backup criado!" 
    stow --target="$HOME" waybar && echo "Configuração instalada com sucesso!"
  else 
   stow --target="$HOME" waybar && echo "Configuração instalada com sucesso!"
  fi 
}

function install_wofi {
  if [[ -d "$CONFIG_PATH"/wofi ]]; then
    echo "Há uma configuração ativa. Vai ser criado "wofi-backup" com as configurações antigas."
    mv "$CONFIG_PATH/wofi" "$CONFIG_PATH/wofi-backup" && echo "Backup criado!" 
    stow --target="$HOME" wofi && echo "Configuração instalada com sucesso!"
  else 
   stow --target="$HOME" wofi && echo "Configuração instalada com sucesso!"
  fi 
}

function install_kitty {
  if [[ -d "$CONFIG_PATH"/kitty ]]; then
    echo "Há uma configuração ativa. Vai ser criado "kitty-backup" com as configurações antigas."
    mv "$CONFIG_PATH/kitty" "$CONFIG_PATH/kitty-backup" && echo "Backup criado!" 
    stow --target="$HOME" kitty && echo "Configuração instalada com sucesso!"
  else 
   stow --target="$HOME" kitty && echo "Configuração instalada com sucesso!"
  fi 
}

#Menu CLI
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
      install_nvim && install_hypr && install_waybar && install_wofi && install_kitty && echo "Instalados com sucesso" 
      break
      ;;  
    1)
      echo "Instalando neovim..."
      install_nvim
      break
      ;;  
    2)
      echo "Instalando hypr..."
      install_hypr
      break
      ;;
    3)
      echo "Instalando waybar..."
      install_waybar
      break
      ;;  
    4)
      echo "Instalando wofi..."
      install_wofi
      break
      ;;  
    5)
      echo "Instalando kitty..."
      install_kitty
      break
      ;;
    *) 
      echo "Opção Inválida."
      break
      ;;  
  esac
done
