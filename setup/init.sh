#!/bin/sh

#install brew
if [ ! `which brew` ]; then
  if [ $(uname -s) == "Darwin" ]; then
    echo "Installing Homebrew ..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
fi

fpath=(~/dotfiles/bin(N-/) $fpath)

source ~/dotfiles/setup/symlink.sh

brew tap homebrew/brewdler
brew brewdle

#[ $SHELL = "/bin/zsh" ] || chsh -s /bin/zsh
#zsh
