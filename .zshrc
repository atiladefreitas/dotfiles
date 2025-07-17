# ─────────────────────────────────────────────────────────────
# Core Environment Setup
# ─────────────────────────────────────────────────────────────
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then
  export FPATH="$HOME/.zsh/completions:$FPATH"
fi

# ─────────────────────────────────────────────────────────────
# Android SDK
# ─────────────────────────────────────────────────────────────
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/tools:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"

# ─────────────────────────────────────────────────────────────
# Starship, Atuin, Zoxide
# ─────────────────────────────────────────────────────────────
eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# ─────────────────────────────────────────────────────────────
# Node/NVM
# ─────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"

# ─────────────────────────────────────────────────────────────
# Bun
# ─────────────────────────────────────────────────────────────
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# ─────────────────────────────────────────────────────────────
# Misc Paths
# ─────────────────────────────────────────────────────────────
export PATH="$PATH:$HOME/.spicetify"
export PATH="$PATH:/var/lib/flatpak/exports/bin:/snap/bin"
export PATH="/home/atiladefreitas/.opencode/bin:$PATH"

# ─────────────────────────────────────────────────────────────
# NVIDIA / Video
# ─────────────────────────────────────────────────────────────
export LIBVA_DRIVER_NAME=vidia
export __GLX_VENDOR_LIBRARY_NAME=nvidia

# ─────────────────────────────────────────────────────────────
# Locale
# ─────────────────────────────────────────────────────────────
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# ─────────────────────────────────────────────────────────────
# GCloud SDK
# ─────────────────────────────────────────────────────────────
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"
fi
# if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then
#   source "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"
# fi

# ─────────────────────────────────────────────────────────────
# Aliases: Filesystem
# ─────────────────────────────────────────────────────────────
alias ls='eza -lha --group-directories-first --icons'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
alias fd='fdfind'
alias cd='z'

# ─────────────────────────────────────────────────────────────
# Aliases: Navigation
# ─────────────────────────────────────────────────────────────
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias :q='exit'
alias open="nautilus"
alias wifi="nmtui"

# ─────────────────────────────────────────────────────────────
# Aliases: Tools
# ─────────────────────────────────────────────────────────────
alias n='nvim'
alias g='git'
alias d='docker'
alias r='rails'
alias bat='batcat'
alias lzg='lazygit'
alias lzd='sudo lazydocker'
alias brilho='xrandr --output HDMI-1-0 --brightness'
alias c='clear'

# ─────────────────────────────────────────────────────────────
# Aliases: Tmux Workflows
# ─────────────────────────────────────────────────────────────
alias t='
function _tmux_session() {
  read "name?Session name: "
  tmux new-session -s "$name" -d
  tmux send-keys -t "$name" "nvim" C-m
  tmux new-window -t "$name" -n dev
  tmux send-keys -t "$name:dev" "pnpm install && pnpm dev" C-m
  tmux attach -t "$name"
}; _tmux_session'

alias notes='cd $HOME/Documents/notes/ && tmux new -As notes "nvim"'

# ─────────────────────────────────────────────────────────────
# Oh My Zsh
# ─────────────────────────────────────────────────────────────
source $ZSH/oh-my-zsh.sh
