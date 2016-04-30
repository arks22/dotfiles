#zplug
autoload -Uz compinit
compinit

if [ ! -e ~/.zplug ]; then
  echo "Installing zplug...."
  git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

zplug "b4b4r07/zplug"

zplug "mollifier/anyframe"
zplug "peco/peco", as:command, from:gh-r, use:"*amd64*"

zplug "zsh-users/zsh-syntax-highlighting", nice:10
zplug "zsh-users/zsh-history-substring-search"

zplug "mrowa44/emojify", as:command
zplug "b4b4r07/emoji-cli", on:"stedolan/jq"

zplug "themes/af-magic", from:oh-my-zsh
zplug "plugins/git", from:oh-my-zsh

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

ZSH_THEME="af-magic"

#環境変数はzshenvとかzshprofileに
export EDITOR=vim
export LANG=ja_JP.UTF-8

bindkey -v #zleでvimを使う

#履歴を100000件保存
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000

#aliases
alias vi="vim"
alias l="gls -A --color=auto"
alias ls="gls --color=auto"
alias t="tmux"
alias q="exit"
alias ta="tmux a -t"
alias tls="tmux list-sessions"
alias r="source ~/.zshrc"
alias cl="clear"
alias v="vagrant"
alias g="git"
alias electron="reattach-to-user-namespace electron"
alias -g G='|grep'

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
