######################## zplug ########################

if [ ! -e ~/.zplug ]; then
  git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "junegunn/fzf", as:command, use:"bin/fzf-tmux"
zplug "mollifier/anyframe"
zplug "arks22/zsh-gomi", as:command, use:bin/gomi
zplug "arks22/auto-git-commit", as:command
zplug "arks22/tmuximum", as:command, at:develop
zplug "seebi/dircolors-solarized"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting", defer:2

#install plugins not installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo
    zplug install
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

#completion
zstyle ':completion:*:messages' format $'\e[01;35m -- %d -- \e[00;00m'
zstyle ':completion:*:warnings' format $'\e[01;31m -- no matches found -- \e[00;00m'
zstyle ':completion:*:descriptions' format $'\e[01;33m -- %d -- \e[00;00m'
zstyle ':completion:*:corrections' format $'\e[01;33m -- %d -- \e[00;00m'

zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _complete _prefix _approximate _history
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' list-separator '-->'

export EDITOR=nvim
export LANG=en_US.UTF-8
export XDG_CONFIG_HOME=$HOME/.config
# dockerコマンドを実行したときにlimaではなくローカル環境でdockerが動いてしまうため、dockerコマンドのhost設定を環境変数に設定する。
export DOCKER_HOST=unix:///${HOME}/.lima/docker/sock/docker.sock # for lima
export PATH="$HOME/.jenv/bin:$PATH"
export PATH=$(go env GOPATH)/bin:$PATH
eval "$(jenv init -)"

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


######################## aliases ########################

if [[ $OS = "Darwin" ]]; then
  alias l="gls -CFX --color=auto"
  alias ls="gls -ACFX --color=auto"
elif [[ $OS = "Linux" ]]; then
  alias l="$(which ls) -CF"
  alias ls="ls -aCF"
fi

alias original-vim="$(which vim)"
alias vim="nvim"
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
alias electron="reattach-to-user-namespace electron"
alias -g F="| fzf-tmux"
alias -g G="| grep"
alias -s rb="ruby"
alias -s py='python'
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gco="git checkout"
alias gpl="git pull"
alias gps="git push -u origin HEAD"
alias gac="git add -A && auto-git-commit"
alias gacp="git_add_commit_push"
alias ggl="google"
alias ecc="compile_and_exec_c_file"
alias grw="./gradlew"

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
  git add -A && auto-git-commit && git push origin HEAD
}

function git_push_current_branch {
  git push origin $(git branch | awk '/\*/' | sed -e "s/*//")
}

function imgcat_tmux() {
  imgcat "$1"
  read && clear
}

######################## prompt ########################

# GitHubユーザー情報を格納するグローバル変数
typeset -g GITHUB_USER=""

# GitHubユーザー情報を更新する関数
update_github_user() {
    GITHUB_USER=$(command gh auth status 2>&1　| grep -B1 "Active account: true" | head -1 | sed 's/.*account \([^ ]*\).*/\1/')
}

# シェル起動時に実行
update_github_user

gh() {
    command gh "$@"
    local exit_status=$?

    # authコマンドの実行時のみユーザー情報を更新
    if [[ $# -gt 0 ]] && [[ $1 == "auth" ]]; then
        update_github_user
    fi

    return $exit_status
}

#excute before display prompt
function precmd() {
  [ $(whoami) = "root" ] && root="%K{black}%F{yellow} ⚡ %f|%k" || root=""

  # 素のシェルの場合
  if [ -z $TMUX ] && [ -z $VIMRUNTIME ]; then
    if git_status=$(git status -uno 2>/dev/null ); then
      git_branch="$(echo $git_status| awk 'NR==1 {print $3}')"
      case $git_status in
        *Changes\ not\ staged* ) state="%F{magenta}±%f" ;;
        *Changes\ to\ be\ committed* ) state="%F{blue}+%f" ;;
        * ) state="%F{green}✔%f" ;;
      esac
      if [[ $git_branch = "main" ]] || [[ $git_branch = "master" ]] then
        git_info="%F{blue} ${git_branch} %f%k%B${state}%b"
      else
        git_info="${git_branch} %B${state}%b"
      fi
    else
      git_info=""
    fi
  fi

  # カレントディレクトリ
  dir="%~"
  if [ $TERM_PROGRAM = "vscode" ] && [ -n "$VSCODE_WORKSPACE" ]; then
    local rel_path="${PWD#$VSCODE_WORKSPACE}"
    if [ "$PWD" = "$VSCODE_WORKSPACE" ]; then
      dir="{project}"
    elif [[ "$PWD" =~ "$VSCODE_WORKSPACE" ]]; then
      dir="{project}$rel_path"
    fi
  fi

  if [ ! -z $TMUX ]; then
    tmux refresh-client -S
  fi

  # "と'の扱いに注意！
  _prompt_error='%(?,,%F{red}%K{black} ✘%f%f|%k)'
  _prompt_time='%F{green}%T%f'
  _prompt_end='%F{blue}> %f%k'
  _prompt_gh_user="%F{magenta}${GITHUB_USER}%f"
  _prompt_current_dir="%F{cyan}${dir}%f"
}

# 環境に応じてプロンプトを構築
if [ ! -z $VIMRUNTIME ]; then # in VIM
  PROMPT='${_prompt_error}${root}${_prompt_time} ${_prompt_gh_user} ${_prompt_current_dir} ${_prompt_end}'
elif [ ! -z $TMUX ]; then #in TMUX 
  PROMPT='${_prompt_error}${root}${_prompt_time} ${_prompt_gh_user} ${_prompt_end}'
elif [ $TERM_PROGRAM = "vscode" ]; then # in VSCode
  PROMPT='${_prompt_error}${root}${_prompt_time} ${_prompt_gh_user} ${_prompt_current_dir} ${_prompt_end}'
else # raw terminal
  PROMPT='${_prompt_error}${root}${_prompt_time} ${_prompt_gh_user} ${_prompt_current_dir} ${_prompt_end}'
  RPROMPT='${git_info}'
fi

# 改行
PROMPT2='%F{blue}» %f'

# 打ち間違い
SPROMPT='zsh: correct? %F{red}%R%f -> %F{green}%r%f [y/n]:'

function command_not_found_handler() {
  echo "zsh: command not found: ${fg[red]}$0${reset_color}"
  exit 1
}

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

if [ ! -z $VIMRUNTIME ]; then
  n=$(( $(tput cols) / 4 - 3 ))
  for ((i=0; $i < $n; i++)) ; do
    str="${str}- "
  done
  echo "${str}${fg[green]}VIM${reset_color} - ${fg[blue]}ZSH ${reset_color}${str}- "
elif [ ! -z $TMUX ]; then
  n=$(( $(tput cols) / 4 - 3 ))
  for ((i=0; $i < $n; i++)) ; do
    str="${str}- "
  done
  echo "${str}${fg[green]}TMUX${reset_color} - ${fg[blue]}ZSH ${reset_color}${str}- "
elif [[ ! $(whoami) = "root" ]]; then
  hostname=$(hostname)
  hostnamelength=${#hostname}
  n=$(( $(tput cols) / 4 - hostnamelength / 4 - 3 ))
  for ((i=0; $i < $n; i++)) ; do
    str="${str}- "
  done
  echo "${str}${fg[green]}$hostname${reset_color}${fg[blue]} : ZSH ${reset_color}${str}- "

  tmux ls > /dev/null 2>&1
  if [ $? -ne 1 ]; then
    tmuximum
  fi
  
fi

######################## lima ########################

# limaが起動しているか確認し、起動していなければ起動する
function check_and_start_lima() {
  if ! limactl list | grep -q "Running"; then
    echo "Starting lima..."
    limactl start docker
  fi
}

# シェル起動時にlima確認処理を実行
check_and_start_lima
