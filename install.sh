#!/bin/bash

SCRIPT_DIR=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

ln -sv $SCRIPT_DIR/vimrc ~/.vimrc
mkdir -p ~/.cache/vim/{swap,backup,undo}
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim


git clone git://github.com/tpope/vim-sensible.git  ~/.vim/bundle/vundle
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle



ln -sv $SCRIPT_DIR/xbindkeysrc ~/.xbindkeysrc
ln -sv $SCRIPT_DIR/Xresources ~/.Xresources
ln -sv $SCRIPT_DIR/xinitrc ~/.xinitrc
ln -sv ~/.xinitrc ~/.xsession

mkdir -p .xmonad
ln -sv $SCRIPT_DIR/xmonad-config/xmonad.hs ~/.xmonad/xmonad.hs

git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
