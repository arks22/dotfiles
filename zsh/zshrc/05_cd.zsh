#cd config

function chpwd() {
  echo "––––––––––––––––––– ${fg[blue]}$PWD${reset_color} –––––––––––––––––––"
  [ $PWD = $HOME ] || gls -AX --color=auto
  powered_cd_add_log
}

function powered_cd_add_log() {
  local i=0
  cat ~/.powered_cd.log | while read line; do
    (( i++ ))
    [ "$line" = "$PWD" ] && sed -i -e "${i},${i}d" ~/.powered_cd.log 
  done
  echo "$PWD" >> ~/.powered_cd.log
}

function powered_cd() {
  if [ $# = 0 ]; then
    cd $(gtac ~/.powered_cd.log | fzf)
  elif [ $# = 1 ]; then
    cd $1
  else
    echo "powered_cd: too many arguments"
  fi
}

_powered_cd() {
  _files -/
}

compdef _powered_cd powered_cd

[ -e ~/.powered_cd.log ] || touch ~/.powered_cd.log
