if [[ ":$FPATH:" != *":$HOME/.zsh/completions:"* ]]; then export FPATH="$HOME/.zsh/completions:$FPATH"; fi
export ZSH="$HOME/.oh-my-zsh"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$ANDROID_HOME/tools:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"
export ANTHROPIC_API_KEY=

ZSH_THEME="robbyrussell"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# File system
alias ls='eza -lha --group-directories-first --icons'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'batcat --style=numbers --color=always {}'"
alias fd='fdfind'
alias cd='z'
# alias rm='mv --target-directory=$HOME/.local/share/Trash/files'

alias ian-front="cd $HOME/Documents/codepresence/projects/Ian/Datamaximizer/datamax-front/ && tmux new -s datmax-front"
alias ian-api="cd $HOME/Documents/codepresence/projects/Ian/Datamaximizer/datamax-api/ && tmux new -s datmax-api"

alias ewi-app="cd $HOME/Documents/codepresence/projects/ewerton/app/ && tmux new -s ewi-app"
alias ewi-front="cd $HOME/Documents/codepresence/projects/ewerton/dashboard/admin/ && tmux new -s ewi-admin"
alias ewi-api="cd $HOME/Documents/codepresence/projects/ewerton/dashboard/ewi-api/ && tmux new -s ewi-api"

alias notes="cd $HOME/Documents/notes/ && tmux new -s notes"

alias wifi="nmtui"

# Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias :q='exit'
alias open="nautilus"

# Tools
alias n='nvim'
alias g='git'
alias d='docker'
alias r='rails'
alias bat='batcat'
alias lzg='lazygit'
alias lzd='sudo lazydocker'
alias brilho='xrandr --output HDMI-1-0 --brightness'
alias c="clear"

eval "$(atuin init zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
# eval "$(ssh-agent -s)"

export PATH="$PATH:$HOME/.spicetify"
export PATH="$PATH:$HOME/.spicetify"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi
. "$HOME/.deno/env"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export LIBVA_DRIVER_NAME=vidia
export __GLX_VENDOR_LIBRARY_NAME=nvidia

export PATH="$PATH:/var/lib/flatpak/exports/bin:/snap/bin"
