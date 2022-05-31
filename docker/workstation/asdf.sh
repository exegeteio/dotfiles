#!/usr/bin/env bash

git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch "v0.8.1"
source $HOME/.asdf/asdf.sh

asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby latest
# asdf install ruby 2.6.8
asdf global ruby latest
