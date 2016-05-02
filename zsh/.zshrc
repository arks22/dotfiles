#zplug
if [ ! -e ~/.zplug ]; then
  git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

autoload -Uz compinit
compinit

source ~/.zplug/init.zsh

zplug "mollifier/anyframe"
zplug "peco/peco", as:command, from:gh-r, use:"*amd64*"

zplug "zsh-users/zsh-syntax-highlighting", nice:19
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

#色
autoload -U colors
colors

eval $(gdircolors ~/dircolors)

#補完候補でもLS_COLORSを使う
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#補完候補をハイライト
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' list-separator '-->'

#環境変数はzshenvとかzshprofileに
export EDITOR=vim
export LANG=en_US.UTF-8

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
alias -g G='| grep'

source ~/dotfiles/zsh/functions.zsh

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
setopt prompt_subst



#Prompt

autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ":vcs_info:*" enable git
zstyle ':vcs_info:git:*' unstagedstr "%F{black}±"
zstyle ":vcs_info:git:*" formats '%b %u'
zstyle ':vcs_info:git:*' actionformats '(%s)-[%b|%a]'

#prompt表示前に実行
_vcs_precmd () {
  vcs_info
  if [ ! -z $vcs_info_msg_0_ ]; then
    git_branch=" %K{blue}%F{black}* ${vcs_info_msg_0_} %k%f"
  else
    git_branch=""
  fi
}
add-zsh-hook precmd _vcs_precmd

PROMPT='%F{cyan}%C %(?,%F{blue}»,%F{red}») %f' #左側
RPROMPT='${git_branch}%K{green}%F{black} %T %f%k' #右側
PROMPT2='%F{blue}» %f' #2行以上
