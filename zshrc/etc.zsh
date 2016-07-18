#etc

autoload -Uz add-zsh-hook
autoload -U colors

eval $(gdircolors ~/dotfiles/zshrc/colors/dircolors)

#use LS_COLORS in completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

#highlight completions
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' list-separator '-->'

export EDITOR=vim
export LANG=en_US.UTF-8

bindkey -v 

#save 10000 historys
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


function chpwd() {
  echo "–––––––––––––––––––––– ${fg[blue]}$PWD${reset_color} ––––––––––––––––––––––"
  [ $PWD = $HOME ] || gls -AX --color=auto
}
