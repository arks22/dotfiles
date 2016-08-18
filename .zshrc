
############ zplug ############

if [ ! -e ~/.zplug ]; then
  git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug 'seebi/dircolors-solarized'
zplug "mrowa44/emojify", as:command 
zplug "arks22/zsh-gomi", as:command, use:bin/gomi
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", nice:10

#install plugins not installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose


############ general ############

autoload -U colors

eval $(gdircolors $ZPLUG_HOME/repos/seebi/dircolors-solarized/dircolors.ansi-universal)

stty stop undef
stty start undef

#highlight dir in completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
#highlight completions
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' list-separator '-->'

export EDITOR=vim
export LANG=en_US.UTF-8

export TERM=xterm-256color

bindkey -v 

#save 10000 historys
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000

#set options
setopt auto_cd
setopt correct
setopt no_beep
setopt share_history
setopt mark_dirs 
setopt interactive_comments
setopt list_types
setopt print_eight_bit
setopt auto_param_keys
setopt auto_list
setopt prompt_subst

PATH=$PATH:$HOME/dotfiles/bin

#grant permission
for file in $(ls ~/dotfiles/bin); do
  chmod a+x ~/dotfiles/bin/$file
done



############ aliases ############

if [[ $(uname -s) = "Darwin" ]]; then
  alias l="gls -X --color=auto"
  alias ls="gls -AX --color=auto"
elif [[ $(uname -s) = "Linux" ]]; then
  alias l="ls"
  alias ls="ls -a"
fi

alias vi="vim"
alias vimf="vim +VimFilerExplorer"
alias q="exit"
alias t="tmux_operation"
alias tls="tmux list-sessions"
alias tnw="tmux new-window"
alias reload="exec $SHELL -l"
alias d="gomi"
alias c="powered_cd"
alias rl="rails"
alias cl="clear"
alias vag="vagrant"
alias g="git"
alias glog="git_log_fzf"
alias gac="git add -A && git-commit-automatically"
alias gacp="git add -A && git-commit-automatically && git push origin master"
alias gdc="git reset --hard HEAD^"
alias gs="git status"
alias ch="open -a Google\ Chrome"
alias gg="google"
alias electron="reattach-to-user-namespace electron"
alias -g G="| grep"
alias -g F="| fzf"
alias -s rb="ruby"
alias -s py='python'


############ prompt ############
#excute before display prompt
function precmd() {
  if git_info=$(git status 2>/dev/null ); then
    [[ $git_info =~ "Changes not staged" ]] &&  git_unstaged="%K{blue}%F{black} ± %f%k" || git_unstaged=""
    [[ $git_info =~ "Changes to be committed" ]] && git_uncommited="%{[30;48;5;013m%}%F{black} + %k%f" || git_uncommited=""
    [ -z "${git_unstaged}${git_uncommited}" ] && git_clean="%K{green}%F{black} ✔ %f%k" || git_clean=""
    git_branch="$(echo $git_info | awk 'NR==1 {print $3}')"
    git_info="%K{black} ${git_branch} ${git_unstaged}${git_uncommited}${git_clean}"
  fi
  [ $(whoami) = "root" ] && root="%K{black}%F{yellow} ⚡ %{[38;5;010m%}│%f%k"
  dir_info=$dir
  dir="%F{cyan}%K{black} %~ %k%f"
}

dir="%F{cyan}%K{black} %~ %k%f"

PROMPT='%(?,,%K{red}%F{white} ✘ %k%f)${root}${dir_info} '
RPROMPT='${git_info}'
PROMPT2='%F{blue}» %f'



############ cd ############

function chpwd() {
  [ $PWD = $HOME ] || ls
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



############ tmux ############

tmux_operation() {
  answer=$(tmux_operation_choices | fzf --ansi --select-1 --prompt="Tmux >")
  case $answer in
    *new\ session* ) tmux new-session \; split-window -vp 23 \; send-keys -t 0 'vim' C-m ;;
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
      echo  "${fg[cyan]}switch${reset_color} ==> [ $(echo $line | awk '{print $1 " " $2 " " $3 " " $4 " " $5}') ]"
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
  i=0
  n=$(expr $(tput cols) / 4 - 1)
  while [ $i -lt $n ] ; do
    (( i++ ))
    str="${str}- "
  done
  echo "${str}${fg_bold[red]}TMUX ${reset_color}${str}"
  i=0
else
  tmux_operation
fi
