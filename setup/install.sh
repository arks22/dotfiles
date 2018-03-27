#!bin/bash

if [ ! -e $HOME/dotfiles ]; then
  if type git >/dev/null 2>&1; then
    echo "Downloading dotfiles with git..."
    git clone https://github.com/arks22/dotfiles.git $HOME/dotfiles
  else
    tarball="https://github.com/arks22/dotfiles/archive/master.tar.gz"
    if type curl >/dev/null 2>&1; then
      echo "Downloading dotfiles with curl..."
      curl -L "$tarball" | tar zx
    elif type wget >/dev/null 2>&1; then
      echo "Downloading dotfiles with wget..."
      wget -O - "$tarball" | tar zx
    fi
    mv -f dotfiles-master ~/dotfiles
  fi
else
  echo "dotfiles are already exists."
  echo "If you want to install arks22/dotfiles, you need to delete ( or move ) your ~/dotfiles."
fi

bash $HOME/dotfiles/commands/dotmanager link
bash $HOME/dotfiles/commands/dotmanager init
