#!/bin/sh

. ~/dotfiles/setup/symlink.sh

#install brew
if ! which brew; then
  if [ $(uname -s) = "Darwin" ]; then
    echo "Installing Homebrew ..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap homebrew/brewdler
    brew brewdle
  fi
fi

[ $SHELL = "/bin/zsh" ] || chsh -s /bin/zsh
zsh
