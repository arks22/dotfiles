#!/bin/zsh

files=( vim/.vimrc vim/.vim .tmux.conf zsh/.zshrc)

for file in ${files[@]}; do
  ln -s -f ~/dotfiles/$file ~
done
