######################## zplug ########################

if [ ! -e ~/.zplug ]; then
  git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:"bin/fzf-tmux"
zplug "mollifier/anyframe"
zplug "arks22/zsh-gomi", as:command, use:bin/gomi
zplug "arks22/auto-git-commit", as:command
zplug "arks22/tmuximum", as:command
zplug "arks22/tweet", as:command
zplug "seebi/dircolors-solarized"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "b4b4r07/zsh-vimode-visual", defer:3

#install plugins not installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose


######################## general ########################

#install tpm(tmux plugin manager)
if [ ! -e ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

autoload -U colors
colors

eval $(gdircolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.ansi-universal)

#complerion
zstyle ':completion:*:messages' format $'\e[01;35m -- %d -- \e[00;00m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- no matches found -- \e[00;00m'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d -- \e[00;00m'
zstyle ':completion:*:corrections' format $'\e[01;33m -- %d -- \e[00;00m'

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _complete _prefix _approximate _history
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' list-separator '-->'

export EDITOR=vim
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME=$HOME/.config

export OS="$(uname -s)"

[[ $OS = "Darwin" ]] && export HARDWARE="$(/usr/sbin/system_profiler SPHardwareDataType | awk '{ if (NR == 5) print $3}')"

HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

#set options
setopt auto_cd
setopt no_beep
setopt share_history
setopt mark_dirs
setopt interactive_comments
setopt list_types
setopt print_eight_bit
setopt auto_param_keys
setopt auto_list
setopt correct
setopt prompt_subst
setopt no_flow_control

#ruby
eval "$(rbenv init -)"


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
alias d="gomi"
alias txm="tmuximum"
alias c="powered_cd"
alias be="bundle exec"
alias rl="rails"
alias cl="clear"
alias vag="vagrant"
alias gs="git status"
alias electron="reattach-to-user-namespace electron"
alias -g F="| fzf-tmux"
alias -g G="| grep"
alias -s rb="ruby"
alias -s py='python'
alias g="git"
alias glog="git-log-fzf"
alias gac="git add -A && auto-git-commit"
alias gacp="git_add_commit_push"
alias gps="git_push_current_branch"
alias ggl="google"
alias ecc="compile_and_exec_c_file"

function compile_and_exec_c_file() {
  if [[ $# = 1 ]]; then
    gcc $1 
    ./a.out
  elif [[ $# = 2 ]]; then
    gcc -o $1 $2 
    ./$1
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
function precmd() {
  [ $(whoami) = "root" ] && root="%K{black}%F{yellow} ⚡ %f|%k" || root=""
  if [ ! -z $TMUX ]; then
    tmux refresh-client -S
  else
    dir="%F{cyan}%K{black} %~ %k%f"
    if git_status=$(git status 2>/dev/null ); then
      git_branch="$(echo $git_status| awk 'NR==1 {print $3}')"
      case $git_status in
        *Changes\ not\ staged* ) state=$'%{\e[30;48;5;013m%} ± %f%k' ;;
        *Changes\ to\ be\ committed* ) state="%K{blue}%F{black} + %k%f" ;;
        * ) state="%K{green}%F{black} ✔ %f%k" ;;
      esac
      if [[ $git_branch = "master" ]]; then
        git_info="%K{black}%F{blue}⭠ ${git_branch}%f%k ${state}"
      else
        git_info="%K{black}⭠ ${git_branch}%f ${state}"
      fi
    else
      git_info=""
    fi
  fi
}

if [ -z $TMUX ]; then
  PROMPT_=$'%(?,,%F{red}%K{black} ✘%f %f|%k)${root}${dir}%K{black}%F{blue}> %f%k'
  RPROMPT=$'${git_info}'
else
  PROMPT_=$'%(?,,%F{red}%K{black} ✘%f %f|%k)${root}%K{black}%F{blue} > %f%k'
fi

PROMPT2='%F{blue}» %f'

SPROMPT='zsh: correct? %F{red}%R%f -> %F{green}%r%f [y/n]:'

function command_not_found_handler() {
  echo "zsh: command not found: ${fg[red]}$0${reset_color}"
  exit 1
}


######################## zle ########################

bindkey -v

autoload -Uz add-zsh-hook
autoload -Uz terminfo

terminfo_down_sc=${terminfo[cud1]}${terminfo[cuu1]}${terminfo[sc]}${terminfo[cud1]}

left_down_prompt_preexec() {
  print -rn -- $terminfo[el]
}

add-zsh-hook preexec left_down_prompt_preexec

function zle-keymap-select zle-line-init zle-line-finish {
  case $KEYMAP in
    main|viins)  PROMPT_2="${fg[green]}-- INSERT --${reset_color}" ;;
    vicmd)       PROMPT_2="${fg[blue]}-- NORMAL --${reset_color}" ;;
    vivis|vivli) PROMPT_2="${fg[magenta]}-- VISUAL --${reset_color}" ;;
  esac

  PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}$PROMPT_"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
zle -N edit-command-line


######################## cd ########################

function chpwd() {
  if [[ ! $PWD = $HOME ]] ; then
    echo "${fg[yellow]}list: \e[4;m${fg[cyan]}$PWD${reset_color}"
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

_powered_cd() {
  _files -/
}

compdef _powered_cd powered_cd


######################## tmux ########################

if [ ! -z $TMUX ]; then
  n=$(( $(tput cols) / 4 - 3 ))
  for ((i=0; $i < $n; i++)) ; do
    str="${str}- "
  done
  echo "${str}${fg_bold[red]}TMUX${reset_color} - ${fg[blue]}zsh ${reset_color}${str}- "
elif [[ ! $(whoami) = "root" ]]; then
  n=$(( $(tput cols) / 4 - 1 ))
  for ((i=0; $i < $n; i++)) ; do
    str="${str}- "
  done
  echo "${str}${fg[blue]}zsh ${reset_color}${str}- "
  tmuximum
fi
