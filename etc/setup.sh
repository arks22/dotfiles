#!/bin/sh


#brewとかnodeのインストールとかを書きたい
#そのうち書く



#brewのインストール
install_homebrew() {
  emojify "Installing Homebrew :beer:  ..."
}

install_linuxbrew() {
  emojify "Installing linuxbrew :beer: ..."
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



#zplugのインストール
if [ ! -e ~/.zplug ]; then
  curl -fLo ~/.zplug/zplug --create-dirs git.io/zplug
  source ~/.zplug/zplug && zplug update --self
fi

