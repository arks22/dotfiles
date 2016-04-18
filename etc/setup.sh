#!/bin/sh

source ~/dotfiles/etc/install.sh

#brewとかのインストールとかを書きたい


#--------------------------------------------------------
#brewのインストール
install_homebrew() {
  emojify "Installing Homebrew :beer:  ..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_linuxbrew() {
  emojify "まだlinuxbrewは書いてないよ :beer: ..."
}

if [ ! `which brew` ]; then
  if [ $(uname -s) == "Darwin" ]; then
    install_homebrew
  else
    install_linuxbrew
  fi
else
  emojify "Already Installed brew :beer: ."
fi
#--------------------------------------------------------


#--------------------------------------------------------
#brewでいろいろインストール
brew tap homebrew/brewdler
brew brewdle
#--------------------------------------------------------


#--------------------------------------------------------
#nodebrewのインストール
install_nodebrew() {
  echo Installing nodebrew...
  curl -L git.io/nodebrew | perl - setup
  echo "export PATH=$HOME/.nodebrew/current/bin:$PATH" > ~/.zshenv
}

if [ ! `which node` ]; then
  install_nodebrew
elif [ ! -e ~/.nodebrew ]; then
  echo "Removing node.js..."
  install_nodebrew
else
  echo "Already Installed nodebrew."
fi
#--------------------------------------------------------


#--------------------------------------------------------
#zplugのインストール
if [ ! -e ~/.zplug ]; then
  curl -fLo ~/.zplug/zplug --create-dirs git.io/zplug
  source ~/.zplug/zplug && zplug update --self
else
  echo "Already Installed zplug."
fi

#--------------------------------------------------------
chsh -s /bin/zsh

source ~/.zshrc
