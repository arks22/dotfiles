export GOPATH=/User/arks22
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.rbenv/bin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export CC=/usr/bin/gcc
alias g="grep"
alias ta="tmux a -t"
alias tls="tmux list-sessions"
alias reload="source ~/.zshrc"
alias r="rails"
alias v="vagrant"
alias electron="reattach-to-user-namespace electron"
setopt auto_cd

#zplugがない場合はinstall
if [ ! -e ~/.zplug ]; then
  echo "Instaling zplug..."
  curl -fLo ~/.zplug/zplug --create-dirs git.io/zplug
  source ~/.zplug/zplug && zplug update --self
fi 

DEFAULT_USER="arks22"
ZSH_THEME="robbyrussell"

source ~/.zplug/zplug
#b4b4r07氏のtmuxxをほぼそのままパクっただけのtmuxのアタッチの設定とか
function is_exists() { type "$1" >/dev/null 2>&1; return $?; }
function is_osx() { [[ $OSTYPE == darwin* ]]; }
function is_screen_running() { [ ! -z "$STY" ]; }
function is_tmux_runnning() { [ ! -z "$TMUX" ]; }
function is_screen_or_tmux_running() { is_screen_running || is_tmux_runnning; }
function shell_has_started_interactively() { [ ! -z "$PS1" ]; }
function is_ssh_running() { [ ! -z "$SSH_CONECTION" ]; }

function tmux_automatically_attach_session()
{
  if is_screen_or_tmux_running; then
    ! is_exists 'tmux' && return 1
    if is_tmux_runnning; then
      echo "${fg_bold[red]} Welcome to TMUX ${reset_color}"
    elif is_screen_running; then
      echo "This is on screen."
    fi
  else
    if shell_has_started_interactively && ! is_ssh_running; then
      if ! is_exists 'tmux'; then
        echo 'Error: tmux command not found' 2>&1
        return 1
      fi
      if tmux has-session >/dev/null 2>&1 && tmux list-sessions | grep -qE '.*]$'; then
        tmux list-sessions
        echo -n "Tmux: attach? (y/N/num) "
        read
        if [[ "$REPLY" =~ ^[Yy]$ ]] || [[ "$REPLY" == '' ]]; then
          tmux attach-session
          if [ $? -eq 0 ]; then
            echo "$(tmux -V) attached session"
            return 0
          fi
        elif [[ "$REPLY" =~ ^[0-9]+$ ]]; then
          tmux attach -t "$REPLY"
          if [ $? -eq 0 ]; then
            echo "$(tmux -V) attached session"
            return 0
          fi
        fi
      fi
      if is_osx && is_exists 'reattach-to-user-namespace'; then
        tmux_config=$(cat $HOME/.tmux.conf <(echo 'set-option -g default-command "reattach-to-user-namespace -l $SHELL"'))
        tmux -f <(echo "$tmux_config") new-session && echo "$(tmux -V) created new session supported OS X"
      else
        tmux new-session && echo "tmux created new session"
      fi
    fi
  fi
}
tmux_automatically_attach_session


#zplugの読み込むやつ
zplug "mollifier/anyframe"

zplug "peco/peco", as:command, from:gh-r, of:"*amd64*"

zplug "zsh-users/zsh-syntax-highlighting"

zplug "zsh-users/zsh-history-substring-search"

zplug "plugins/git", from:oh-my-zsh

zplug "stedolan/jq", \
    as:command, \
    file:jq, \
    from:gh-r \
    | zplug "b4b4r07/emoji-cli"
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
zplug load --verbose
