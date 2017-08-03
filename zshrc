export ZSH_THEME="blinks"
plugins=(git docker rails ruby elixir phoenix)
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  alias e="vim"
else
  export EDITOR='vim'
  alias e="code"
fi

# Applies aliases file when it exists
cd() {
  builtin cd $*
  if [ -f "aliases" ]
  then
    . ./aliases
    echo "Applied alieses file"
  fi
}
cd $(pwd)

# Time download with curl.
alias curltime='curl -w "Download Speed: %{speed_download} bps\nConnect:  %{time_connect} s\nStart Transfer: %{time_starttransfer} s\nTotal Time: %{time_total} s\n"'
