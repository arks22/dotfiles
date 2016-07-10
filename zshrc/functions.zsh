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



google() {
  local str opt
  if [ $# != 0 ]; then
    for i in $*; do
      str="$str${str:++}$i"
    done
    opt="search?q=${str}"
  fi
  open -a Google\ Chrome http://www.google.co.jp/$opt
}


#ssid
function get_ssid() {
  /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I \
    | grep " SSID" \
    | awk '{$1="";print}' \
    | sed "s/ //"
}


#battery
function battery() {
  /usr/bin/pmset -g ps \
    | awk '{ if (NR == 2) print $2 " " $3 }' \
    | sed -e "s/;//g"
}


#auto_cdでもcdでも実行後にhomeにいなければls
function chpwd() {
  echo "=================== ${fg[blue]}$PWD${reset_color} ==================="
  [ $PWD = $HOME ] || gls -A --color=auto
}


#ディレクトリ作って入る
function mkcd() {
  mkdir $1 && cd $1
}


#カレントディレクトリを削除して抜ける
function rmc() {
  echo -n "remove current directory, OK? [Y, any]"
  read -k 1 answer
  if [ $answer = "y" ]; then
    rm -r $PWD && cd ..
  fi
}
