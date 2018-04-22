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
readonly F_BLACK="\033[30m"
readonly F_RED="\033[31m"
readonly F_GREEN="\033[32m"
readonly F_YELLOW="\033[33m"
readonly F_BLUE="\033[34m"
readonly F_MAGENTA="\033[35m"
readonly F_CYAN="\033[36m"
readonly F_WHITE="\033[37m"

readonly B_BLACK="\033[40m"
readonly B_RED="\033[41m"
readonly B_GREEN="\033[42m"
readonly B_YELLOW="\033[43m"
readonly B_BLUE="\033[44m"
readonly B_MAGENTA="\033[45m"
readonly B_CYAN="\033[46m"
readonly B_WHITE="\033[47m"

readonly BOLD="\033[1m"
readonly DEFAULT="\033[0m"


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
alias py="python"
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
        *Changes\ not\ staged* ) state="${F_BLACK}\033[30;48;5;013m ± ${DEFAULT}" ;;
        *Changes\ to\ be\ committed* ) state="${F_BLACK}${B_BLUE} + ${DEFAULT}" ;;
        * ) state="${F_BLACK}${B_GREEN} ✔ ${DEFAULT}" ;;
      esac
      if [[ $git_branch = "master" ]]; then
        export git_info="${B_BLACK}⭠ ${BOLD}${git_branch}${DEFAULT}${B_BLACK} ${state}${DEFAULT}"
      else
        export git_info="${B_BLACK}⭠ ${git_branch} ${state}${DEFAULT}"
      fi
    else
      export git_info=""
    fi
  fi
}

function set-prompt() {
  get-git-info
  PS1="${git_info}${B_BLACK}${F_CYAN} \w${DEFAULT}${B_BLACK}${F_BLUE} > ${DEFAULT}"
}

PROMPT_COMMAND='set-prompt'


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
  n=$(( $(tput cols) / 4 - 2 ))
  for ((i=0; $i < $n; i++)); do
    str="${str}- "
  done
  echo -e "${str}${F_RED}${BOLD}TMUX${DEFAULT} - ${F_GREEN}bash${DEFAULT}${str}"
elif [[ ! $(whoami) = "root" ]]; then
  n=$(( $(tput cols) / 4 - 1 ))
  for ((i=0; $i < $n; i++)) ; do
    str="${str}- "
  done
  echo -e "${str}${F_GREEN}bash ${DEFAULT}${str}"
  tmux attach
fi
