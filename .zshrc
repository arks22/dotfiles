######################## zplug ########################
if [ ! -e ~/.zplug ]; then
  git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

zplug "zplug/zplug", hook-build:'zplug --self-manage'
zplug "junegunn/fzf", as:command, use:"bin/fzf-tmux"
zplug "arks22/zsh-gomi", as:command, use:bin/gomi
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

# echo "[INFO] Initializing jenv..."
# eval "$(jenv init -)"

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
alias gamend="git commit --amend --no-edit"
alias gps="git push -u origin HEAD"
alias gcp="git cherry-pick"
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

function git_push_current_branch {
  git push origin $(git branch | awk '/\*/' | sed -e "s/*//")
}

######################## prompt ########################

# GitHubユーザー情報を格納するグローバル変数
typeset -g GITHUB_USER=""

# キャッシュファイル関連の設定 (ユーザーのホームディレクトリ配下の .cache ディレクトリ内)
typeset -g _ZSH_GITHUB_USER_CACHE_DIR="${HOME}/.cache/zsh"
typeset -g _ZSH_GITHUB_USER_CACHE_FILE="${_ZSH_GITHUB_USER_CACHE_DIR}/github_user"
typeset -g _ZSH_GITHUB_USER_CACHE_EXPIRY=$((60*60*24)) # キャッシュの有効期限: 1日 

# キャッシュディレクトリが存在しない場合は作成
if [ ! -d "$_ZSH_GITHUB_USER_CACHE_DIR" ]; then
  mkdir -p "$_ZSH_GITHUB_USER_CACHE_DIR"
fi

# GitHubユーザー情報を実際に取得し、キャッシュに保存する関数
_fetch_and_cache_github_user() {
  local user_from_gh
  # GitHub上のログインユーザー名を取得 (エラー出力を抑制)
  user_from_gh=$(command gh api user --jq .login 2>/dev/null)

  # ユーザー名が取得でき (空でなく、かつ "null" 文字列でもない場合)
  if [ -n "$user_from_gh" ] && [ "$user_from_gh" != "null" ]; then
    GITHUB_USER="$user_from_gh"
    echo "$GITHUB_USER" >| "$_ZSH_GITHUB_USER_CACHE_FILE"
    # echo "[DEBUG] GitHub user fetched and cached: $GITHUB_USER" # デバッグ用
  else
    # 取得に失敗した場合
    echo "[ERROR] Failed to fetch GitHub user from gh command. Will use cached or empty value if cache is also missing." >&2
    # 取得に失敗し、かつローカルのキャッシュファイルも存在しない場合は、GITHUB_USERを空にする
    if [ ! -f "$_ZSH_GITHUB_USER_CACHE_FILE" ]; then
        GITHUB_USER=""
    fi
  fi
}

# シェル起動時にGitHubユーザー情報をキャッシュから読み込むか、必要なら更新する関数
_load_github_user_on_startup() {
  if [ -f "$_ZSH_GITHUB_USER_CACHE_FILE" ]; then
    local cache_mod_time
    local current_time
    
    # stat コマンドの互換性対応 (macOS: -f %m, Linux: -c %Y)
    if [[ "$(uname)" == "Darwin" ]]; then
      cache_mod_time=$(stat -f %m "$_ZSH_GITHUB_USER_CACHE_FILE" 2>/dev/null)
    else
      cache_mod_time=$(stat -c %Y "$_ZSH_GITHUB_USER_CACHE_FILE" 2>/dev/null)
    fi
    
    current_time=$(date +%s)

    if [ -n "$cache_mod_time" ] && [ $((current_time - cache_mod_time)) -lt $_ZSH_GITHUB_USER_CACHE_EXPIRY ]; then
      # キャッシュが有効期限内の場合
      GITHUB_USER=$(cat "$_ZSH_GITHUB_USER_CACHE_FILE")
      #echo "[INFO] Loaded GitHub user from cache: $GITHUB_USER" 
      return 0 # 正常終了
    fi
  fi
  
  # キャッシュが存在しない、または古い場合は取得・更新を試みる
  echo "[INFO] No cache found or cache expired. Fetching GitHub user info..."
  _fetch_and_cache_github_user
}
# シェル起動時に実行

echo "[INFO] Loading GitHub user info..."
_load_github_user_on_startup

gh() {
  command gh "$@" # 元のghコマンドを実行
  local exit_status=$?

  # auth関連のサブコマンドが実行された場合のみユーザー情報を更新
  if [[ $# -gt 0 ]] && [[ "$1" == "auth" ]]; then
    _fetch_and_cache_github_user # 情報を再取得しキャッシュも更新
  fi

  return $exit_status
}

#excute before display prompt
function precmd() {
  [ $(whoami) = "root" ] && root="%K{black}%F{yellow} ⚡ %f|%k" || root=""

  git_info="" # まずgit_infoを初期化

  # 素のシェルの場合
  if [ -z $TMUX ] && [ -z $VIMRUNTIME ]; then
    # 現在のディレクトリがGitリポジトリ内か確認
    if command git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
      if git_status=$(command git status --porcelain -uno 2>/dev/null); then # --porcelain でより軽量に
        # git_branch=$(command git symbolic-ref --short HEAD 2>/dev/null) # こちらの方がブランチ名取得は速いかも
        # 最初の行のブランチ名部分を取得 (お使いのawkの処理を維持する場合)
        git_branch_line=$(echo "$git_status" | awk '/^## / {print $2}')
        if [[ -n "$git_branch_line" ]]; then
            if [[ "$git_branch_line" == *"..."* ]]; then # main...origin/main のような場合
                git_branch=${git_branch_line%%...*}
            else
                git_branch=$git_branch_line
            fi
        else # porcelain v1 format (no branch info if clean) or detached HEAD
            git_branch=$(command git symbolic-ref --short HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null)
        fi


        state_symbol=""
        if echo "$git_status" | grep -q -E '^[ MARCDU]'; then # 追跡ファイルに変更あり (staged or unstaged)
            state_symbol="%F{blue}+%f" # 例: 青の+
        elif echo "$git_status" | grep -q -E '^\?\?'; then # 未追跡ファイルあり
            state_symbol="%F{magenta}±%f" # 例: マゼンタの±
        else # クリーンな状態
            state_symbol="%F{green}✔%f"
        fi

        if [[ "$git_branch" = "main" ]] || [[ "$git_branch" = "master" ]]; then
          git_info="%F{blue} ${git_branch} %f%k%B${state_symbol}%b"
        elif [[ -n "$git_branch" ]]; then
          git_info="${git_branch} %B${state_symbol}%b"
        fi
      fi
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
  echo "[INFO] command not found: ${fg[red]}$0${reset_color}"
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
    echo "[INFO] Starting Lima..."
    limactl start docker
  fi
}

# シェル起動時にlima確認処理を実行
check_and_start_lima