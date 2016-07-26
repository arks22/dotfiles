#prompt config

function git_info() {
  git_status=$(git status 2>&1)
  if [[ ! $git_status =~ "Not a git" ]]; then
    git_branch=$(echo $git_status | awk 'NR==1 {print $3}')
    git_unstaged=$(echo $git_status | sed -e '1,/Changes not staged/ d' -e '/\(untracked content\)/ d' | sed '1,/^$/ d' | sed '/^$/,$ d' )

    [ -z $git_unstaged ] || git_unstaged=" ± " || git_unstaged=""
    [[ $git_status =~ "Changes to be" ]] && git_uncommited=" ● " || git_uncommited=""

    git_edit_info="%{[30;48;5;011m%}%F{black}${git_unstaged}${git_uncommited}%k%f"
    git_branch="%{[30;48;5;014m%}%F{black} ${git_branch} %{[0m%}"

    git_info="${git_branch}${git_edit_info}"
  else
    git_info=""
  fi
}

dir_info="%K{cyan}%F{black} %~ %k%f"

re-prompt() {
  status_line=""
  dir_info="%K{cyan}%F{black} %~ %k%f"
  zle .reset-prompt
  zle .accept-line
}

zle -N accept-line re-prompt

function set_dir_info() {
  dir_info="%K{magenta}%F{white} %~ %k%f"
}

function set-status-line() {
  status_line="%K{blue}%F{black} %n %k%f${dir_info}%f%k${git_info}
"    
}

#excute before display prompt
add-zsh-hook precmd git_info
add-zsh-hook precmd set-status-line


PROMPT='${status_line}%(?,%F{blue}»,%F{red}») %f' #left side
RPROMPT='%K{green}%F{black} %T %k%f'
PROMPT2='%F{blue}» %f' #second prompt
