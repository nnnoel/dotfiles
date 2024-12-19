#!/bin/bash
# Author: Noel Colon

source $HOME/.dotfiles/utils.sh

new_branch_name=$1
current_branch_name=$(git rev-parse --abbrev-ref HEAD)

git branch -m "$current_branch_name" "$new_branch_name"

echo "Branch renamed from $(print_y "$current_branch_name") to $(print_y "$new_branch_name")"
