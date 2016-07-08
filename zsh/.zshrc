#zplug
if [ ! -e ~/.zplug ]; then
  git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

autoload -Uz compinit
compinit

source ~/.zplug/init.zsh

zplug "mollifier/anyframe"
zplug "b4b4r07/enhancd", use:init.sh
zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf
zplug "junegunn/fzf", as:command, use:bin/fzf-tmux
zplug "zsh-users/zsh-history-substring-search"
zplug "mrowa44/emojify", as:command 
zplug "b4b4r07/emoji-cli", \
  if:'(( $+commands[jq] ))', \
  on:"junegunn/fzf-bin"

#未インストールの項目をインストール
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose


eval $(gdircolors ~/dircolors)
#補完候補でもLS_COLORSを使う
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#補完候補をハイライト
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' list-separator '-->'

export EDITOR=vim
export LANG=en_US.UTF-8

bindkey -v #zleでvimを使う

#履歴を10000件保存
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000


#aliases
alias vi="vim"
alias l="gls -A --color=auto"
alias ls="gls --color=auto"
alias q="exit"
alias t="tmux_interactively"
alias tls="tmux list-sessions"
alias tnw="tmux new-window"
alias fzf="fzf-tmux"
alias r="source ~/.zshrc"
alias rls="rails"
alias cl="clear"
alias v="vagrant"
alias g="git"
alias glog="git_log_fzf"
alias gcmmt="git_commit_automatically"
alias c="open -a Google\ Chrome"
alias electron="reattach-to-user-namespace electron"
alias -g G='| grep'

#いろいろ設定
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



#functions

#コミットメッセージ自動生成
git_commit_automatically() {
  local commmit_message added_changes action line
  git status \
    | sed -e '1,/Changes to be committed/ d' \
    | sed '1,/^$/ d' \
    | sed '/^$/,$ d' \
    | while read line; do
    action=$(echo $line | awk '{print $1}' | sed s/://)
    case $action in
      "new" ) added_changes="[add] $(echo $line | awk '{print $3}')" ;;
      "deleted" ) added_changes="[remove] $(echo $line | awk '{print $2}')" ;;
      "renamed" ) added_changes="[rename] $(echo $line | awk '{print $2 $3 $4}')" ;;
      "modified" ) added_changes="[update] $(echo $line | awk '{print $2}')" ;;
    esac
    commmit_message="$commmit_message $added_changes"
  done
  git commit -m "$commmit_message"
}

#gitのlog
git_log_fzf() {
  local out shas sha q k
  while out=$(
    git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
      fzf --ansi --multi --no-sort --reverse --query="$q" \
      --print-query --expect=ctrl-d); do
    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')
    [ -z "$shas" ] && continue
  if [ "$k" = ctrl-d ]; then
    git diff --color=always $shas | less -R
    else
      for sha in $shas; do
        git show --color=always $sha | less -R
      done
    fi
  done
}

#google
ggl() {
  local str opt
  if [ $# != 0 ]; then
    for i in $*; do
      str="$str${str:++}$i"
    done
    opt="search?q=${str}"
  fi
  open -a Google\ Chrome http://www.google.co.jp/$opt
}


#tmux

setting() {
  local line
  if [ ! -z $TMUX ]; then
    echo "–––––––––––––––––––––––––– ${fg[blue]}tmux sessions${reset_color} –––––––––––––––––––––––––––"
    tmux list-sessions > /dev/null 2>&1 | while read line; do
      if [[ $line =~ "attached" ]]; then
        echo "${fg[yellow]}* ${reset_color}$line"
      else
        echo "  $line"
      fi
    done
    echo "––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––"
    echo "– – – – – – – – – – – – – – – – ${fg_bold[red]}TMUX${reset_color} – – – – – – – – – – – – – – – –"
  else
    tmux_interactively
  fi
}


tmux_interactively() {
  local answer
  if [ ! -z $TMUX ];then
    tmux_kill_session_interactively
  else
    answer=$(tmux_choices | fzf-tmux --ansi --prompt="Tmux >")
    case $answer in
      "windows" ) tmux attach -t $(echo $answer | awk '{print $4}') ;;
      "create new session" ) tmux new-session \; split-window -vp 23 \; select-pane -t 1 \; split-window -h ;;
      "kill session" ) tmux_kill_session_interactively ;;
    esac
  fi
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
      echo "${fg[blue]}Tmux: ${reset_color}kill all sessions, OK? (Y,any)"
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
  echo -n "remove current directory, OK? [y, any]"
  read -k 1 answer
  if [ $answer = "y" ]; then
    rm -r $PWD && cd ..
  fi
}

#git statusをPromptに表示させるため
function git_info() {
  git_status=$(git status 2>&1)
  if [[ ! $git_status =~ "Not a git" ]]; then
    git_branch=$(echo $git_status | awk 'NR==1 {print $3}')
    if [[ $git_status =~ "Changes not staged" ]]; then
      git_unstaged=$(echo $git_status \
        | sed -e '1,/Changes not staged/ d' -e '/\(untracked content\)/ d' \
        | sed '1,/^$/ d' \
        | sed '/^$/,$ d' \
        | awk 'END{print NR}')
    else
      git_unstaged=0
    fi
    if [[ $git_status =~ "Changes to be committed" ]]; then
      git_uncommited=$(echo $git_status \
        | sed -e '1,/Changes to be committed/ d' \
        | sed '1,/^$/ d' \
        | sed '/^$/,$ d' \
        | grep -c '')
    else
      git_uncommited=0
    fi
    git_info="%K{blue}%F{black}$git_branch ±$git_unstaged c$git_uncommited %k%f"
  else
    git_info=""
  fi
}


setting



#Prompt

autoload -Uz add-zsh-hook
autoload -U colors

#prompt表示前に実行

if [ $(which git) ]; then
  add-zsh-hook precmd git_info
else
  git_info=""
fi

PROMPT='%F{cyan}%C %(?,%F{blue}»,%F{red}») %f' #左側
RPROMPT='${git_info}%K{green}%F{black} %T %f%k' #右側
PROMPT2='%F{blue}» %f' #2行以上
