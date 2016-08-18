#!/bin/bash

echo "putting symlink..."

files=( .vimrc .tmux.conf .zshrc setup/Brewfile )

for file in ${files[@]}; do
  ln -s -f ~/dotfiles/$file ~
done
