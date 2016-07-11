
#source separated files
files=( zplug etc aliases functions tmux git prompt )

for file in ${files[@]}; do
  source ~/dotfiles/zshrc/$file.zsh
done


#
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
