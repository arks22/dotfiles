#tmux config

tmux_new_sesssion() {
  tmux new-session \; split-window -vp 23 \; select-pane -t 1 \; split-window -h \
    \; send-keys -t 0 "vim" C-m \; send-keys -t 1 "ls" C-m \; send-keys -t 2 "ls" C-m
}


tmux_operation() {
  answer=$(tmux_operation_choices | fzf-tmux --ansi --prompt="Tmux >")
  if [ ! "$answer" = "cancel" ]; then
    if [[ "$answer" =~ "new session" ]]; then
      tmux_new_sesssion
    elif [[ "$answer" =~ "new window" ]]; then
      tmux new-window
    elif [ "$answer" = "kill sessions" ]; then
      tmux_kill_session
    elif [ "$answer" = "kill windows" ]; then
      tmux_kill_window
    elif [[ "$answer" =~ "switch" ]] && [[ ! "$answer" =~ "new window" ]]; then
      tmux select-window -t $(echo "$answer" | awk '{print $4}' | sed "s/://g")
    else
      tmux attach -t $(echo "$answer" | awk '{print $4}' | sed 's/://')
    fi
  fi
}


tmux_operation_choices() {
  if [ -z $TMUX ]; then
    tmux list-sessions | sed "/no server/d" | while read line; do
      [[ ! "$line" =~ "attached" ]] || line="${fg[green]}$line${reset_color}"
      echo "${fg[green]}attach${reset_color} ==> [ "$line" ]"
    done
    echo "${fg[green]}create${reset_color} ==> [ ${fg_bold[default]}new session${reset_color} ]"
  else
    tmux list-windows | sed "/active/d" | while read line; do
      line=$(echo "$line" | awk '{print $1 " " $2 " " $3 " " $4 " " $5}')
      echo  "${fg[cyan]}switch${reset_color} ==> [ $line ]"
    done
    echo  "${fg[cyan]}switch${reset_color} ==> [ ${fg_bold[default]}new window${reset_color} ]"
    echo "kill windows"
  fi
  [[ "$(tmux list-sessions)" =~ "no server" ]] || echo "kill sessions"
  echo "${fg[blue]}cancel${reset_color}"
}


tmux_kill_session() {
  answer=$(tmux_kill_session_choices | fzf-tmux --ansi --prompt="Tmux >")
  if [ "$answer" = "cancel" ]; then
    tmux_operation
  elif [[ "$answer" =~ "Server" ]]; then
    tmux kill-server
    tmux_operation
  else
    tmux kill-session -t $(echo "$answer" | awk '{print $4}' | sed "s/://g")
    if $(tmux has-session); then
      tmux_kill_session
    else
      tmux_operation
    fi
  fi
}


tmux_kill_session_choices() {
  list_sessions=$(tmux list-sessions);
  echo "$list_sessions" | while read line; do
    [[ "$line" =~ "attached" ]] && line="${fg[green]}"$line"${reset_color}"
    echo  "${fg[red]}kill${reset_color} ==> [ "$line" ]"
  done
  [ $(echo "$list_sessions" | grep -c '')  = 1 ] || echo "${fg[red]}kill${reset_color} ==> [ ${fg[red]}Server${reset_color} ]"
  echo "${fg[blue]}cancel${reset_color}"
}


tmux_kill_window() {
  answer=$(tmux_kill_window_choices | fzf-tmux --ansi --prompt="Tmux >")
  if [ "$answer" = "cancel" ]; then
    tmux_operation
  else
    tmux kill-window -t $(echo "$answer" | awk '{print $4}' | sed "s/://g")
    tmux_kill_window
  fi
}


tmux_kill_window_choices() {
  tmux list-windows | while read line; do
    if [[ $line =~ "active" ]]; then
      echo " ${fg[red]}kill${reset_color} ==> ${fg[green]}[ $(echo $line | awk '{print $1 " " $2 " " $3 " " $4 " " $5}') (active) ${reset_color}]"
    else
      echo " ${fg[red]}kill${reset_color} ==> [ $(echo $line | awk '{print $1 " " $2 " " $3 " " $4 " " $5}') ]"
    fi
  done
  echo "${fg[blue]}cancel${reset_color}"
}



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
  tmux_operation
fi
