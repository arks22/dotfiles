#!/bin/zsh

files=( vim/.vimrc vim/.vim tmux/.tmux.conf zsh/.zshrc zsh/dircolors )

for file in ${files[@]}; do
  ln -s -f ~/dotfiles/$file ~
done
