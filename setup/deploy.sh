#!/bin/bash

for file in $(ls ~/dotfiles/bin); do
  chmod a+x ~/dotfiles/bin/$file
done


files=( .vimrc .tmux.conf .zshrc )

for file in ${files[@]}; do
  ln -s -f ~/dotfiles/$file ~
done
