#!/usr/bin/env bash
SOURCE_PATH="$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)"
BACKUP_DIR="$HOME/.dotfiles-orig-$(date +%F)"
BASH="$(which bash)"

set -e

# Build 
./build

mkdir -p "$HOME/.config/"
DOTFILES_PATH="$HOME/.config/dotfiles"
rm -f "$DOTFILES_PATH"
ln -s "$SOURCE_PATH" "$DOTFILES_PATH"

# Make sure git and bash exist.
[[ -x "$BASH" ]] || (echo "You must have bash installed to proceed!"; exit 127)

## Here thar be functions!

configure_zsh () {
  backup_and_link .zshrc zshrc
  # Setup Fuzzy Finder
  if [[ -x "$(which brew)" ]] && [[ -x "$(which fzf)" ]]; then
    "$(brew --prefix fzf)"/install --all
  fi
}

configure_bash () {
  backup_and_link .bashrc bashrc

  # Setup Fuzzy Finder
  if [[ -f "$(which brew)" ]] && [[ -f "$(which fzf)" ]]; then
    "$(brew --prefix fzf)"/install --all
  fi
}

configure_vim () {
  mkdir -p "$HOME/.vim/autoload/"
  cp plug.vim "$HOME/.vim/autoload/"
  backup_and_link .vimrc vimrc
  [ -x "$(which vim)" ] && vim +PlugInstall +qall
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

function configure_railsrc () {
  backup_and_link .railsrc railsrc
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
echo "Configuring git..."
configure_git
echo "Configuring railsrc..."
configure_railsrc

# Cleanup:
unset backup_and_link
unset configure_git
unset configure_tmux
unset configure_vim
unset configure_zsh
unset configure_bash
unset move_file_to_backup
