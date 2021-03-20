#!/bin/bash
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
DOTFILES_LOCATION=`cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd `
BACKUP_DIR=$HOME/.dotfiles-orig-$(date +%F)
BASH=$(which bash)
GIT=$(which git)

set -e

mkdir -p $BACKUP_DIR
mkdir -p $HOME/bin
mkdir -p $HOME/.config/
cp $PWD/bin/* $HOME/bin
[[ -d "$HOME/.config/lynx" ]] || ln -s $PWD/lynx $HOME/.config/lynx

# Make sure git and bash exist.
[[ -x "$BASH" ]] || (echo "You must have bash installed to proceed!"; exit 127)
[[ -x "$GIT" ]] || (echo "You must have git installed to proceed!"; exit 127)
# gcc is required for so much.
[[ -x "$(which gcc)" ]] || (echo "You must have gcc installed to proceed!"; exit 127)


## Here thar be functions!

## Start with Homebrew:
configure_brew () {
  if [ -d "$HOME/.brew/Homebrew" ]; then
    (cd $HOME/.brew/Homebrew && git pull -q)
  else
    git clone https://github.com/Homebrew/brew $HOME/.brew/Homebrew
    ln -s $HOME/.brew/Homebrew/bin $HOME/.brew/bin
  fi
  export PATH="$HOME/.brew/bin:$PATH" # Also in zshrc.
  BREW=$(which brew)
  [[ -x "$BREW" ]] || (echo "Could not find brew after install!"; exit 1)
}

configure_zsh () {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    (cd $HOME/.oh-my-zsh && git pull -q)
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Custom theme.
  cp codespaces.zsh-theme $ZSH_CUSTOM/themes/
  backup_and_link .zshrc zshrc
  [[ -z "$ZSH" ]] || source $HOME/.zshrc
}

configure_vim () {
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  backup_and_link .vimrc vimrc
  # vim +PlugInstall +qall
}

configure_aliases () {
  backup_and_link .aliases aliases.sh
}

move_file_to_backup () {
  if [[ -f $HOME/$1 ]]; then
    echo "Backing up $HOME/$1 to $BACKUP_DIR"
    mv $HOME/$1 $BACKUP_DIR/
  fi
  rm -f $HOME/$1
}

backup_and_link () {
  move_file_to_backup $1
  ln -s $DOTFILES_LOCATION/$2 $HOME/$1
}

configure_git () {
  backup_and_link .git git
  backup_and_link .gitconfig gitconfig
  backup_and_link .gitignore gitignore
}

function configure_tmux () {
  backup_and_link .tmux.conf tmux.conf
}


## Actually do stuff!
# configure_git

# case "$OSTYPE" in
#   darwin*)  $BASH macos.sh ;;
#   linux*)   $BASH linux.sh ;;
#   *)        echo "No detailed install for: $OSTYPE" ;;
# esac

configure_brew
configure_zsh
configure_vim
configure_tmux
configure_aliases
configure_git

source $HOME/.zshrc

# Cleanup:
unset backup_and_link
unset configure_git
unset configure_tmux
unset configure_vim
unset configure_zsh
unset move_file_to_backup
