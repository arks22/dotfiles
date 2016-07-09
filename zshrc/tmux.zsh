#tmux


tmux_interactively() {
  local answer
  if [ ! -z $TMUX ];then
    tmux_kill_session_interactively
  else
    if $(tmux has-session > /dev/null 2>&1); then
      answer=$(tmux_choices | fzf-tmux --ansi --prompt="Tmux >")
      if [ ! $answer = "cancel" ]; then
        case $answer in
          "create new session" ) tmux_new_session ;;
          "kill session" ) tmux_kill_session_interactively ;;
          * ) tmux attach -t $(echo $answer | awk '{print $4}' | sed 's/://') ;;
        esac
      fi
    else
      tmux_new_session
    fi
  fi
}


tmux_new_session() {
  tmux new-session \; split-window -vp 23 \; select-pane -t 1 \; split-window -h
}


tmux_choices() {
  local line
  if $(tmux has-session > /dev/null 2>&1); then
    tmux list-sessions > /dev/null 2>&1 | while read line; do
      [[ ! $line =~ "attached" ]] || line="${fg[green]}$line${reset_color}"
      echo "${fg[green]}attach${reset_color} --> [ $line ]"
    done
    echo "create new session"
    echo "kill session"
  else
    echo "create new session"
  fi
  echo "${fg[blue]}cancel${reset_color}"
}


tmux_kill_session_interactively() {
  local answer
  answer=$(tmux_kill_choices | fzf-tmux --ansi --prompt="Tmux >")
  case $answer in
    "Server" )
      echo "${fg[blue]}Tmux: ${reset_color}kill all sessions, OK? [Y,any]"
      read -k 1 answer
      if [ $answer = "Y" ];then
        tmux kill-server
      fi
    ;;
    "cancel" )
      if [ -z $TMUX ];then
        tmux_interactively
      fi
    ;;
    *)
      tmux kill-session -t $(echo $answer | awk '{print $4}' | sed "s/://g")
      if $(tmux has-session > /dev/null 2>&1); then
        tmux_kill_session_interactively
      fi
    ;;
  esac
}


tmux_kill_choices() {
  local list_sessions line
  list_sessions=$(tmux list-sessions)
  echo $list_sessions > /dev/null 2>&1 | while read line; do
    [[ ! $line =~ "attached" ]] || line="${fg[green]}$line${reset_color}"
    echo  "${fg[red]}kill${reset_color} --> [ $line ]"
  done
  [ $(echo $list_sessions | grep -c '')  = 1 ] || echo "${fg[red]}kill${reset_color} --> [ ${fg[red]}Server${reset_color} ]"
  echo "${fg[blue]}cancel${reset_color}"
}

