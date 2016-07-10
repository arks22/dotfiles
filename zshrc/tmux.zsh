#tmux

#-------------------- tmux operation --------------------

tmux_operation_interactively() {
  if [ ! -z $TMUX ]; then
    tmux_operations_interactively_in_tmux
  else
    if $(tmux has-session > /dev/null 2>&1); then
      answer=$(tmux_operation_interactively_choices | fzf-tmux --ansi --prompt="Tmux >")
      if [ ! "$answer" = "cancel" ]; then
        if [[ "$answer" =~ "new session" ]]; then
          tmux_new_session
        elif [ "$answer" = "kill session" ]; then
          tmux_kill_session_interactively
        else
          echo unko
          tmux attach -t $(echo "$answer" | awk '{print $4}' | sed 's/://')
        fi
      fi
    else
      tmux_new_session
    fi
  fi
}


tmux_operation_interactively_choices() {
  if $(tmux has-session > /dev/null 2>&1); then
    tmux list-sessions > /dev/null 2>&1 | while read line; do
      [[ ! "$line" =~ "attached" ]] || line="${fg[green]}"$line"${reset_color}"
      echo "${fg[green]}attach${reset_color} --> [ "$line" ]"
    done
    echo "create --> [ ${fg_bold[default]}new session${reset_color} ]"
    echo "kill ${fg_bold[default]}session${reset_color}"
  else
    echo "create --> [ ${fg_bold[default]}new session${reset_color} ]"
  fi
  echo "${fg[blue]}cancel${reset_color}"
}



tmux_operations_interactively_in_tmux() {
  answer=$(tmux_operation_interactively_in_tmux_choices | fzf-tmux --ansi --prompt="Tmux >")
  if [ ! "$answer" = "cancel" ]; then
    if [ "$answer" = "create new window" ]; then
      tmux new-window
    elif [ "$answer" = "kill session" ]; then
      tmux_kill_session_interactively
    elif [ "$answer" = "kill window" ]; then
      tmux_kill_window_interactively
    else
      tmux select-window -t $(echo "$answer" | awk '{print $4}' | sed "s/://g")
    fi
  fi
}


tmux_operation_interactively_in_tmux_choices() {
  local list_sessions list_windows
  list_sessions=$(tmux list-sessions)
  list_windows=$(tmux list-windows)
  if [ ! $(echo "$list_windows" | grep -c '') = 1 ]; then
    echo "$list_windows" > /dev/null 2>&1 | while read line; do
      if [[ ! "$line" =~ "active" ]]; then
        line=$(echo "$line" | awk '{print $1 " " $2 " " $3 " " $4 " " $5}')
        echo  "${fg[cyan]}switch${reset_color} --> [ "$line" ]"
      fi
    done
  fi
  echo  "${fg[cyan]}switch${reset_color} --> [ ${fg_bold[default]}new window${reset_color} ]"
  echo "kill ${fg_bold[default]}session${reset_color}"
  echo "kill ${fg_bold[default]}window${reset_color}"
  echo "${fg[blue]}cancel${reset_color}"
}

#-------------------- kill session --------------------

tmux_kill_session_interactively() {
  answer=$(tmux_kill_session_interactively_choices | fzf-tmux --ansi --prompt="Tmux >")
  if [ "$answer" = "cancel" ]; then
    if [ -z $TMUX ]; then
      tmux_operation_interactively
    else
     tmux_operations_interactively_in_tmux
    fi 
  elif [[ "$answer" =~ "Server" ]]; then
    tmux kill-server
    if [ -z $TMUX ]; then
      tmux_operation_interactively
    else
      tmux_operations_interactively_in_tmux
    fi 
  else
    tmux kill-session -t $(echo "$answer" | awk '{print $4}' | sed "s/://g")
    if $(tmux has-session > /dev/null 2>&1); then
      tmux_kill_session_interactively
    else
      if [ -z $TMUX ]; then
        tmux_operation_interactively
      else
       tmux_operations_interactively_in_tmux
      fi 
    fi
  fi
}

tmux_kill_session_interactively_choices() {
  list_sessions=$(tmux list-sessions);
  echo "$list_sessions" > /dev/null 2>&1 | while read line; do
    [[ "$line" =~ "attached" ]] && line="${fg[green]}"$line"${reset_color}"
    echo  "${fg[red]}kill${reset_color} --> [ "$line" ]"
  done
  [ $(echo "$list_sessions" | grep -c '')  = 1 ] || echo "${fg[red]}kill${reset_color} --> [ ${fg[red]}Server${reset_color} ]"
  echo "${fg[blue]}cancel${reset_color}"
}

#-------------------- kill window --------------------

tmux_kill_window_interactively() {
  answer=$(tmux_kill_window_interactively_choices | fzf-tmux --ansi --prompt="Tmux >")
  if [ "$answer" = "cancel" ]; then
    tmux_operations_interactively_in_tmux
  else
    tmux kill-window -t $(echo "$answer" | awk '{print $4}' | sed "s/://g")
    tmux_kill_window_interactively
  fi
}


tmux_kill_window_interactively_choices() {
  list_windows=$(tmux list-windows);
  echo "$list_windows" > /dev/null 2>&1 | while read line; do
    result_line=$(echo "$line" | awk '{print $1 " " $2 " " $3 " " $4 " " $5}')
    [[ "$line" =~ "active" ]] && result_line="${fg[green]}$result_line (active)${reset_color}"
    echo  "${fg[red]}kill${reset_color} --> [ $result_line ]"
  done
  echo "${fg[blue]}cancel${reset_color}"
}
