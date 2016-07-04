#zplug
if [ ! -e ~/.zplug ]; then
  git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

autoload -Uz compinit
compinit

source ~/.zplug/init.zsh

zplug "mollifier/anyframe"
zplug "peco/peco", as:command, from:gh-r, use:"*amd64*"

zplug "zsh-users/zsh-history-substring-search"

zplug "mrowa44/emojify", as:command 
zplug "b4b4r07/emoji-cli", on:"stedolan/jq"

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
alias tn="tmux new-session"
alias t="tmux_auto"
alias tls="tmux list-sessions"
alias r="source ~/.zshrc"
alias rls="rails"
alias cl="clear"
alias v="vagrant"
alias g="git"
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

#とても便利
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


#tmuxの自動attach,自動起動
tmux_auto() {
  session_list=`tmux list-sessions 2>&1`
  echo "–––––––––––––––––––––––––– ${fg[blue]}tmux sessions${reset_color} ––––––––––––––––––––––––"
  echo $session_list
  echo "–––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––"
  if [ ! -z $TMUX ]; then
    echo "${fg_bold[red]}IN TMUX${reset_color}"
  else
    if [[ ! $session_list =~ "no server running" ]]; then
      if [ `echo $session_list | grep -c ''` -eq 1 ]; then
        echo  "${fg[blue]}Tmux: ${reset_color}What do you want to do ?"
        echo  "    ${fg[cyan]}c${reset_color}      --> create new session"
        echo  "    ${fg[cyan]}n${reset_color}      --> do nothing"
        echo  -n "    ${fg[cyan]}other${reset_color}  --> attach to newest session"
        read -k 1 answer
        if [ ! $answer = "n" ]; then
          if [ $answer = "c" ]; then
            tmux new-session
          else
            tmux attach
          fi
        fi
      else
        echo  "${fg[blue]}Tmux: ${reset_color}What do you want to do ?"
        echo  "    ${fg[cyan]}c${reset_color}      --> create new session"
        echo  "    ${fg[cyan]}X[0-9]${reset_color} --> attach to session X"
        echo  "    ${fg[cyan]}n${reset_color}      --> do nothing"
        echo -n  "    ${fg[cyan]}other${reset_color}  --> attach to newest session"
        read -k 1 answer
        if [ ! $answer = "n" ]; then
          if [[ "$answer" =~ ^[0-9]+$ ]]; then
            tmux attach -t $answer
          elif [ $answer = "c" ]; then
            tmux new-session
          else
            tmux attach
          fi
        fi
      fi
    else
      echo  "${fg[blue]}Tmux: ${reset_color}What do you want to do ?"
      echo  "    ${fg[cyan]}n${reset_color}      --> do nothing"
      echo -n  "    ${fg[cyan]}other${reset_color}  --> create new session"
      read -k 1 answer
      if [ ! $answer = "n" ]; then
        tmux new-session
      fi
    fi
  fi
}

#ssid
function get_ssid() {
  /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep " SSID" | awk '{$1="";print}' | sed "s/ //"
}

#battery
function battery() {
  /usr/bin/pmset -g ps | awk '{ if (NR == 2) print $2 " " $3 }' | sed -e "s/;//g"
}

#auto_cdでもcdでも実行後にhomeにいなければls
function chpwd() {
  echo "${fg[blue]}——————————————${fg[black]}${bg[blue]}$PWD${reset_color}${fg[blue]}——————————————"
  [ $PWD = $HOME ] || gls -A --color=auto
}

#ディレクトリ作って入る
function mkcd() {
  mkdir $1 && cd $1
}

#カレントディレクトリを削除して抜ける
function rmc() {
  echo -n "remove current directory, OK? [y, any]"
  read answer
  if [ $answer = "y" ]; then
    rm -r $PWD && cd ..
  fi
}

#git statusをPromptに表示させるため
function git_info() {
  git_status=`git status 2>&1`
  if [[ ! $git_status =~ "Not a git" ]]; then

    git_branch=`echo $git_status | awk 'NR==1 {print $3}'`
    
    if [[ $git_status =~ "Changes not staged" ]]; then
      git_unstaged=`echo $git_status \
        | sed -e '1,/Changes not staged/ d' -e '/\(untracked content\)/ d' \
        | sed '1,/^$/ d' \
        | sed '/^$/,$ d' \
        | awk 'END{print NR}'`
    else
      git_unstaged=0
    fi

    if [[ $git_status =~ "Changes to be committed" ]]; then
      git_uncommited=`echo $git_status \
        | sed -e '1,/Changes to be committed/ d' \
        | sed '1,/^$/ d' | sed '/^$/,$ d' \
        | grep -c ''`
    else
      git_uncommited=0
    fi

    git_info="%K{blue}%F{black}*$git_branch ±$git_unstaged c$git_uncommited %k%f"
  else
    git_info=""
  fi
}

tmux_auto


#Prompt

autoload -Uz add-zsh-hook
autoload -U colors

#prompt表示前に実行

if [ `which git` ]; then
  add-zsh-hook precmd git_info
else
  git_info=""
fi

PROMPT='%F{cyan}%C %(?,%F{blue}»,%F{red}») %f' #左側
RPROMPT='${git_info}%K{green}%F{black} %T %f%k' #右側
PROMPT2='%F{blue}» %f' #2行以上
