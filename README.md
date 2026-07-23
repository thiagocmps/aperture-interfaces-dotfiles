# Aperture Interfaces

> A collection of retro-inspired Linux dotfiles with Portal aesthetics.

<!-- Badges -->
![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-58E1FF?logo=wayland&logoColor=white)
![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?logo=arch-linux&logoColor=white)
![Neovim](https://img.shields.io/badge/Neovim-57A143?logo=neovim&logoColor=white)
![License](https://img.shields.io/github/license/SEU_USUARIO/aperture-interfaces)

Este repositório tem como principal objetivo guardar os meus dotfiles do famoso Window Manager **Hyprland**, mas eventualmente acabei adicionando também algumas configurações de programas que utilizo com frequência.

A inspiração veio dos computadores da década de 80, o que inevitavelmente me lembra **Portal**, daí o nome **Aperture Interfaces**.

---

## Tema do Hyprland

```text
Por aqui, fotos do ambiente.
```

---

## Programas envolvidos

- **Wofi:** Launcher de programas
- **Hyprpaper:** Gerenciador de wallpapers para o Hyprland
- **Kitty:** Terminal customizado com tema retrô
- **Neovim:** Editor de texto configurado com LSP

---

## Instalação

Existem três opções de instalação:

1. Utilizar o `install.sh` (**recomendado**)
2. Utilizar o GNU Stow
3. Copiar/mover os diretórios manualmente (**não faça isso**)

---

### install.sh

#### Antes de utilizar

Antes de usar o `install.sh`, vale explicar exatamente o que ele faz.

Basicamente, ele detecta o sistema operativo em que está a ser executado e utiliza o gerenciador de pacotes da distribuição para instalar o **GNU Stow**, caso ele não esteja instalado.

Em seguida, verifica se o **Neovim** existe no sistema e, caso não exista, instala-o.

> **Detalhe importante**
>
> Caso a sua distribuição seja baseada em **Debian** ou **Red Hat**, o script compila automaticamente o Neovim diretamente do repositório oficial, utilizando a branch mais recente e estável.
>
> O motivo é simples: muitos dos plugins utilizados nestes dotfiles são demasiado recentes para as versões disponíveis nos repositórios `apt` e `dnf`.
>
> É possível que outras distribuições também precisem desse processo, mas como só testei nessas duas, a compilação automática foi implementada apenas para elas.

Depois disso, será apresentado um menu CLI com as opções de instalação.

Caso já exista alguma configuração correspondente em `~/.config`, ela será movida para:

```text
~/.config/<programa>-backup
```

É só isso.

#### Executando

Na raiz do projeto, execute:

```bash
bash install.sh
```

Será apresentado um menu semelhante a este:

```text
Pretende instalar as configurações de quais programas?

0 - Instalar todos
1 - Neovim
2 - Hypr
3 - Waybar
4 - Wofi
5 - Kitty

>
```

Basta escolher a opção desejada e pronto.

---

### GNU Stow

O projeto foi organizado pensando na utilização do **GNU Stow**. Caso não queira utilizar o script de instalação, basta executar:

```bash
stow nvim
```

ou qualquer outro diretório que desejar instalar.

---

## Problemas pendentes

- **Hyprland:** Implementação de workspaces individuais por monitor.
- **install.sh:** Após compilar o Neovim em distribuições baseadas em Debian ou Fedora, a instalação dos dotfiles não continua automaticamente (`No /usr/bin/nvim directory`).

---

## Roadmap

- Doom Emacs
- Alacritty
- Ranger

---

## Futuro do projeto

Como referi anteriormente, a ideia inicial era utilizar este repositório apenas para os dotfiles do Hyprland.

No entanto, acabei por adicionar configurações de programas que não fazem parte desse tema, como o Neovim.

O melhor dos mundos seria criar um repositório exclusivamente para ferramentas que utilizo de forma global no sistema (Neovim, Ranger, Doom Emacs, Kitty, etc.) e manter o **Aperture Interfaces** focado apenas na personalização visual do Hyprland.
