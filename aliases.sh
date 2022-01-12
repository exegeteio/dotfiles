# Set up SSH Agent
# Poached from:  https://code.visualstudio.com/docs/remote/containers#_using-ssh-keys
if [ -d "$HOME/.ssh" ]; then
  if [ -z "$SSH_AUTH_SOCK" ]; then
    # Check for a currently running instance of the agent
    RUNNING_AGENT="`ps -ax | grep 'ssh-agent -s' | grep -v grep | wc -l | tr -d '[:space:]'`"
    if [ "$RUNNING_AGENT" = "0" ]; then
      # Launch a new instance of the agent
      ssh-agent -s &> ~/.ssh/ssh-agent
    fi
    eval `cat ~/.ssh/ssh-agent`
  fi
fi

# Preferred editor for local and remote sessions
if [ "$TERM_PROGRAM" = "vscode" ]; then
  export EDITOR='code -wr'
elif [ -n $TMUX ]; then
  export EDITOR='vim'
elif [ -n $SSH_CONNECTION ]; then
  export EDITOR='vim'
else
  export EDITOR='code -wr'
fi

[[ -z "$DEBUG" ]] || echo "Initializing rbenv"
alias rbenv="unalias rbenv; eval \"\$(rbenv init -)\"; rbenv"
_detect_rbenv() {
  if [ -z "$RBENV_SHELL" ]; then
    if [ -f ".ruby-version" ] || [ -f ".ruby-gemset" ]; then
      echo "Detected rbenv..."
      unalias rbenv 2>/dev/null
      eval "$(rbenv init -)"
    fi
  fi
}
_detect_rbenv

_detect_aliases() {
  if [ -f "aliases" ]; then
    echo "aliases file available"
  fi
}
_detect_aliases

# Applies aliases file when it exists
cd() {
  builtin cd $*
  _detect_aliases
  _detect_rbenv
}

[ ! -f "./aliases" ] || source ./aliases

alias a="source ./aliases"
alias ll="ls -lh"
alias gf="git fetch --all -p"

# Alias for checking out potential phishing links.
alias phish="http --follow -p hH"

w() { for (( ; ; )) do clear; $*; sleep 1; done; }

alias '?'=duck
alias '??'=google
alias r=bin/rails
