#!bin/sh

if which git >/dev/null 2>&1; then
  git clone https://github.com/arks22/dotfiles.git ~/dotfiles
else
  tarball="https://github.com/arks22/dotfiles/archive/master.tar.gz"
  if which curl >/dev/null 2>&1; then
    curl -L "$tarball"
  elif which wget >/dev/null 2>&1; then
    wget -O - "$tarball"
  fi | tar xv -
  mv -f dotfiles-master ~/dotfiles
fi

sh ~/dotfiles/setup/init.sh
