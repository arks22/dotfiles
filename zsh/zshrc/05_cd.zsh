#cd config

function chpwd() {
  [ $PWD = $HOME ] || gls -AX --color=auto
  local i=0
  cat ~/.powered_cd.log | while read line; do
    (( i++ ))
    if [ i = 30 ]; then
      sed -i -e "30,30d" ~/.powered_cd.log
    elif [ "$line" = "$PWD" ]; then
      sed -i -e "${i},${i}d" ~/.powered_cd.log 
    fi
  done
  echo "$PWD" >> ~/.powered_cd.log
  dir="%K{black}%F{magenta} %~ %k%f"
}

function powered_cd() {
  case $# in 
    0 ) cd $(gtac ~/.powered_cd.log | fzf) ;;
    1 ) cd $1 ;;
    * ) echo "powered_cd: too many arguments" ;;
  esac
}

_powered_cd() {
  _files -/
}

compdef _powered_cd powered_cd

[ -e ~/.powered_cd.log ] || touch ~/.powered_cd.log
