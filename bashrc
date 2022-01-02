export PATH="$HOME/bin:$HOME/.brew/bin:$HOME/go/bin:$HOME/.rbenv/bin:/usr/local/opt/python@3.8/bin:$PATH"
export CDPATH="$CDPATH:$HOME:$HOME/code/:$HOME/code/github/:$HOME/code/github/exegeteio/:$HOME/code/gitlab/:$HOME/Desktop/"

[[ -x "$(which tmux)" ]] && [[ -z "$TMUX" ]] && [[ -f "$HOME/.auto_tmux" ]] && [[ -z "$VSCODE_PID" ]] && [[ "$TERM_PROGRAM" != "vscode" ]]&& exec tmux

# Kubectl command completion if available.
[[ ! -f "$(which kubectl)" ]] || source <(kubectl completion bash)
# Set up environment variables for rbenv for Ruby version management.
[[ ! -f "$(which rbenv)" ]] || eval "$(rbenv init -)"
# `gh`, the github CLI.
[[ ! -f "$(which gh)" ]] || eval "$(gh completion --shell=bash)"

# NVM for managing versions of Node on the system.
NVM_DIR="$HOME/.nvm"
# Load NVM is installed anywhere
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"
[ -x "$(which brew)" ] && [ -s "$(brew --prefix nvm)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# Personal aliases.
[[ ! -f "$HOME/.aliases" ]] || source $HOME/.aliases

# Alias for my local journal.
export JOURNAL_PATH="$HOME/Desktop/journal/"
export NOTES_PATH="$HOME/code/github/exegeteio/exegete.io/_posts"
# compdef "_files -W $NOTES_PATH" n

# Prettier Docker commands, parallel builds.
export DOCKER_BUILDKIT=1

# Only set the port if not already set.  Good for devcontainers.
[[ -z "$PORT" ]] && export PORT=3000

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.asdf/asdf.sh ] && source ~/.asdf/asdf.sh
[[ -z "$TMUX" ]] || export FZF_TMUX_OPTS="-p 40%"

source $HOME/.git-ps1
__ps1() {
  local dir="${PWD##*/}" status="🔴" B P="$" \
    green='\[\e[32m\]' blue='\[\e[36m\]' \
    yellow='\[\e[33m\]' \
    r='\[\e[31m\]' g='\[\e[30m\]' h='\[\e[34m\]' \
    u='\[\e[33m\]' p='\[\e[34m\]' w='\[\e[35m\]' \
    b='\[\e[36m\]' x='\[\e[0m\]'

  [[ $EUID == 0 ]] && P='#' && u=$r && p=$u # root
  [[ $PWD = / ]] && dir=/
  [[ $PWD = "$HOME" ]] && dir='~'

  GIT_PS1_SHOWDIRTYSTATE=1
  B=$(__git_ps1)

  if [ $? = 0 ]; then
    status="🟢"
  fi

  PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
  PS1='[\033[01;34m\] \w \$\[\033[00m\] '
  PS1="$status $blue\h$green $dir$yellow$B $blue$P$x "
}

PROMPT_COMMAND="__ps1"
export BASH_SILENCE_DEPRECATION_WARNING=1
