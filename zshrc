# ============================================================
#  ~/.zshrc — DevOps / Red Team Zsh Config
#  Requires: oh-my-zsh, zsh-autosuggestions, zsh-syntax-highlighting
#  Install: sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# ============================================================

export ZSH="$HOME/.oh-my-zsh"

# ── Theme (use starship instead of oh-my-zsh themes for better perf) ──
ZSH_THEME=""  # Let starship handle it

# ── Plugins ──────────────────────────────────────────────────
plugins=(
  git
  docker
  docker-compose
  kubectl
  terraform
  ansible
  aws
  helm
  python
  sudo              # press ESC twice to add sudo to last command
  z                 # jump to frecent dirs
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh

# ── Starship prompt ──────────────────────────────────────────
# Install: curl -sS https://starship.rs/install.sh | sh
eval "$(starship init zsh)"

# ── Environment ──────────────────────────────────────────────
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"
export LANG="en_US.UTF-8"
export TERM="xterm-256color"

# ── PATH ─────────────────────────────────────────────────────
export PATH="$HOME/.local/bin:$HOME/go/bin:$HOME/.cargo/bin:$PATH"
export PATH="$PATH:/usr/local/sbin:/usr/sbin"

# ── History ──────────────────────────────────────────────────
HISTSIZE=50000
SAVEHIST=50000
HISTFILE="$HOME/.zsh_history"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE     # don't save commands starting with space (handy for secrets)
setopt SHARE_HISTORY

# ── Completion ───────────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'  # case-insensitive

# ── Key Bindings ─────────────────────────────────────────────
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^R' history-incremental-search-backward

# ── Aliases: General ─────────────────────────────────────────
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias cat="bat --style=plain"     # install: sudo apt install bat
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first --git"
alias la="eza -a --icons"
alias lt="eza --tree --icons --level=2"
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -Iv"
alias mkdir="mkdir -pv"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias cls="clear"
alias reload="source ~/.zshrc"
alias zshrc="nvim ~/.zshrc"

# ── Aliases: Git ─────────────────────────────────────────────
alias g="git"
alias gs="git status -sb"
alias ga="git add"
alias gaa="git add --all"
alias gc="git commit -m"
alias gca="git commit --amend --no-edit"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gp="git push"
alias gpf="git push --force-with-lease"
alias gl="git log --oneline --graph --decorate --all"
alias gd="git diff"
alias gds="git diff --staged"
alias grb="git rebase -i HEAD~"
alias gst="git stash"
alias gstp="git stash pop"

# ── Aliases: Docker ──────────────────────────────────────────
alias d="docker"
alias dc="docker compose"
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dpsa="docker ps -a --format 'table {{.Names}}\t{{.Status}}\t{{.Image}}'"
alias dimg="docker images --format 'table {{.Repository}}\t{{.Tag}}\t{{.Size}}'"
alias dprune="docker system prune -af --volumes"
alias dlog="docker logs -f --tail=100"
alias dexec="docker exec -it"
drm() { docker rm -f $(docker ps -aq); }
dstop() { docker stop $(docker ps -aq); }

# ── Aliases: Kubernetes ──────────────────────────────────────
alias k="kubectl"
alias kgp="kubectl get pods -o wide"
alias kgs="kubectl get svc"
alias kgn="kubectl get nodes -o wide"
alias kgd="kubectl get deployments"
alias kga="kubectl get all"
alias kdp="kubectl describe pod"
alias klog="kubectl logs -f --tail=100"
alias kex="kubectl exec -it"
alias kctx="kubectx"  # install: https://github.com/ahmetb/kubectx
alias kns="kubens"
kwatch() { watch -n2 kubectl get pods "${@}"; }
alias kaf="kubectl apply -f"
alias kdf="kubectl delete -f"

# ── Aliases: Terraform ───────────────────────────────────────
alias tf="terraform"
alias tfi="terraform init"
alias tfp="terraform plan"
alias tfa="terraform apply"
alias tfd="terraform destroy"
alias tff="terraform fmt -recursive"
alias tfv="terraform validate"
alias tfw="terraform workspace"

# ── Aliases: Ansible ─────────────────────────────────────────
alias ap="ansible-playbook"
alias av="ansible-vault"
alias ai="ansible-inventory"
alias ag="ansible-galaxy"

# ── Aliases: Networking / Recon ──────────────────────────────
alias myip="curl -s https://api.ipify.org && echo"
alias localip="ip -br addr"
alias ports="ss -tulpn"
alias listen="ss -lntp"
alias tcpdump="sudo tcpdump -i any -nn"
nmapscan() { sudo nmap -sV -sC -oA "scan_$(date +%Y%m%d_%H%M%S)" "${@}"; }
alias masscan="sudo masscan --rate=10000"
alias ffuf="ffuf -c -v"

# ── Aliases: System ──────────────────────────────────────────
alias update="sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y"
alias sctl="systemctl"
alias jctl="journalctl -xe"
alias mem="free -h"
alias disk="df -h"
alias cpu="htop"
alias top="btop"   # install: sudo apt install btop
alias psg="ps aux | grep -v grep | grep"
alias killp="sudo kill -9"
alias chx="chmod +x"

# ── Aliases: Security ────────────────────────────────────────
alias hashid="hashid"
alias john="john --wordlist=/usr/share/wordlists/rockyou.txt"
alias hydra="hydra -V"
alias searchsploit="searchsploit -t"
alias msfconsole="msfconsole -q"

# ── Functions ────────────────────────────────────────────────

# mkcd — make and cd into directory
mkcd() { mkdir -p "$1" && cd "$1"; }

# extract — universal archive extractor
extract() {
  case "$1" in
    *.tar.bz2) tar xjf "$1"   ;;
    *.tar.gz)  tar xzf "$1"   ;;
    *.bz2)     bunzip2 "$1"   ;;
    *.rar)     unrar x "$1"   ;;
    *.gz)      gunzip "$1"    ;;
    *.tar)     tar xf "$1"    ;;
    *.zip)     unzip "$1"     ;;
    *.7z)      7z x "$1"      ;;
    *)         echo "'$1' cannot be extracted" ;;
  esac
}

# serve — quick HTTP server in current dir
serve() { python3 -m http.server "${1:-8080}"; }

# crt — certificate recon
crt() { curl -s "https://crt.sh/?q=%25.$1&output=json" | jq -r '.[].name_value' | sort -u; }

# base64 shortcuts
b64e() { echo -n "$1" | base64; }
b64d() { echo -n "$1" | base64 -d; }

# gen a random password
genpass() { tr -dc 'A-Za-z0-9!@#$%^&*' </dev/urandom | head -c "${1:-32}"; echo; }

# kubeconfig switcher
kconf() {
  export KUBECONFIG="$HOME/.kube/$1.yaml"
  echo "KUBECONFIG set to $KUBECONFIG"
}

# ── AWS ───────────────────────────────────────────────────────
alias awswho="aws sts get-caller-identity"
awsprofile() { export AWS_PROFILE="$1"; echo "AWS_PROFILE=$1"; }

# ── FZF (fuzzy finder) ───────────────────────────────────────
# Install: sudo apt install fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ── zoxide (smarter cd) ──────────────────────────────────────
# Install: curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
eval "$(zoxide init zsh)"
alias cd="z"

# ── direnv (per-project envs) ────────────────────────────────
# Install: sudo apt install direnv
eval "$(direnv hook zsh)"
