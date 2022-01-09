#!/bin/bash

export PATH="$HOME/bin:$HOME/.brew/bin:$HOME/go/bin:$HOME/.rbenv/bin:/usr/local/opt/python@3.8/bin:$PATH"
export CDPATH="$CDPATH:$HOME:$HOME/code/:$HOME/code/github/:$HOME/code/github/exegeteio/:$HOME/code/gitlab/:$HOME/Desktop/"

[[ -x "$(which tmux)" ]] && [[ -z "$TMUX" ]] && [[ -f "$HOME/.auto_tmux" ]] && [[ -z "$VSCODE_PID" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]&& exec tmux

# Kubectl command completion if available.
# [[ ! -f "$(which kubectl)" ]] || source <(kubectl completion bash)
# Set up environment variables for rbenv for Ruby version management.
[[ -z "$DEBUG" ]] || echo "Initializing rbenv"
alias rbenv="unalias rbenv; eval \"\$(rbenv init -)\"; rbenv"
# `gh`, the github CLI.
# [[ ! -f "$(which gh)" ]] || eval "$(gh completion --shell=bash)"

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

# Alias for my local journal.
export JOURNAL_PATH="$HOME/icloud/journal/"
export NOTES_PATH="$HOME/code/github/exegeteio/exegete.io/_posts"
# compdef "_files -W $NOTES_PATH" n

# Prettier Docker commands, parallel builds.
export DOCKER_BUILDKIT=1

# Only set the port if not already set.  Good for devcontainers.
[[ -z "$PORT" ]] && export PORT=3000

[[ -f "$HOME/.fzf.bash" ]] && source "$HOME/.fzf.bash"
[[ -f "$HOME/.asdf/asdf.sh" ]] && source "$HOME/.asdf/asdf.sh"
[[ -z "$TMUX" ]] || export FZF_TMUX_OPTS="-p 40%"

source "$HOME/.git-ps1"
__ps1() {
  local dir="${PWD##*/}" B P="$" \
    green='\[\e[32m\]' blue='\[\e[36m\]' \
    yellow='\[\e[33m\]' x='\[\e[0m\]'

  [[ "$EUID" == 0 ]] && P='#'
  [[ "$PWD" = / ]] && dir=/
  [[ "$PWD" = "$HOME" ]] && dir='~'

  B="$(__git_ps1)"

  PS1="$blue\h$green $dir$yellow$B $blue$P$x "
}

PROMPT_COMMAND="__ps1"

