#!/bin/sh

files=( vim/.vimrc vim/.vim .tmux.conf zsh/.zshrc)

for file in ${files[@]}; do
  ln -s -f ~/dotfiles/$file ~
done

ln -s -f ~/dotfiles/fish/config.fish ~/.config/fish

#put symbolic links to ~/bin and grant permissions
[ -e ~/bin ] || mkdir ~/bin

for file in $(ls ~/dotfiles/functions); do
  ln -f ~/dotfiles/functions/$file ~/bin/$file
  chmod a+x ~/bin/$file
done
