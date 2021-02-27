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
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  alias e="vim"
else
  export EDITOR='code -wr'
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
alias ll="ls -lh"
alias gf="git fetch --all -p"

journal() {
  [[ -d $JOURNAL_PATH ]] || git clone git@github.com:/exegeteio/journal.git $JOURNAL_PATH
  cd $JOURNAL_PATH
  git pull
  mkdir -p $(date +%Y/%m)
  vi $(date +%Y/%m/%d.md)
  git add . && git commit -m $(date +%F) && git push &
}
# Alias for checking out potential phishing links.
alias phish="http --follow -p hH"

duck() { lynx "https://duckduckgo.com/lite?q=$*" }
cht() { http --body "https://cht.sh/$*" | less }
w() { for (( ; ; )) do clear; $*; sleep 1; done }

alias '?'=duck
