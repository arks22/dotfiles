#!/bin/bash

bash ~/dotfiles/setup/symlink.sh

#install brew
if ! which brew ; then
  if [ $(uname -s) = "Darwin" ]; then
    ln -s -f ~/dotfiles/setup/Brewfile ~
    echo "Installing Homebrew ..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew doctor
    brew tap Homebrew/bundle
    brew bundle
  else [ $(uname -s) = "Linux" ]; then
    echo "Install packages with apt-get, please put your password"
    packages=(curl git ruby zsh vim)
    sudo apt-get install $packages
  fi
fi

echo "Change shell to zsh, please put ypur password"
[ $SHELL = "/bin/zsh" ] || chsh -s /bin/zsh
zsh
