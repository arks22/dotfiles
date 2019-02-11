#!/usr/bin/env bash

dotfiles=$@

while true; do
  read -n 1 -p "dotmanager: remove dotfiles? [n/y]: " answer
  echo
  case $answer in
    "y" ) 
      for file in ${dotfiles[@]}; do
        unlink ~/$file && echo "- unlinked : $file"
      done
      rm -rf ~/dotfiles
      echo "dotfiles were removed."
      echo "To install again, excute \"curl -L raw.github.com/arks22/dotfiles/master/setup/install.bash | bash\"."
      echo "More information about dotfiles : https://github.com/arks22/dotfiles"
    ;;
    "n" ) exit 0 ;;
    * ) echo "Please press y(yes) or n(no)" ;;
  esac
done

