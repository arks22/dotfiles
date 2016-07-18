#!/bin/zsh

files=( vimrc/.vimrc vimrc/.vim tmux/.tmux.conf zshrc/.zshrc)

for file in ${files[@]}; do
  ln -s -f ~/dotfiles/$file ~
done
