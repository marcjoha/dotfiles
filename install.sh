#!/bin/bash
CWD=`pwd`
ln -sf $CWD/chunkwmrc ~/.chunkwmrc
ln -sf $CWD/hyper.js  ~/.hyper.js
mkdir -p ~/.config/kitty/
ln -sf $CWD/kitty.conf ~/.config/kitty/kitty.conf
ln -sf $CWD/skhdrc  ~/.skhdrc
ln -sf $CWD/vimrc  ~/.vimrc

