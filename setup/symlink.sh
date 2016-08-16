#!/bin/sh

files=( .vimrc .tmux.conf zsh/.zshrc Brewfile)

for file in ${files[@]}; do
  ln -s -f ~/dotfiles/$file ~
done

ln -s -f ~/dotfiles/fish/config.fish ~/.config/fish
