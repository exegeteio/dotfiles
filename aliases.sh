# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  alias e="vim"
else
  export EDITOR='code -wn'
  alias e="code"
fi

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
alias n="(cd ~/code/notes ; git pull -q & vi README.md)"
alias ls="ls -G"
alias ll="ls -lh"

alias '?'="lynx \"duckduckgo.com/lite?q=\$*\""