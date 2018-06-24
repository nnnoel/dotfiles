#!/bin/bash
# Author: Noel Colon

source $HOME/.dotfiles/utils.sh

i=0
BRANCHES=()
eval "$(git for-each-ref --format='BRANCHES+=(%(refname:lstrip=2))' refs/heads/)"

printf "\nSelect an option:\n"
printf "($(print_y "a")) Checkout | ($(print_y "b")) Delete | ($(print_y "c")) Copy\n"
read option

printf "\nSelect a branch:\n"
for b in "${BRANCHES[@]}"; do
	printf "($(print_y %d)) %s \n" $i $b
	((i++))
done

read choice

BRANCH="${BRANCHES[choice]}"

case "$option" in
	"a"):
		printf "Checkout $(print_y $BRANCH) ? (y/n)\n" 
		read confirmation
		if [[ $confirmation == 'y'  ]]; then
			git checkout $BRANCH
			exit 0
		fi
		;;
	"b"):
		printf "Delete $(print_y $BRANCH) ? (y/n)\n" 
		read confirmation
		if [[ $confirmation == 'y'  ]]; then
			git branch -D $BRANCH
			exit 0
		fi
		;;
	"c"):
		printf "Copy $(print_y $BRANCH) ? (y/n)\n" 
		read confirmation
		if [[ $confirmation == 'y'  ]]; then
			copy_to_clipboard $BRANCH
			exit 0
		fi
		;;
esac

