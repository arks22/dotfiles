#etc

autoload -Uz add-zsh-hook
autoload -U colors

eval $(gdircolors ~/dotfiles/zsh/colors/dircolors)

#put symbolic links to ~/bin and grant permissions
[ -e ~/bin ] || mkdir ~/bin

for file in $(ls ~/dotfiles/zsh/functions); do
  ln -f ~/dotfiles/zsh/functions/$file ~/bin/$file
  chmod a+x ~/bin/$file
done


#highlight dir in completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

#highlight completions
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' list-separator '-->'

export EDITOR=vim
export LANG=en_US.UTF-8

export TERM=xterm-256color

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
