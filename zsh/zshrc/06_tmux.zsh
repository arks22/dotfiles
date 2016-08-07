#tmux config

tmux_new_sesssion() {
  tmux new-session \; split-window -vp 23 \; select-pane -t 1 \; split-window -h \
    \; send-keys -t 0 "vim" C-m \; send-keys -t 1 "ls" C-m \; send-keys -t 2 "ls" C-m
}


tmux_operation() {
  answer=$(tmux_operation_choices | fzf --ansi --select-1 --prompt="Tmux >")
  case $answer in
    *new\ session* ) tmux_new_sesssion ;;
    *new\ window* ) tmux new-window ;;
    "kill sessions" ) tmux_kill_session ;;
    "kill windows" ) tmux_kill_window ;;
    *switch* ) tmux select-window -t $(echo "$answer" | awk '{print $4}' | sed "s/://g") ;;
    *attach* ) tmux attach -t $(echo "$answer" | awk '{print $4}' | sed 's/://') ;;
  esac
}


tmux_operation_choices() {
  if [ -z $TMUX ]; then
    tmux list-sessions 2>/dev/null | while read line; do
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
    echo "${fg[red]}kill${reset_color} windows"
  fi
  tmux has-session 2>/dev/null && echo "${fg[red]}kill${reset_color} sessions"
}


tmux_kill_session() {
  answer=$(tmux_kill_session_choices | fzf --ansi --prompt="Tmux >")
  case $answer in
    *kill*Server* ) tmux kill-server ; tmux_operation ;;
    *kill*windows* ) tmux kill-session -t $(echo "$answer" | awk '{print $4}' | sed "s/://g")
      if $(tmux has-session 2>/dev/null); then
        tmux_kill_session
      fi
    ;;
  esac
}


tmux_kill_session_choices() {
  list_sessions=$(tmux list-sessions 2>/dev/null);
  echo "$list_sessions" | while read line; do
    [[ "$line" =~ "attached" ]] && line="${fg[green]}"$line"${reset_color}"
    echo  "${fg[red]}kill${reset_color} ==> [ "$line" ]"
  done
  [ $(echo "$list_sessions" | grep -c '')  = 1 ] || echo "${fg[red]}kill${reset_color} ==> [ ${fg[red]}Server${reset_color} ]"
}


tmux_kill_window() {
  answer=$(tmux_kill_window_choices | fzf --ansi --prompt="Tmux >")
  if [[ "$answer" =~ "kill" ]]; then
    tmux kill-window -t $(echo "$answer" | awk '{print $4}' | sed "s/://g")
    tmux_kill_window
  fi
}


tmux_kill_window_choices() {
  tmux list-windows | while read line; do
    line="$(echo $line | awk '{print $1 " " $2 " " $3 " " $4 " " $5 " " $9}')"
    [[ $line =~ "active" ]] && line="${fg[green]}$line${reset_color}"
    echo " ${fg[red]}kill${reset_color} ==> [ $line ]"
  done
}



if [ ! -z $TMUX ]; then
  echo "– – – – – – – – – – – ${fg_bold[red]}TMUX${reset_color} – – – – – – – – – – – –"
else
  tmux_operation
fi
