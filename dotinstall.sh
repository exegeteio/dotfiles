#!/bin/sh

echo "Installing Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

ln -s `pwd`/vimrc $HOME/.vimrc
ln -s `pwd`/tmux.conf $HOME/.tmux.conf

echo source `pwd`/zshrc >> ~/.zshrc
