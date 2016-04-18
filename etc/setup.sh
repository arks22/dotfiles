#!/bin/sh

#brewとかのインストールとかを書きたい


#--------------------------------------------------------
#brewのインストール
install_homebrew() {
  echo "Installing Homebrew ..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

install_linuxbrew() {
  echo "まだlinuxbrewは書いてないよ ..."
}

if [ ! `which brew` ]; then
  if [ $(uname -s) == "Darwin" ]; then
    install_homebrew
  else
    install_linuxbrew
  fi
else
  echo "Already Installed brew."
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


chsh -s /bin/zsh


#--------------------------------------------------------
#zplugのインストール
if [ ! -e ~/.zplug ]; then
  echo "Installing zplug...."
  curl -fLo ~/.zplug/zplug --create-dirs git.io/zplug
  source ~/.zplug/zplug && zplug update --self
else
  echo "Already Installed zplug."
fi
#--------------------------------------------------------


source ~/dotfiles/etc/install.sh

source ~/.zshrc
