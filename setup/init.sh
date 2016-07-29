#!/bin/sh


#install brew
if [ ! `which brew` ]; then
  if [ $(uname -s) == "Darwin" ]; then
    echo "Installing Homebrew ..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
else
  echo "Already Installed brew."
fi

[ -e ~/bin ] || mkdir ~/bin

cd ~/dotfiles/etc
brew tap homebrew/brewdler
brew brewdle
cd ~

fpath=(~/bin(N-/) $fpath)

source ~/dotfiles/etc/install.sh

if [ ! $SHELL = "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi

zsh
