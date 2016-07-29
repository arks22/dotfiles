#source separated files
for file in $(ls ~/dotfiles/zsh/zshrc); do
  source ~/dotfiles/zsh/zshrc/$file
done

#put symbolic links to ~/bin and grant permissions
for file in $(ls ~/dotfiles/zsh/functions); do
  ln -f ~/dotfiles/zsh/functions/$file ~/bin/$file
  chmod a+x ~/bin/$file
done
