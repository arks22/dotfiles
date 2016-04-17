#!/bin/sh

#brewがない場合はinstall
if ! which -s brew; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

BREW_PACKAGES="
  zsh
  git
  tmux
  rbenv
"

for package in $BREW_PACKAGES; do
  if brew list -1 | grep -q "^$(basename $package)"; then
    echo "Skip: brew install ${package}"
  else
    echo "Instaling $package ..."
    brew install $package
  fi
done


#zplugがない場合はinstall
if [ ! -e ~/.zplug ]; then
  echo "Instaling zplug..."
  curl -fLo ~/.zplug/zplug --create-dirs git.io/zplug
  source ~/.zplug/zplug && zplug update --self
fi 


#nodebrewのinstall
if [ ! -e ~/.nodebrew ]; then
  echo "Instaling nodebrew..."
  curl -L git.io/nodebrew | perl - setup
fi
