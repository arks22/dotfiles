#aliases

alias vi="vim"
alias l="gls -AX --color=auto"
alias ls="gls -X --color=auto"
alias q="exit"
alias t="tmux_operation"
alias tls="tmux list-sessions"
alias tnw="tmux new-window"
alias fzf="fzf-tmux"
alias r="exec {$SHELL} -l"
alias c="powered_cd"
alias rl="rails"
alias cl="clear"
alias v="vagrant"
alias g="git"
alias glog="git_log_fzf"
alias gcmt="git_commit_automatically"
alias gac="git add -A; and git_commit_automatically"
alias gdc="git reset --hard HEAD^"
alias gst="git status"
alias ch="open -a Google\ Chrome"
alias gg="google"

#cd config

function cd
  builtin cd $argv
  echo "$PWD"
  [ $PWD = $HOME ]; or gls -AX --color=auto
  powered_cd_add_log
end

function powered_cd_add_log
  set i 0
  cat ~/.powered_cd.log | while read line
    set i (expr $i + 1)
    if [ i = 30 ]
      sed -i -e "15,15d" ~/.powered_cd.log
    else if [ "$line" = "$PWD" ]
      sed -i -e "$i,$i d" ~/.powered_cd.log 
    end
  end
  echo "$PWD" >> ~/.powered_cd.log
end

function powered_cd
  switch (count $argv)
    case 0; cd (gtac ~/.powered_cd.log | fzf)
    case 1; and cd $argv
    case '*'; echo "powered_cd: too many arguments"
  end
end

[ -e ~/.powered_cd.log ]; or touch ~/.powered_cd.log

if [ ! -z $TMUX ]
  echo "–––––––––––––––––– tmux windows ––––––––––––––––––"
  tmux list-windows | while read line
    echo $line | awk '{print $1 " " $2 " " $3 " " $4 " " $5}'
  end
  echo "––––––––––––––––––––––––––––––––––––––––––––––––––"
  echo "– – – – – – – – – – – TMUX – – – – – – – – – – – –"
end
