#!/usr/bin/env bash

dotfiles=$@
commands=$(ls $HOME/dotfiles/bin)

function deploy::dotfiles() {
  local i=0
  for file in ${dotfiles[@]}; do
    if [ ! -e $HOME/$file ]; then
      (( i++ ))
      ln -s $HOME/dotfiles/$file $HOME/$file
      [[ $? = 0 ]] && echo "+ linked: $file"
    fi
  done
  [ $i = 0 ] && echo "All dotfiles are already linked."
}

function deploy::commands() {
  local j=0
  for cmd in ${commands[@]}; do
    if [ ! -x $HOME/dotfiles/bin/$cmd ]; then
      (( j++ ))
      chmod a+x ~/dotfiles/bin/$cmd
      [[ $? = 0 ]] && echo "+ grant execute permission: $cmd" || echo "! failed to make it excutable: $cmd"
    fi
  done
  if [ $j = 0 ]; then
    echo "All commands are already excutable."
  fi
}

deploy::dotfiles
deploy::commands
