#!/bin/sh

#brewとかのインストールとかを書きたい


#--------------------------------------------------------
#brewのインストール

if [ ! `which brew` ]; then
  if [ $(uname -s) == "Darwin" ]; then
  echo "Installing Homebrew ..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  else
    echo "まだlinuxbrewは書いてないよ ..."
  fi
else
  echo "Already Installed brew."
fi
#--------------------------------------------------------



#--------------------------------------------------------
#brewでいろいろインストール
if [ `which brew` ]; then
  brew tap homebrew/brewdler
  brew brewdle
fi
#--------------------------------------------------------



#--------------------------------------------------------
#nodebrewのインストール
install_nodebrew() {
  echo Installing nodebrew...
  curl -L git.io/nodebrew | perl - setup
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



source ~/dotfiles/etc/install.sh

if [ ! $SHELL = "/bin/zsh" ]; then
  chsh -s /bin/zsh
fi

zsh
