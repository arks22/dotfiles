#prompt config

function prompt() {
  if git_info=$(git status 2>/dev/null ); then
    [[ $git_info =~ "Changes not staged" ]] &&  git_unstaged=" ±" || git_unstaged=""
    [[ $git_info =~ "Changes to be committed" ]] && git_uncommited=" ●" || git_uncommited=""
    [ -z "${git_unstaged}${git_uncommited}" ] && git_clean=" ✔ " || git_clean=""

    git_branch="%{[30;48;5;014m%} $(echo $git_info | awk 'NR==1 {print $3}') %f"

    git_info="%F{black}${git_branch}%{[30;48;5;011m%}${git_unstaged}${git_uncommited}${git_clean} %f%k"
  fi
  status_line="%K{black}%F{blue} %n %k%f${dir_info}${git_info}
"    
}


dir_info="%K{cyan}%F{black} %~ %k%f"

re-prompt() {
  status_line=""
  dir_info="%K{cyan}%F{black} %~ %k%f"
  zle .reset-prompt
  zle .accept-line
}

zle -N accept-line re-prompt

#excute before display prompt
add-zsh-hook precmd prompt


PROMPT='${status_line}%(?,%F{blue}»,%F{red}») %f' #left side
RPROMPT='%K{blue}%F{black} %T %k%f'
PROMPT2='%F{blue}» %f' #second prompt
