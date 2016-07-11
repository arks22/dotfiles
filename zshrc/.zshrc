#source separated files
source_files=( zplug etc aliases functions tmux prompt )

for file in ${source_files[@]}; do
  source $HOME/dotfiles/zshrc/$file.zsh
done

#copy functions to ~/bin and give permission
ls -1 $HOME/dotfiles/zshrc/functions > /dev/null 2>&1 | while read line; do 
  cp $HOME/dotfiles/zshrc/functions/$line $HOME/bin/$line
  chmod a+x $HOME/bin/$line
done


if [ ! -z $TMUX ]; then
  echo "–––––––––––––––––––––––––– ${fg[blue]}tmux sessions${reset_color} –––––––––––––––––––––––––––"
  tmux list-sessions > /dev/null 2>&1 | while read line; do
    if [[ $line =~ "attached" ]]; then
      echo "${fg[yellow]}* ${reset_color}$line"
    else
      echo "  $line"
    fi
  done
  echo "––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––"
  echo "– – – – – – – – – – – – – – – – ${fg_bold[red]}TMUX${reset_color} – – – – – – – – – – – – – – – –"
else
  tmux_operation_interactively
fi
