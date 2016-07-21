#cd config

function chpwd() {
  echo "––––––––––––––––––– ${fg[blue]}$PWD${reset_color} –––––––––––––––––––"
  [ $PWD = $HOME ] || gls -AX --color=auto
  add_cd_log
}

function add_cd_log() {
  is_log_already_existing=0
  cat ~/.cd.log | while read line; do
    if [ "$PWD" = "$line" ]; then 
      is_log_already_existing=1
    fi
  done
  if [ $is_log_already_existing = 0 ]; then 
    echo "$PWD" >> ~/.cd.log
  fi
}

function powered_cd() {
  if [ $# = 0 ]; then
    dir=$(cat ~/.cd.log | fzf)
    cd $dir
  elif [ $# = 1 ]; then
    cd $1
  else
    echo "cd: too many arguments"
  fi
}

_unko() {
  _files -/
}

compdef _unko powered_cd

[ -e ~/.cd.log ] || touch ~/.cd.log
