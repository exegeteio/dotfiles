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
export NOTES_PATH="$HOME/icloud/vnotes/"
export BLOG_PATH="$HOME/code/github/exegeteio/exegete.io/_posts"
# compdef "_files -W $NOTES_PATH" n

# Prettier Docker commands, parallel builds.
export DOCKER_BUILDKIT=1

# Only set the port if not already set.  Good for devcontainers.
[[ -z "$PORT" ]] && export PORT=3000

[[ -f "$HOME/.fzf.bash" ]] && source "$HOME/.fzf.bash"
[[ -f "$HOME/.asdf/asdf.sh" ]] && source "$HOME/.asdf/asdf.sh"
[[ -z "$TMUX" ]] || export FZF_TMUX_OPTS="-p 40%"

[[ -n "$(which oh-my-posh)" ]] && eval "$(oh-my-posh --init --shell bash --config "$HOME/code/dotfiles/omp.json")"
