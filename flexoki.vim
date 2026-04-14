#!/usr/bin/env bash

set -e

rm -rf "$HOME"/.vim*
sudo rm -rf /root/.vimrc /root/.vim

echo "get basic.vim"
curl -s https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/basic.vim -o "$HOME"/.vimrc

vimdir=$HOME/.vim/colors
[ ! -d "$vimdir" ] && mkdir -p "$vimdir"

echo "get flexoki_light.vim"
curl -s https://raw.githubusercontent.com/kepano/flexoki/refs/heads/main/vim/flexoki_light.vim -o "$vimdir"/flexoki.vim

sed -i 's|desert|flexoki|' "$HOME"/.vimrc
sed -i 's|dark|light|' "$HOME"/.vimrc

echo "ln to root"
sudo ln -s "$HOME"/.vim /root/.vim
sudo ln -s "$HOME"/.vimrc /root/.vimrc

echo "✅ successful"
