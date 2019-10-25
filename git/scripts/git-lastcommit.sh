#!bin/bash

source $HOME/.dotfiles/utils.sh

copy_to_clipboard "$(git show -s --format=%h)"
