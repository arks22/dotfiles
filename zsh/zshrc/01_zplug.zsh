#zplug config

if [ ! -e ~/.zplug ]; then
  git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf

zplug "mrowa44/emojify", as:command 

zplug "arks22/zsh-gomi", as:command, use:bin/gomi

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-syntax-highlighting", nice:10


#install plugins not installed
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose
