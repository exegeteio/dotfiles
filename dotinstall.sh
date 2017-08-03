#!/bin/sh

ln -s `pwd`/vimrc $HOME/.vimrc
ln -s `pwd`/tmux.conf $HOME/.tmux.conf

echo source `pwd`/zshrc >> ~/.zshrc
