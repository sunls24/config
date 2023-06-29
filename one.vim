#!/usr/bin/env bash

set -e

rm -rf "$HOME"/.vim*
sudo rm -rf /root/.vimrc /root/.vim

echo "get basic.vim"
curl -s https://raw.githubusercontent.com/amix/vimrc/master/vimrcs/basic.vim -o "$HOME"/.vimrc

vimdir=$HOME/.vim/colors
[ ! -d "$vimdir" ] && mkdir -p "$vimdir"

echo "get one.vim"
curl -s https://raw.githubusercontent.com/rakr/vim-one/master/colors/one.vim -o "$vimdir"/one.vim

sed -i 's|desert|one|' "$HOME"/.vimrc
sed -i 's|dark|light|' "$HOME"/.vimrc

cat >>.vimrc <<EOF

if (has("termguicolors"))
    set termguicolors
endif
EOF

echo "ln to root"
sudo ln -s "$HOME"/.vim /root/.vim
sudo ln -s "$HOME"/.vimrc /root/.vimrc

echo "✅ successful"
