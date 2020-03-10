#!/bin/sh
ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

echo "Installing Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

echo "Installing vim-plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Done!  Run :PlugInstall within vim to install plugins."

ln -s `pwd`/vimrc $HOME/.vimrc
ln -s `pwd`/tmux.conf $HOME/.tmux.conf
ln -s `pwd`/p10k.zsh $HOME/.p10k.zsh
cat `pwd`/gitconfig >> $HOME/.gitconfig

echo source `pwd`/zshrc >> ~/.zshrc
