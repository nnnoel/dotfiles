#!bin/bash

source $HOME/.dotfiles/utils.sh

copy_to_clipboard "$(git rev-parse --abbrev-ref HEAD)"

