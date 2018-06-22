#!bin/bash

# Mac
if [[ $(uname) == 'Darwin'  ]]; then
	git rev-parse --abbrev-ref HEAD | pbcopy
	echo "Copied: $(git rev-parse --abbrev-ref HEAD)"
fi

