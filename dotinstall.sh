#!/bin/sh

echo "Installing Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Installing vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall

ln -s `pwd`/vimrc $HOME/.vimrc
ln -s `pwd`/tmux.conf $HOME/.tmux.conf
cat `pwd`/gitconfig >> $HOME/.gitconfig

echo source `pwd`/zshrc >> ~/.zshrc
