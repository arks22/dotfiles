#prompt config

#excute before display prompt
function precmd() {
  if git_info=$(git status 2>/dev/null ); then
    [[ $git_info =~ "Changes not staged" ]] &&  git_unstaged="%K{blue}%F{black} ± %f%k" || git_unstaged=""
    [[ $git_info =~ "Changes to be committed" ]] && git_uncommited="%{[30;48;5;013m%}%F{black} + %k%f" || git_uncommited=""
    [ -z "${git_unstaged}${git_uncommited}" ] && git_clean="%K{green}%F{black} ✔ %f%k" || git_clean=""
    git_branch="$(echo $git_info | awk 'NR==1 {print $3}')"
    git_info="%K{black} ${git_branch} ${git_unstaged}${git_uncommited}${git_clean}"
  fi
  [ $(whoami) = "root" ] && root="%K{black}%F{yellow} ⚡ %{[38;5;010m%}│%f%k"
  dir_info=$dir
  dir="%F{cyan}%K{black} %~ %k%f"
}

dir="%F{cyan}%K{black} %~ %k%f"

PROMPT='%(?,,%K{red}%F{white} ✘ %k%f)${root}${dir_info} '
RPROMPT='${git_info}'
PROMPT2='%F{blue}» %f'
