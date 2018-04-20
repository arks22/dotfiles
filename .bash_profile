if [ -f ~/.bashrc ] ; then
. ~/.bashrc
fi

export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH=$HOME/.rbenv/bin:$PATH
export PATH=$HOME/.nodebrew/current/bin:$PATH
export CC=/usr/bin/gcc
export PATH=$PATH:$HOME/dotfiles/bin
