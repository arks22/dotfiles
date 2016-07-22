#zplug

if [ ! -e ~/.zplug ]; then
  git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

source ~/.zplug/init.zsh

autoload -Uz compinit
compinit

zplug "junegunn/fzf-bin", as:command, from:gh-r, rename-to:fzf

zplug "junegunn/fzf", as:command, use:bin/fzf-tmux

zplug "mrowa44/emojify", as:command 

zplug "arks22/tmuximum", as:command

zplug "arks22/zsh-gomi", as:command, use:bin/gomi

zplug "mollifier/anyframe"

zplug "zsh-users/zsh-completions"

zplug "zsh-users/zsh-syntax-highlighting"


#未インストールの項目をインストール
if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi

zplug load --verbose
