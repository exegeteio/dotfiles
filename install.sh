#!/bin/bash
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
DOTFILES_LOCATION=`cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd `
BACKUP_DIR=$HOME/.dotfiles-orig-$(date +%F)
mkdir -p $BACKUP_DIR

## Here thar be functions!

configure_zsh () {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
  backup_and_link .p10k.zsh p10k.zsh
  backup_and_link .zshrc zshrc
}

configure_vim () {
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  backup_and_link .vimrc vimrc
  vim +PlugInstall +qall
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
  if [[ -z $(git config --global user.name) ]]; then
    read -p "Name for .gitconfig: "
    git config --global user.name "$REPLY"
  fi

  if [[ -z $(git config --global user.email) ]]; then
    read -p "Email for .gitconfig: "
    git config --global user.email "$REPLY"
  fi

  if [[ -z $(git config --global --get-regex alias.\*) ]]; then
    echo "Adding aliases to $HOME/.gitconfig"
    cat $DOTFILES_LOCATION/gitconfig >> $HOME/.gitconfig
  else
    read -p "Aliases exist in $HOME/.gitconfig - Overwrite? " -n 1
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      git config --global --remove-section alias 2>/dev/null
      cat $DOTFILES_LOCATION/gitconfig >> $HOME/.gitconfig
    fi
  fi
}

function configure_tmux () {
  read -p "Enable tmux in every shell session? " -n 1
  echo ""
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Delete this file to stop launching tmux when zsh starts" > $HOME/.auto_tmux
  fi
  backup_and_link .tmux.conf tmux.conf
}


## Actually do stuff!
configure_git

case "$OSTYPE" in
  darwin*)  /bin/bash macos.sh ;;
  linux*)   /bin/bash linux.sh ;;
  *)        echo "No detailed install for: $OSTYPE" ;;
esac

configure_zsh
configure_vim
configure_tmux

# Cleanup:
unset move_file_to_backup
unset backup_and_link
unset configure_git
unset configure_tmux
unset configure_vim
unset configure_zsh