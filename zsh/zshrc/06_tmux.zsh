#tmux

tmux_new_sesssion() {
  if [ ! -z $TMUX ]; then
    NEST_TMUX="1"
  fi
  tmux new-session \; split-window -vp 23 \; select-pane -t 1 \; split-window -h \
    \; send-keys -t 0 "vim" C-m \
    \; send-keys -t 1 "ls" C-m \
    \; send-keys -t 2 "ls" C-m
}

tmux_operation_interactively() {
  if [ -z $TMUX ]; then
    answer=$(tmux_operation_interactively_choices | fzf-tmux --ansi --prompt="Tmux >")
  else
    answer=$(tmux_operation_interactively_in_tmux_choices | fzf-tmux --ansi --prompt="Tmux >")
  fi
  if [ ! "$answer" = "cancel" ]; then
    if [[ "$answer" =~ "new session" ]]; then
      tmux_new_sesssion
    elif [[ "$answer" =~ "new window" ]]; then
      tmux new-window
    elif [ "$answer" = "kill session" ]; then
      tmux_kill_session_interactively
    elif [ "$answer" = "kill window" ]; then
      tmux_kill_window_interactively
    elif [[ "$answer" =~ "switch" ]] && [[ ! "$answer" =~ "new window" ]]; then
      tmux select-window -t $(echo "$answer" | awk '{print $4}' | sed "s/://g")
    else
      tmux attach -t $(echo "$answer" | awk '{print $4}' | sed 's/://')
    fi
  fi
}


tmux_operation_interactively_choices() {
  if $(tmux has-session); then
    tmux list-sessions | while read line; do
      [[ ! "$line" =~ "attached" ]] || line="${fg[green]}$line${reset_color}"
      echo "${fg[green]}attach${reset_color} ==> [ "$line" ]"
    done
    echo "${fg[green]}create${reset_color} ==> [ ${fg_bold[default]}new session${reset_color} ]"
    echo "kill session"
  else
    echo "${fg[green]}create${reset_color} ==> [ ${fg_bold[default]}new session${reset_color} ]"
  fi
  echo "${fg[blue]}cancel${reset_color}"
}




tmux_operation_interactively_in_tmux_choices() {
  local list_sessions list_windows
  list_windows=$(tmux list-windows)
  if [ ! $(echo "$list_windows" | grep -c '') = 1 ]; then
    echo "$list_windows" | while read line; do
      if [[ ! $line =~ "active" ]]; then
        line=$(echo "$line" | awk '{print $1 " " $2 " " $3 " " $4 " " $5}')
        echo  "${fg[cyan]}switch${reset_color} ==> [ $line ]"
      fi
    done
  fi
  echo  "${fg[cyan]}switch${reset_color} ==> [ ${fg_bold[default]}new window${reset_color} ]"
  echo "kill session"
  echo "kill window"
  echo "${fg[blue]}cancel${reset_color}"
}


tmux_kill_session_interactively() {
  answer=$(tmux_kill_session_interactively_choices | fzf-tmux --ansi --prompt="Tmux >")
  if [ "$answer" = "cancel" ]; then
    tmux_operation_interactively
  elif [[ "$answer" =~ "Server" ]]; then
    tmux kill-server
    tmux_operation_interactively
  else
    tmux kill-session -t $(echo "$answer" | awk '{print $4}' | sed "s/://g")
    if $(tmux has-session); then
      tmux_kill_session_interactively
    else
      tmux_operation_interactively
    fi
  fi
}


tmux_kill_session_interactively_choices() {
  list_sessions=$(tmux list-sessions);
  echo "$list_sessions" | while read line; do
    [[ "$line" =~ "attached" ]] && line="${fg[green]}"$line"${reset_color}"
    echo  "${fg[red]}kill${reset_color} ==> [ "$line" ]"
  done
  [ $(echo "$list_sessions" | grep -c '')  = 1 ] || echo "${fg[red]}kill${reset_color} ==> [ ${fg[red]}Server${reset_color} ]"
  echo "${fg[blue]}cancel${reset_color}"
}


tmux_kill_window_interactively() {
  answer=$(tmux_kill_window_interactively_choices | fzf-tmux --ansi --prompt="Tmux >")
  if [ "$answer" = "cancel" ]; then
    tmux_operation_interactively_in_tmux
  else
    tmux kill-window -t $(echo "$answer" | awk '{print $4}' | sed "s/://g")
    tmux_kill_window_interactively
  fi
}


tmux_kill_window_interactively_choices() {
  tmux list-windows | while read line; do
    if [[ $line =~ "active" ]]; then
      echo " ${fg[red]}kill${reset_color} ==> ${fg[green]}[ $(echo $line | awk '{print $1 " " $2 " " $3 " " $4 " " $5}') (active) ${reset_color}]"
    else
      echo " ${fg[red]}kill${reset_color} ==> [ $(echo $line | awk '{print $1 " " $2 " " $3 " " $4 " " $5}') ]"
    fi
  done
  echo "${fg[blue]}cancel${reset_color}"
}
