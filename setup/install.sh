#!bin/sh

if which git ; then
  git clone https://github.com/arks22/dotfiles.git ~/dotfiles
elif which curl || which wget; then
  tarball="https://github.com/arks22/dotfiles/archive/master.tar.gz"
  if which curl; then
    curl -L "$tarball"
  elif which curl; then
    wget -O - "$tarball"
  fi | tar xv -
  mv -f dotfiles-master ~/dotfiles
else
  echo "curl or wget required"
fi

#sh ~/dotfiles/setup/init.sh
