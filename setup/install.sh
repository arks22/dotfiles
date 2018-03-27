#!bin/bash

if [ ! -e $HOME/dotfiles ]; then
  if type git >/dev/null 2>&1; then
    echo "Downloading dotfiles with git..."
    git clone https://github.com/arks22/dotfiles.git ~/dotfiles
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

chmod +x ~/dotfiles/commands/dotmanager
ln -s ~/dotfiles/commands/dotmanager /usr/local/bin/dotmanager

dotmanager link
dotmanager init
