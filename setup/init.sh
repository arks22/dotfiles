#!/bin/sh

#install brew
if [ ! `which brew` ]; then
  if [ $(uname -s) == "Darwin" ]; then
    echo "Installing Homebrew ..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
fi

[ -e ~/bin ] || mkdir ~/bin

brew tap homebrew/brewdler
brew brewdle

fpath=(~/bin(N-/) $fpath)

source ~/dotfiles/setup/symlink.sh

[ $SHELL = "/bin/zsh" ] || chsh -s /bin/zsh

zsh
