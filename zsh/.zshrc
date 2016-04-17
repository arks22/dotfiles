export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.rbenv/bin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export CC=/usr/bin/gcc

alias ta="tmux a -t"
alias tls="tmux list-sessions"
alias reload="source ~/.zshrc"
alias r="rails"
alias v="vagrant"
alias electron="reattach-to-user-namespace electron"
setopt auto_cd

DEFAULT_USER="arks22"
ZSH_THEME="robbyrussell"

source ~/dotfiles/zsh/tmux_config.zsh

source ~/.zplug/zplug

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
