# Set up SSH Agent
# Poached from:  https://code.visualstudio.com/docs/remote/containers#_using-ssh-keys
if [ -d "$HOME/.ssh" ]; then
  if [ -z "$SSH_AUTH_SOCK" ]; then
    # Check for a currently running instance of the agent
    if [ -z "$SSH_AGENT_PID" ] && source ~/.ssh/ssh-agent
    _agent="$(ps -p $SSH_AGENT_PID &>-)"
    if [ -z "$?" ]; then
      echo "Launging new SSH Agent..."
      # Launch a new instance of the agent
      ssh-agent -s &> ~/.ssh/ssh-agent
      source ~/.ssh/ssh-agent
    fi
  fi
  _keys="$(ssh-add -l)"
  if [ "$?" = "1" ]; then
    echo "No SSH keys found in ssh-agent"
    # ssh-add
  fi
fi

# Preferred editor for local and remote sessions
if [ "$TERM_PROGRAM" = "vscode" ]; then
  export EDITOR='code -wr'
  export EDITOR_ARGS='code.args'
else
  export EDITOR='vim'
  export EDITOR_ARGS='vi.args'
fi
alias e="$EDITOR"
export PAGER="less -r"

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

# NVM for managing versions of Node on the system.
export NVM_DIR="$HOME/.nvm"
# Load NVM is installed anywhere
alias nvm="unalias nvm; eval \"\$(< $NVM_DIR/nvm.sh)\"; nvm"
_detect_nvm() {
  if [ -z "$NVM_BIN" ]; then
    if [ -f "package.json" ]; then
      echo "Detected nvm..."
      unalias nvm 2>/dev/null
      eval "$(< $NVM_DIR/nvm.sh)"
    fi
  fi
}
_detect_nvm

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
  _detect_nvm
}

[ ! -f "./aliases" ] || source ./aliases

alias a="source ./aliases"
alias ls="ls --color=auto"
alias ll="ls -lh"
alias gf="git fetch --all -p"

# Alias for checking out potential phishing links.
alias phish="http --follow -p hH"

w() { for (( ; ; )) do clear; $*; sleep 1; done; }

alias '?'=duck
alias '??'=google
alias r=bin/rails
