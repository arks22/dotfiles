#prompt config

function git_info() {
  git_status=$(git status 2>&1)
  if [[ ! $git_status =~ "Not a git" ]]; then
    git_branch=$(echo $git_status | awk 'NR==1 {print $3}')
    git_unstaged=$(echo $git_status | sed -e '1,/Changes not staged/ d' -e '/\(untracked content\)/ d' | sed '1,/^$/ d' | sed '/^$/,$ d' )

    [ ! -z $git_unstaged ] && git_unstaged=" ± " || git_unstaged=""
    [[ $git_status =~ "Changes to be" ]] && git_uncommited=" ● " || git_uncommited=""

    git_info="%K{green}%F{black} $git_branch %K{blue}${git_unstaged}${git_uncommited}%k%f"
  else
    git_info=""
  fi
}

#excute before display prompt
add-zsh-hook precmd git_info


PROMPT='%F{cyan}%C %(?,%F{blue}»,%F{red}») %f' #left side
RPROMPT='${git_info}' #right side
PROMPT2='%F{blue}» %f' #second prompt
