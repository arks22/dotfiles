if has "git"; then
  git clone https://github.com/arks22/dotfiles.git ~/dotfiles
elif has "curl" || has "wget"; then
  tarball="https://github.com/arks22/dotfiles/archive/master.tar.gz"
  if has "curl"; then
    curl -L "$tarball"
  elif has "wget"; then
    wget -O - "$tarball"
  fi | tar xv -
  mv -f dotfiles-master ~/dotfiles
else
  echo "curl or wget required"
fi

sh ~/dotfiles/setup/init.sh
