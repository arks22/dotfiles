#prompt config

function git_info() {
  git_status=$(git status 2>&1)
  if [[ ! $git_status =~ "Not a git" ]]; then
    git_branch=$(echo $git_status | awk 'NR==1 {print $3}')
    if [[ $git_status =~ "Changes not staged" ]]; then
      git_unstaged=$(echo $git_status \
        | sed -e '1,/Changes not staged/ d' -e '/\(untracked content\)/ d' \
        | sed '1,/^$/ d' \
        | sed '/^$/,$ d' \
        | awk 'END{print NR}')
    else
      git_unstaged=0
    fi
    if [[ $git_status =~ "Changes to be committed" ]]; then
      git_uncommited=$(echo $git_status \
        | sed -e '1,/Changes to be committed/ d' \
        | sed '1,/^$/ d' \
        | sed '/^$/,$ d' \
        | grep -c '')
    else
      git_uncommited=0
    fi
    git_info="%K{green}%F{black} $git_branch %K{blue} ±$git_unstaged c$git_uncommited %k%f"
  else
    git_info=""
  fi
}


#prompt表示前に実行
if [ $(which git) ]; then
  add-zsh-hook precmd git_info
else
  git_info=""
fi


PROMPT='%F{cyan}%C %(?,%F{blue}»,%F{red}») %f' #左側
RPROMPT='${git_info}' #右側
PROMPT2='%F{blue}» %f' #2行以上
