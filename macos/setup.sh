#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  exit 1
fi

if [ ! -d ~/Developer  ]; then
	mkdir ~/Developer
fi

if [ ! -d ~/.dotfiles]; then
	ln -s . ~/.dotfiles
fi

cd ~/Downlaods
curl -O https://iterm2.com/downloads/stable/iTerm2-3_1_6.zip
curl -O https://s3.amazonaws.com/spectacle/downloads/Spectacle+1.2.zip

cd ~/.dotfiles
curl -o- https://raw.githubusercontent.com/Homebrew/install/master/install | usr/bin/ruby 
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
curl -o- https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

brews=(
  zsh
  fzf
  ag
  ctags
  yarn
  hub
  ffmpeg
)

in_list(){
  pkg=$1
  shift
  for item in $@; do
    if [ "$pkg" == "$item" ]; then
      return 0
    fi
  done
  return 1
}

for pkg in ${brews[@]}; do
  if ! in_list $pkg "$(brew list)"; then
    if brew install $pkg >/dev/null 2>&1; then
		exit 0
    fi
  fi
done

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
