#some settings

autoload -Uz add-zsh-hook
autoload -U colors

eval $(gdircolors ~/dircolors)

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="20"

#補完候補でもLS_COLORSを使う
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

#補完候補をハイライト
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' list-separator '-->'

export EDITOR=vim
export LANG=en_US.UTF-8

bindkey -v 

#履歴を10000件保存
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000


#set options

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

