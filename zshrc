#!/bin/bash
# If running interactively, do not do anything.
[[ -z "$DEBUG" ]] || echo "Checking interactive"
[[ $- != *i*  ]] && return

export PATH="$HOME/bin:$HOME/.brew/bin:$HOME/go/bin:$HOME/.rbenv/bin:/usr/local/opt/python@3.8/bin:$PATH"
export CDPATH="$CDPATH:$HOME:$HOME/code/:$HOME/code/github/:$HOME/code/github/exegeteio/:$HOME/code/gitlab/:$HOME/Desktop/"

[[ -z "$DEBUG" ]] || echo "Checking tmux"
[[ -x "$(which tmux)" ]] && [[ -z "$TMUX" ]] && [[ -f "$HOME/.auto_tmux" ]] && [[ -z "$VSCODE_PID" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]&& exec tmux

# export ZSH="$HOME/.oh-my-zsh"
# export ZSH_THEME="afowler"

[[ -z "$DEBUG" ]] || echo "Loading omzsh"
# plugins=(git gh ruby)
# source "$ZSH/oh-my-zsh.sh"
# Non-omzsh prompt info.
autoload -Uz compinit promptinit
compinit
# autoload -Uz promptinit
# promptinit
# prompt default

[[ -n "$(which oh-my-posh)" ]] && eval "$(oh-my-posh --init --shell zsh --config "$HOME/code/dotfiles/omp.json")"

[[ -z "$DEBUG" ]] || echo "Setting FPATH"
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi
#
# # Required for completions
# fpath=($HOME/.zsh-completions $fpath)
# autoload -U compinit && compinit
#
# [[ -z "$DEBUG" ]] || echo "Kubectl completion"
# [[ ! -f "$(which kubectl)" ]] || source <(kubectl completion zsh)
# [[ -z "$DEBUG" ]] || echo "Github CLI completion"
# [[ ! -f "$(which gh)" ]] || eval "$(gh completion --shell=zsh)"

# NVM for managing versions of Node on the system.
export NVM_DIR="$HOME/.nvm"
# Load NVM is installed anywhere
_nvm_init() {
  if [ -s "$NVM_DIR/nvm.sh" ]; then
    echo "$NVM_DIR/nvm.sh"
    return
  fi
  if [ -s "/usr/local/opt/nvm/nvm.sh" ]; then
    echo "/usr/local/opt/nvm/nvm.sh"
    return
  fi
  if [ -x "$(which brew)" ] && [ -s "$(brew --prefix nvm)/nvm.sh" ]; then
    echo "$(brew --prefix nvm)/nvm.sh"
    return
  fi
}
alias nvm="unalias nvm; source \$(_nvm_init) ; nvm"

# Personal aliases.
[[ ! -f "$HOME/.aliases" ]] || source "$HOME/.aliases"

# Allows overriding with ~/.zshenv
[[ -z "$NOTES_PATH" ]] && export NOTES_PATH="$HOME/icloud/vnotes/"
compdef "_files -W $NOTES_PATH" n
# Allows overriding with ~/.zshenv
[[ -z "$BLOG_PATH" ]] && export BLOG_PATH="$HOME/code/github/exegeteio/exegete.io/_posts"
compdef "_files -W $BLOG_PATH" b

# Prettier Docker commands, parallel builds.
export DOCKER_BUILDKIT=1
# Allow connect back to rails from inside Docker.
export RAILS_DEVELOPMENT_HOSTS=host.docker.internal,localhost,.ngrok.io

# Only set the port if not already set.  Good for devcontainers.
[[ -z "$PORT" ]] && export PORT=3000

[[ -z "$DEBUG" ]] || echo "Loading fzf"
if [[ -f ~/.fzf.zsh ]]; then
  FZF="$(which fzf)"
  source "$HOME/.fzf.zsh"
fi
export FZF
[[ -z "$TMUX" ]] || export FZF_TMUX_OPTS="-p 40%"
[[ -f ~/.asdf/asdf.sh ]] && source "$HOME/.asdf/asdf.sh"

#########
# vi mode
#########

bindkey -v

# switch to command mode with jj
bindkey '^j' vi-cmd-mode

# `v` is already mapped to visual mode, so we need to use a different key to
# open Vim
bindkey -M vicmd "^V" edit-command-line

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

# incremental search in insert mode
bindkey "^F" history-incremental-search-forward
bindkey "^R" history-incremental-search-backward

# beginning search with arrow keys and j/k
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# beginning search in insert mode, redundant with the up/down arrows above
# but a little easier to press.
bindkey "^P" history-search-backward
bindkey "^N" history-search-forward

# incremental search in vi command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward
# navigate matches in incremental search
bindkey -M viins '^R' history-incremental-pattern-search-backward
bindkey -M viins '^F' history-incremental-pattern-search-forward

if [[ -n "$FZF" ]]; then
  bindkey "^R" fzf-history-widget
  bindkey "^T" fzf-file-widget
  bindkey -M vicmd '?' fzf-history-widget
  bindkey -M viins "^R" fzf-history-widget
  bindkey -M viins "^t" fzf-file-widget
fi

# Setup Golang
export GOPATH=$HOME/code/go
export GOBIN=$GOPATH/bin
export PATH=$GOBIN:$PATH
