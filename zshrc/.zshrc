#source separated files
source_files=( zplug etc aliases functions prompt )

for file in ${source_files[@]}; do
  source ~/dotfiles/zshrc/$file.zsh
done

#put symbolic links to ~/bin and grant permissions
link_functions() {
  if [ ! -e ~/bin ]; then
    mkdir ~/bin
  fi
  ls -1 ~/dotfiles/zshrc/functions > /dev/null 2>&1 | while read line; do 
    ln -f ~/dotfiles/zshrc/functions/$line ~/bin/$line
    chmod a+x ~/bin/$line
  done
}

link_functions


if [ ! -z $TMUX ]; then
  echo "–––––––––––––––––– ${fg[blue]}tmux windows${reset_color} ––––––––––––––––––"
  tmux list-windows | while read line; do
    if [[ $line =~ "active" ]]; then
      echo "${fg[yellow]}*${reset_color} $(echo $line | awk '{print $1 " " $2 " " $3 " " $4 " " $5}')"
    else
      echo "  $(echo $line | awk '{print $1 " " $2 " " $3 " " $4 " " $5}')"
    fi
  done
  echo "––––––––––––––––––––––––––––––––––––––––––––––––––"
  echo "– – – – – – – – – – – ${fg_bold[red]}TMUX${reset_color} – – – – – – – – – – – –"
else
  tmuximum
fi
