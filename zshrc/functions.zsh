#functions

tmux_excute_shell_command() {
  send-keys -t $1 "$2" C-m
}

tmux_new_session() {
  tmux new-session \; split-window -vp 23 \; select-pane -t 1 \; split-window -h \
    \; send-keys -t 0 "vim" C-m \
    \; send-keys -t 1 "ls" C-m \
    \; send-keys -t 2 "ls" C-m \
}


