######################## general ########################

export EDITOR=vim
export LANG=en_US.UTF-8
export TERM=xterm-256color
export XDG_CONFIG_HOME=$HOME/.config

export OS="$(uname -s)"

[[ $OS = "Darwin" ]] && export HARDWARE="$(/usr/sbin/system_profiler SPHardwareDataType | awk '{ if (NR == 5) print $3}')"

HISTFILE=$HOME/.bash_history
HISTSIZE=100000
SAVEHIST=100000


####################### colors #######################

readonly F_BLACK="\[\e[30m\]"
readonly F_RED="\[\e[31m\]"
readonly F_GREEN="\[\e[32m\]"
readonly F_YELLOW="\[\e[33m\]"
readonly F_BLUE="\[\e[34m\]"
readonly F_MAGENTA="\[\e[35m\]"
readonly F_CYAN="\[\e[36m\]"
readonly F_WHITE="\[\e[37m\]"

readonly B_BLACK="\[\e[40m\]"
readonly B_RED="\[\e[41m\]"
readonly B_GREEN="\[\e[42m\]"
readonly B_YELLOW="\[\e[43m\]"
readonly B_BLUE="\[\e[44m\]"
readonly B_MAGENTA="\[\e[45m\]"
readonly B_CYAN="\[\e[46m\]"
readonly B_WHITE="\[\e[47m\]"

readonly BOLD="\[\e[1m\]"
readonly DEFAULT="\[\e[0m\]"


######################## aliases ########################

if [[ $OS = "Darwin" ]]; then
  alias l="gls -X --color=auto"
  alias ls="gls -AX --color=auto"
elif [[ $OS = "Linux" ]]; then
  alias l="ls"
  alias ls="ls -a"
fi
alias vi="vim"
alias q="exit"
alias tx="tmux"
alias reload="exec $SHELL -l"
alias t="tmuximum"
alias c="powered_cd"
alias rl="rails"
alias cl="clear"
alias vag="vagrant"
alias gs="git status"
alias electron="reattach-to-user-namespace electron"
alias rb="ruby"
alias py='python'
alias g="git"
alias glog="git-log-fzf"
alias gac="git add -A && auto-git-commit"
alias gacp="git_add_commit_push"
alias gps="git_push_current_branch"
alias ggl="google"
alias ecc="compile_and_exec_c_file"

function compile_and_exec_c_file() {
  if [[ $# = 1 ]]; then
    gcc $1 && ./a.out
  elif [[ $# = 2 ]]; then
    gcc -o $1 $2 && ./$1
  else
    echo "argument must be one or two (ecc [FILE_NAME] [EXEC_FILE_NAME])"
  fi
}

function git_add_commit_push() {
  git add -A && auto-git-commit && git push origin $(git branch | awk '/\*/' | sed -e "s/*//")
}

function git_push_current_branch {
  git push origin $(git branch | awk '/\*/' | sed -e "s/*//")
}


######################## prompt ########################

#excute before display prompt
function get-git-info() {
  if [ ! -z $TMUX ]; then
    tmux refresh-client -S
  else
    if git_status=$(git status 2>/dev/null ); then
      git_branch="$(echo $git_status| awk 'NR==1 {print $3}')"
      case $git_status in
        *Changes\ not\ staged* ) state="${F_BLACK} ± ${DEFAULT}" ;;
        *Changes\ to\ be\ committed* ) state="${B_BLUE}${F_BLACK} + ${DEFAULT}" ;;
        * ) state="${B_GREEN}${F_BLACK} ✔ ${DEFAULT}" ;;
      esac
      if [[ $git_branch = "master" ]]; then
        git_info="${B_BLACK}${F_BLUE}⭠ ${git_branch}${DEFAULT} ${state}"
      else
        git_info="${B_BLACK}⭠ ${git_branch}${DEFAULT} ${state}"
      fi
    else
      git_info=""
    fi
  fi
  echo "$git_info"
}

PS1="${B_BLACK}$(get-git-info)${F_CYAN}\w${F_BLUE} > ${DEFAULT}"


######################## cd ########################

function chpwd() {
  if [[ ! $PWD = $HOME ]] ; then
    echo -n "${fg[yellow]}[list: ${fg[cyan]}$PWD${reset_color} ${fg[yellow]}] -> ${reset_color}"
    ls
  fi
  local i=0
  pwd_=$(echo $PWD | sed -e s@${HOME}@~@)
  cat ~/.powered_cd.log | while read line; do
    (( i++ ))
    if [ "$line" = "$pwd_" ]; then
      sed -i -e "${i},${i}d" ~/.powered_cd.log
    fi
  done
  echo "${pwd_}" >> ~/.powered_cd.log
}

function powered_cd() {
  case $# in
    0 ) 
      test -f ~/.powered_cd.log 2>/dev/null || touch ~/.powered_cd.log
      cd "$(gtac ~/.powered_cd.log | fzf-tmux -r | sed -e s@~@${HOME}@)"
    ;;
    1 ) cd "$1" ;;
    2 ) mv "$1" "$2" ;;
    * ) echo "powered_cd: too many arguments" ;;
  esac
}


######################## tmux ########################

if [ ! -z $TMUX ]; then
  i=0
  n=$(expr $(tput cols) / 4 - 1)
  while [ $i -lt $n ] ; do
    (( i++ ))
    str="${str}- "
  done
  echo "${str}${fg_bold[red]}TMUX ${reset_color}${str}"
  i=0
elif [[ ! $(whoami) = "root" ]]; then
  tmux attach
fi
