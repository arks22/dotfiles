#PATHはできるだけ.zshenvの方に
export EDITOR=vim
export LANG=ja_JP.UTF-8

#alias
alias t="tmux"
alias ta="tmux a -t"
alias tls="tmux list-sessions"
alias reload="source ~/.zshrc"
alias r="rails"
alias v="vagrant"
alias electron="reattach-to-user-namespace electron"

#いろいろ便利な設定
setopt auto_cd
setopt correct
setopt no_beep
setopt no_share_history
setopt mark_dirs 

DEFAULT_USER="arks22"
ZSH_THEME="robbyrussell"

source ~/dotfiles/zsh/tmux_attach.zsh

source ~/.zplug/zplug

#zplugの読み込むやつ
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
