#!bin/sh

if which git >/dev/null 2>&1; then
  echo "Downloading dotfiles with git..."
  git clone https://github.com/arks22/dotfiles.git ~/dotfiles
else
  tarball="https://github.com/arks22/dotfiles/archive/master.tar.gz"
  if which curl >/dev/null 2>&1; then
    echo "Downloading dotfiles with curl..."
    curl -L "$tarball" | tar xv -
  elif which wget >/dev/null 2>&1; then
    echo "Downloading dotfiles with wget..."
    wget -O - "$tarball" | tar xv -
  fi
  mv -f dotfiles-master ~/dotfiles
fi

#sh ~/dotfiles/setup/init.sh
