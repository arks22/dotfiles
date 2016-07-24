#put symbolic links to ~/bin and grant permissions
[ -e ~/bin ] || mkdir ~/bin
for file in $(ls ~/dotfiles/zsh/functions); do
  ln -f ~/dotfiles/zsh/functions/$file ~/bin/$file
  chmod a+x ~/bin/$file
done

#source separated files
for file in $(ls ~/dotfiles/zsh/zshrc); do
  source ~/dotfiles/zsh/zshrc/$file
done

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
  tmux_operation_interactively
fi
