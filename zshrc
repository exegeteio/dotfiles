# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If running interactively, do not do anything.
[[ $- != *i*  ]] && return
[[ -x "$(which tmux)" ]] && [[ -z "$TMUX" ]] && [[ -f "$HOME/.auto_tmux" ]] && exec tmux

export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git)
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  alias e="vim"
else
  export EDITOR='code -wn'
  alias e="code"
fi

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
[[ ! -f "$(which kubectl)" ]] || source <(kubectl completion zsh)

# Applies aliases file when it exists
cd() {
  builtin cd $*
  if [ -f "aliases" ]
  then
    . ./aliases
    echo "Applied aliases file"
  fi
}

[[ ! -f "./aliases" ]] || source ./aliases

alias a="source ./aliases"
alias n="(cd ~/code/notes && vi README.md)"

export PORT=3000

