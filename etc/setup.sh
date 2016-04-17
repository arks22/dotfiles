#!/bin/sh

install_homebrew() {
  echo "YO"
}


if [ $(uname -s) == "Darwin" ]; then
  echo "Install Homebrew..."
  install_homebrew
fi
