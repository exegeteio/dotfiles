# If running interactively, do not do anything.
[[ $- != *i*  ]] && return
[[ -x "$(which tmux)" ]] && [[ -z "$TMUX" ]] && [[ -f "$HOME/.auto_tmux" ]] && exec tmux

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="gentoo"

plugins=(git)
source $ZSH/oh-my-zsh.sh

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

export PATH="$PATH:$HOME/go/bin/:$HOME/.rbenv/shims:/usr/local/opt/python@3.8/bin"
export CDPATH="$CDPATH:$HOME:$HOME/code/:$HOME/code/github/:$HOME/code/gitlab/:$HOME/Desktop/"

# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f "$(which kubectl)" ]] || source <(kubectl completion zsh)
[[ ! -f "$(which rbenv)" ]] || eval "$(rbenv init -)"
[[ ! -f "$(which gh)" ]] || eval "$(gh completion --shell=zsh)"

export PORT=3000

[[ ! -f "$HOME/.aliases" ]] || source $HOME/.aliases

export JOURNAL_PATH="$HOME/Desktop/journal/"

# Prettier Docker commands, parallel builds.
export DOCKER_BUILDKIT=1

export DATABASE_URL="postgres://postgres:postgres@127.0.0.1/database"

export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
