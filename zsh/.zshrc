ZSH_THEME="robbyrussell"

#zplug
if [ ! -e ~/.zplug ]; then
  echo "Installing zplug...."
  curl -fLo ~/.zplug/zplug --create-dirs git.io/zplug
  source ~/.zplug/zplug && zplug update --self
fi

source ~/.zplug/zplug 

zplug "mollifier/anyframe"
zplug "peco/peco", as:command, from:gh-r, of:"*amd64*"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "mrowa44/emojify", as:command
zplug "plugins/git", from:oh-my-zsh
zplug "stedolan/jq", \
    as:command, \
    file:jq, \
    from:gh-r \
    | zplug "b4b4r07/emoji-cli"

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
if [ -n "$LS_COLORS" ]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

#環境変数はzshenvとかzshprofileに
export EDITOR=vim
export LANG=ja_JP.UTF-8

bindkey -v #zleでvimを使う

#履歴を100000件保存
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=100000

#aliases
alias vi="vim"
alias l="gls -A --color=auto"
alias ls="gls --color=auto"
alias t="tmux"
alias q="exit"
alias ta="tmux a -t"
alias tls="tmux list-sessions"
alias reload="source ~/.zshrc"
alias r="rails"
alias cl="clear"
alias v="vagrant"
alias electron="reattach-to-user-namespace electron"
alias -g G='| grep'

source ~/dotfiles/zsh/functions.sh

source ~/dotfiles/zsh/tmux_attach.zsh

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
