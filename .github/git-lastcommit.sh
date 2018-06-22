#!bin/bash

# Mac
if [[ $(uname) == 'Darwin'  ]]; then
	git show -s --format=%h | pbcopy
	echo "Copied: $(git show -s --format=%h)"
fi
