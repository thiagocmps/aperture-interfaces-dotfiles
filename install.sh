#!/bin/bash
CONFIG_PATH="$HOME/.config"

set -e

cd "$(dirname "$0")"

#menu verificação do sistema operacional
#verifica o sistema operativo e define seu respectivo package manager
if [[ "$OSTYPE" =~ ^linux ]]; then
  if [ -f /etc/os-release ]; then    
    source /etc/os-release
    # A variável $ID contém o nome curto da distro (ex: ubuntu, debian, fedora)
    case "$ID" in
      ubuntu|debian)
        echo "Estás a usar uma base Debian ($ID)"
        PKG_MANAGER="sudo apt install"
        echo $PKG_MANAGER
        ;;
      fedora|rhel|centos)
        echo "Estás a usar uma base Red Hat ($ID)"
        PKG_MANAGER="sudo dnf install"  
        echo $PKG_MANAGER
        ;;
      alpine)
        echo "Estás a usar Alpine Linux"
        PKG_MANAGER="apk add"
        echo $PKG_MANAGER
        ;;
      arch)
        echo "Estás a usar Arch Linux"
        PKG_MANAGER="sudo pacman -S"
        echo $PKG_MANAGER
        ;;
      *)
        echo "Distribuição Linux não identificada: $ID"
        ;;
    esac
  else
    echo "Arquivo  /etc/os-release não encontrado. Sistema muito antigo?"
  fi
  #id do MacOS
elif [[ "$OSTYPE" =~ ^darwin ]] then
  echo  "Está a usar MacOS"
  PKG_MANAGER="brew install"
elif  [[ "$OSTYPE" =~ ^msys ||  "$OSTYPE" =~ ^cygwin  ]] then
  echo "Script não continuará, sistema Windows detectado."
fi

#Menu instalacao do stow 
#caso nao tenha Stow instalado, instala com pkgmanager
if ! command -v stow -v >/dev/null 2>&1; then
  echo "GNU Stow necessário para continuar, deseja instalar? (caso decidir que não, o script irá fechar, sem nenhuma alteração no sistema)\n"
  read  -r  -p "(Y/n): " STOW_INPUT 
  case "$STOW_INPUT" in
    Y|y|s|S) 
      echo "Instalando stow"
      $PKG_MANAGER stow
      break
      ;;    
    N|n) 
      echo "Stow não será instalado, saindo do script..."
      exit
      break
      ;;  
  esac
else 
  echo "GNU stow encontrado!"
fi 

#Instalacao do nvim
if ! command -v nvim &> /dev/null; then
  echo "Neovim não foi encontrado, instalando"
  $PKG_MANAGER  nvim
fi


#Menu CLI
printf '%*s\n' "$(tput cols)" '' | tr ' ' '='

printf "\n"

printf "Pretende instalar as configurações de quais programas?\n\n"

printf "[0] Instalar todos\n"
printf "[1] Neovim\n"
printf "[2] Hypr\n"
printf "[3] Waybar\n"
printf "[4] Wofi\n"
printf "[5] Kitty\n"

printf "\n"
printf '%*s\n' "$(tput cols)" '' | tr ' ' '='
printf "\n"

printf "(É necessário ter o nvim na última versão para as configurações funcionarem sem problemas)"
while true; do
  printf "\n"
  read -r -p ">: " INPUT

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

#Funções principais
#nvim
function install_nvim {
  if [[ -d "$CONFIG_PATH/nvim" ]]; then
    echo "Há uma configuração ativa. Vai ser criado "nvim-backup" com as configurações antigas."

    if [[ -e "$CONFIG_PATH/nvim-backup" ]]; then
      echo "Já existe um backup em $CONFIG_PATH/nvim-backup"
      exit 1
    fi

    mv "$CONFIG_PATH/nvim" "$CONFIG_PATH/nvim-backup" && echo "Backup criado!" 
    stow -v --target="$HOME" nvim && echo "Configuração instalada com sucesso!"
  else 
    stow -v --target="$HOME" nvim && echo "Configuração instalada com sucesso!"
  fi 
}

#hypr
function install_hypr {
  if [[ -d "$CONFIG_PATH/hypr" ]]; then
    echo "Há uma configuração ativa. Vai ser criado "hypr-backup" com as configurações antigas."

    if [[ -e "$CONFIG_PATH/hypr-backup" ]]; then
      echo "Já existe um backup em $CONFIG_PATH/hypr-backup"
      exit 1
    fi 

    mv "$CONFIG_PATH/hypr" "$CONFIG_PATH/hypr-backup" && echo "Backup criado!" 
    stow -v --target="$HOME" hypr && echo "Configuração instalada com sucesso!"
  else 
    stow -v --target="$HOME" hypr && echo "Configuração instalada com sucesso!"
  fi 
}

#waybar
function install_waybar {
  if [[ -d "$CONFIG_PATH/waybar" ]]; then
    echo "Há uma configuração ativa. Vai ser criado "waybar-backup" com as configurações antigas."


    if [[ -e "$CONFIG_PATH/waybar-backup" ]]; then
      echo "Já existe um backup em $CONFIG_PATH/waybar-backup"
      exit 1
    fi

    mv "$CONFIG_PATH/waybar" "$CONFIG_PATH/waybar-backup" && echo "Backup criado!" 
    stow -v --target="$HOME" waybar && echo "Configuração instalada com sucesso!"
  else 
    stow -v --target="$HOME" waybar && echo "Configuração instalada com sucesso!"
  fi 
}

#wofi
function install_wofi {
  if [[ -d "$CONFIG_PATH/wofi" ]]; then
    echo "Há uma configuração ativa. Vai ser criado "wofi-backup" com as configurações antigas."

    if [[ -e "$CONFIG_PATH/wofi-backup" ]]; then
      echo "Já existe um backup em $CONFIG_PATH/wofi-backup"
      exit 1
    fi

    mv "$CONFIG_PATH/wofi" "$CONFIG_PATH/wofi-backup" && echo "Backup criado!" 
    stow -v --target="$HOME" wofi && echo "Configuração instalada com sucesso!"
  else 
    stow -v --target="$HOME" wofi && echo "Configuração instalada com sucesso!"
  fi 
}

#kitty
function install_kitty {
  if [[ -d "$CONFIG_PATH/kitty" ]]; then
    echo "Há uma configuração ativa. Vai ser criado "kitty-backup" com as configurações antigas."

    if [[ -e "$CONFIG_PATH/kitty-backup" ]]; then
      echo "Já existe um backup em $CONFIG_PATH/kitty-backup"
      exit 1
    fi

    mv "$CONFIG_PATH/kitty" "$CONFIG_PATH/kitty-backup" && echo "Backup criado!" 
    stow -v --target="$HOME" kitty && echo "Configuração instalada com sucesso!"
  else 
    stow -v --target="$HOME" kitty && echo "Configuração instalada com sucesso!"
  fi 
}
