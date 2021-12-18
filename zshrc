# If running interactively, do not do anything.
[[ $- != *i*  ]] && return

export PATH="$HOME/bin:$HOME/.brew/bin:$HOME/go/bin/:/usr/local/opt/python@3.8/bin:$PATH"
export CDPATH="$CDPATH:$HOME:$HOME/code/:$HOME/code/github/:$HOME/code/github/exegeteio/:$HOME/code/gitlab/:$HOME/Desktop/"

[[ -x "$(which tmux)" ]] && [[ -z "$TMUX" ]] && [[ -f "$HOME/.auto_tmux" ]] && [[ -z "$VSCODE_PID" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]&& exec tmux

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="afowler"

# plugins=(git)
source $ZSH/oh-my-zsh.sh

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# Kubectl command completion if available.
[[ ! -f "$(which kubectl)" ]] || source <(kubectl completion zsh)
# Set up environment variables for rbenv for Ruby version management.
[[ ! -f "$(which rbenv)" ]] || eval "$(rbenv init -)"
# `gh`, the github CLI.
[[ ! -f "$(which gh)" ]] || eval "$(gh completion --shell=zsh)"

# NVM for managing versions of Node on the system.
export NVM_DIR="$HOME/.nvm"
# Load NVM is installed anywhere
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Personal aliases.
[[ ! -f "$HOME/.aliases" ]] || source $HOME/.aliases

# Alias for my local journal.
export JOURNAL_PATH="$HOME/Desktop/journal/"
export NOTES_PATH="$HOME/code/exegete.io/_posts"
compdef "_files -W $NOTES_PATH" n

# Prettier Docker commands, parallel builds.
export DOCKER_BUILDKIT=1

# Only set the port if not already set.  Good for devcontainers.
[[ -z "$PORT" ]] && export PORT=3000

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ -z "$TMUX" ]] || export FZF_TMUX_OPTS="-p 40%"

