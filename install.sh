#!/bin/bash
DOTFILES_PATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
BACKUP_DIR="$HOME/.dotfiles-orig-$(date +%F)"
BASH="$(which bash)"
GIT="$(which git)"

set -e

./build

mkdir -p "$HOME/.config/"
[[ -d "$HOME/bin/" ]] || ln -s "$DOTFILES_PATH/bin" "$HOME/bin"

# Make sure git and bash exist.
[[ -x "$BASH" ]] || (echo "You must have bash installed to proceed!"; exit 127)
[[ -x "$GIT" ]] || (echo "You must have git installed to proceed!"; exit 127)
# gcc is required for so much.
[[ -x "$(which gcc)" ]] || (echo "You must have gcc installed to proceed!"; exit 127)


## Here thar be functions!

configure_zsh () {
  if [ -d "$HOME/.oh-my-zsh" ]; then
    echo Oh My Zsh already installed.
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Custom theme.
  backup_and_link .zshrc zshrc

  # Setup Fuzzy Finder
  if [[ -f "$(which brew)" ]] && [[ -f "$(which fzf)" ]]; then
    "$(brew --prefix fzf)"/install --all
  fi
}

configure_bash () {
  backup_and_link .bashrc bashrc
  backup_and_link .git-ps1 git-ps1.sh

  # Setup Fuzzy Finder
  if [[ -f "$(which brew)" ]] && [[ -f "$(which fzf)" ]]; then
    "$(brew --prefix fzf)"/install --all
  fi
}

configure_vim () {
  curl -fLo "$HOME/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  backup_and_link .vimrc vimrc
  vim +PlugInstall +qall
}

configure_aliases () {
  backup_and_link .aliases aliases.sh
}

move_file_to_backup () {
  if [[ -f "$HOME/$1" ]]; then
    [ -d "$BACKUP_DIR" ] || mkdir -p "$BACKUP_DIR"
    echo "Backing up $HOME/$1 to $BACKUP_DIR"
    mv "$HOME/$1" "$BACKUP_DIR/"
    rm -f "$HOME/$1"
  fi
}

backup_and_link () {
  move_file_to_backup "$1"
  echo "Linking $2 to $1"
  ln -s "$DOTFILES_PATH/$2" "$HOME/$1"
}

configure_git () {
  backup_and_link .git git
  backup_and_link .gitconfig gitconfig
  backup_and_link .gitignore gitignore
}

function configure_tmux () {
  backup_and_link .tmux.conf tmux.conf
}


# case "$OSTYPE" in
#   darwin*)  $BASH macos.sh ;;
#   linux*)   $BASH linux.sh ;;
#   *)        echo "No detailed install for: $OSTYPE" ;;
# esac

echo "Configuring ZSH..."
configure_zsh
echo "Configuring Bash..."
configure_bash
echo "Configuring VIM..."
configure_vim
echo "Configuring tmux..."
configure_tmux
echo "Configuring Aliases..."
configure_aliases
echo "Configuring git..."
configure_git

# Cleanup:
unset backup_and_link
unset configure_git
unset configure_tmux
unset configure_vim
unset configure_zsh
unset configure_bash
unset move_file_to_backup
