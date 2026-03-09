# 🎨 dotfiles

> Neovim · Zsh · Tmux · Terminator · Starship — Catppuccin Mocha everywhere

![OS](https://img.shields.io/badge/OS-Arch%20%2F%20Ubuntu-1793D1?style=flat-square&logo=linux)
![Shell](https://img.shields.io/badge/Shell-Zsh-89b4fa?style=flat-square)
![Editor](https://img.shields.io/badge/Editor-Neovim-57A143?style=flat-square&logo=neovim)
![Theme](https://img.shields.io/badge/Theme-Catppuccin%20Mocha-cba6f7?style=flat-square)

---

## 📸 Screenshots

> TODO: Add screenshots after setup

---

## 🗂️ Structure

```
dotfiles/
├── nvim/
│   └── init.lua              # Full Neovim config (lazy.nvim)
├── zsh/
│   ├── .zshrc                # Zsh config + aliases
│   └── starship.toml         # Starship prompt
├── tmux/
│   └── .tmux.conf            # Tmux config + TPM plugins
├── terminator/
│   └── config                # Terminator layouts + theme
└── scripts/
    └── install.sh            # Bootstrap script
```

---

## ⚡ Quick Install

```bash
git clone https://github.com/YOU/dotfiles ~/.dotfiles
cd ~/.dotfiles
./scripts/install.sh
```

---

## 🔧 Manual Setup

### Dependencies

```bash
# Arch
sudo pacman -S neovim tmux zsh fzf ripgrep fd bat eza btop git curl wget

# Ubuntu / Debian
sudo apt install neovim tmux zsh fzf ripgrep fd-find bat btop git curl wget
# eza not in apt — install manually:
curl -LO https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz
tar xzf eza_*.tar.gz && sudo mv eza /usr/local/bin/
```

### Oh-My-Zsh + plugins

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions       ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
```

### Starship

```bash
curl -sS https://starship.rs/install.sh | sh
mkdir -p ~/.config
cp zsh/starship.toml ~/.config/starship.toml
```

### Neovim

```bash
# Install Neovim >= 0.9
# Arch: sudo pacman -S neovim
# Ubuntu: https://github.com/neovim/neovim/releases

mkdir -p ~/.config/nvim
cp nvim/init.lua ~/.config/nvim/init.lua

# Open nvim — lazy.nvim will auto-install all plugins
nvim
```

### Tmux + TPM

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
cp tmux/.tmux.conf ~/.tmux.conf
tmux source ~/.tmux.conf
# Inside tmux: prefix + I  (Ctrl+A then I) to install plugins
```

### Terminator

```bash
sudo apt install terminator   # Ubuntu
# or: sudo pacman -S terminator

mkdir -p ~/.config/terminator
cp terminator/config ~/.config/terminator/config
```

### Nerd Font

```bash
# JetBrainsMono Nerd Font (used everywhere)
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
curl -LO "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
tar xf JetBrainsMono.tar.xz && rm JetBrainsMono.tar.xz
fc-cache -fv
```

---

## ⌨️ Key Bindings (Highlights)

### Tmux (prefix = `Ctrl+A`)

| Key | Action |
|-----|--------|
| `prefix \|` | Split horizontal |
| `prefix -` | Split vertical |
| `prefix h/j/k/l` | Navigate panes |
| `prefix M-d` | DevOps 3-pane layout |
| `prefix M-m` | Monitoring layout |
| `prefix r` | Reload config |

### Neovim (`<leader>` = `Space`)

| Key | Action |
|-----|--------|
| `<leader>e` | File explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename symbol |
| `<leader>ha` | Harpoon add file |

---

## 🎨 Theme

Everything uses **Catppuccin Mocha** — consistent across Neovim, Tmux, Terminator, and Starship.

- 🖥️ Terminal background: transparent (set compositor opacity ~90%)
- 🔤 Font: JetBrainsMono Nerd Font 12
- 🌈 Colors: full 256-color / true-color

---

## 📦 Recommended extras

```bash
# Terminal tools
brew install lazygit       # git TUI
brew install k9s           # Kubernetes TUI  
brew install kubectx       # kubectl context switcher
pip install thefuck        # fix typos with: fuck

# Rice extras (Arch)
sudo pacman -S picom       # compositor (transparency)
sudo pacman -S rofi        # app launcher
sudo pacman -S polybar     # status bar (if using i3/bspwm)
sudo pacman -S dunst        # notifications
```
