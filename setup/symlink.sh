#!/bin/bash

echo "putting symlink..."

files=( .vimrc .tmux.conf .zshrc )

for file in ${files[@]}; do
  ln -s -f ~/dotfiles/$file ~
done
