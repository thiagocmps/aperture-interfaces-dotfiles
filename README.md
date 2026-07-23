# Meus dotfiles

Este repositório tem como principal objetivo guardar dotfiles do famoso Window Manager Hyprland, mas eventualmente adicionei algumas configurações de programas que utilizo com frequência. Me inspirei bastante em computadores da decada de 80, o que inevitavelmente me lembra Portal, por isso o nome Aperture Interfaces.

# Tema do Hyprland

```
por aqui fotos do ambiente
```

# Programas envolvidos

- Wofi: Utilizado como launcher de programas
- Hyprpaper: Gerenciador de wallpapers no Hyprland
- Kitty: Terminal customizado com tema retrô
- nvim: Editor de texto configurado com LSP

# Instalação

Existem três opcões de instalação:

1. Utilizar o install.sh (recomendado)
2. Comando Stow
3. Copiar/mover diretório (não faça isso)

## 1. install.sh

### Antes de utilizar

Antes de usar o install.sh, melhor explicar exatamente o que ele faz.

Basicamente, ele detecta o sistema operativo no qual você executou e utiliza o seu gerenciador de pacotes da sua distro para instalar o GNU Stow, caso não identifique. Em seguida, verifica a se existe nvim no sistema e instala.

**Detalhe importante:** Caso sua distro tenha base Debian ou RedHat, o script irá compilar diretamente do repositório oficial na branch mais atualizada e estável, por quê? O motivo é que os plugins que usei são muito atualizados para as versões guardadas nos repositórios apt e dnf, pode ser que a sua distro precise compilar também, mas como eu só testei nessas duas, implementei apenas nelas.

Depois disso, irá aparecer um menu cli com as opcões de instalação das dotconfigs, caso já exista algo em `~/.config`, vai ser movido para ` ~/.config/programa-backup`.
É só isso.

### agora sim install.sh

Na raiz do projeto, rode esse comando:

```bash
bash install.sh
```

Vai aparecer um menu parecido com esse:

```bash
Pretende instalar as configuracões de quais programas

0 - instalar todos
1 - Neovim
2 - Hypr
3 - Waybar
4 - Wofi
5 - Kitty

>:
```

Só escolher o que instalar e pronto, resolvido.

## Direto Stow

O projeto foi montado pensando na implementação do GNU Stow, ou seja, caso não queira utilizar o meu script, apenas faça:

```bash
stow nvim #por exemplo
```

# Problemas pendentes

- **Workspaces** (hypr): Implementação de workspaces individuais por monitor
- **Install.sh**: Após compilar nvim em distros baseadas em Debian e fedora, a instalação do dotfiles não é continuado **'No /usr/bin/nvim directory'**

# Programas que pretendo adicionar

- DOOM Emacs
- Alacritty
- Ranger

# Possível (provável) mudança de repositório

Como referi anteriormente, a princípio a ideia era utilizar esse repositório apenas para hyprland dotfiles, mas acabei adicionando programas fora do tema, como o nvim. O melhor dos mundos seria criar um repositório exclusivamente para ferramentas úteis que utilizo no meu sistema de forma global e criar uma cópia editada para combinar com aperture-interfaces
