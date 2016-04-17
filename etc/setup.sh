#!/bin/sh

#brewとかnodeのインストールとかを書きたい
#そのうち書く


if [ $(uname -s) == "Darwin" ]; then
  emojify "Installing Homebrew :beer: ..."
elif
  emojify "Installing linaxbrew :beer: ..."
fi


#nodebrewのインストール
if [ ! `which node` ]; then
  echo Installing nodebrew...
  curl -L git.io/nodebrew | perl - setup
  echo "export PATH=$HOME/.nodebrew/current/bin:$PATH" > ~/.zshenv
elif [ ! -e ~/.nodebrew ]
  echo "Removing node.js..."
  echo "Installing nodebrew..."
fi

