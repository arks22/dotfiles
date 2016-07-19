#!/bin/zsh

files=( vimrc/.vimrc vim/.vim tmux/.tmux.conf zsh/.zshrc)

for file in ${files[@]}; do
  ln -s -f ~/dotfiles/$file ~
done
