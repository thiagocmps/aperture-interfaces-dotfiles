# Aperture Interfaces

> A collection of retro-inspired Linux dotfiles with Portal aesthetics.

<!-- Badges -->
![Hyprland](https://img.shields.io/badge/Hyprland-Wayland-58E1FF?logo=wayland&logoColor=white)
![Arch Linux](https://img.shields.io/badge/Arch_Linux-1793D1?logo=arch-linux&logoColor=white)
![Neovim](https://img.shields.io/badge/Neovim-57A143?logo=neovim&logoColor=white)
![License](https://img.shields.io/github/license/SEU_USUARIO/aperture-interfaces)

Este repositório reúne as configurações que utilizo diariamente no meu ambiente Linux. O projeto começou como um conjunto de dotfiles para o **Hyprland**, mas acabou crescendo e hoje também inclui configurações de ferramentas que fazem parte do meu fluxo de trabalho.

A identidade visual é inspirada nos computadores das décadas de 70 e 80, misturada com a estética da série **Portal**, daí o nome **Aperture Interfaces**.

---

## Preview

<p align="center">
    <img src="assets/desktop.png" width="90%">
</p>

---

# Programas

| Programa | Descrição |
|----------|-----------|
| Hyprland | Window Manager principal |
| Hyprpaper | Wallpapers |
| Waybar | Barra de status |
| Wofi | Launcher |
| Kitty | Terminal |
| Neovim | Editor de código |

---

# Instalação

Existem três formas de instalar as configurações:

1. `install.sh` (**recomendado**)
2. GNU Stow
3. Instalação manual (não recomendado)

---

## install.sh

### O que o script faz?

O script detecta automaticamente a distribuição Linux utilizada e instala o **GNU Stow**, caso ele ainda não esteja presente.

Depois disso, verifica se o **Neovim** está instalado.

Nas distribuições baseadas em **Debian** e **Fedora**, o script compila automaticamente a versão mais recente e estável do Neovim diretamente do repositório oficial. Isso evita incompatibilidades com plugins mais recentes.

Após essas verificações, é exibido um menu permitindo escolher quais configurações serão instaladas.

Caso já exista alguma configuração correspondente em `~/.config`, ela será movida para:

```text
~/.config/<programa>-backup
```

---

### Executando

```bash
bash install.sh
```

Será exibido um menu semelhante a este:

```text
Quais configurações deseja instalar?

0 - Todas
1 - Neovim
2 - Hyprland
3 - Waybar
4 - Wofi
5 - Kitty

> 
```

---

## GNU Stow

O projeto foi organizado para funcionar naturalmente com o GNU Stow.

Exemplo:

```bash
stow nvim
```

ou

```bash
stow kitty
```

---

# Problemas conhecidos

- [ ] Implementar workspaces independentes para múltiplos monitores.
- [ ] Após compilar o Neovim em distribuições baseadas em Debian/Fedora, o `install.sh` não continua automaticamente (`No /usr/bin/nvim directory`).

---

# Roadmap

- [ ] Doom Emacs
- [ ] Alacritty
- [ ] Ranger

---

# Futuro do projeto

Inicialmente este repositório era dedicado apenas ao Hyprland.

Como ele acabou crescendo bastante, provavelmente será dividido em dois projetos:

- **Aperture Interfaces**
  - Apenas personalização visual do Hyprland.

- **Dotfiles**
  - Configurações de ferramentas como Neovim, Ranger, Doom Emacs, Kitty, etc.

Assim, quem quiser apenas o tema do Hyprland não precisará instalar configurações de programas que talvez nem utilize.

---

## Licença

Este projeto está licenciado sob a licença MIT.
