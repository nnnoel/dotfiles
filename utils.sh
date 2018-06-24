# Author: Noel Colon
# Description: Reuseable util helpers for scripting

# Text styling
bold=$(tput bold) # Bold
smul=$(tput smul) # Underline start
rmul=$(tput rmul) # Underline end
smso=$(tput smso) # Standout start
rmso=$(tput rmso) # Standout end
normal=$(tput sgr0) # Normalize text
# Foreground coloring
red=$(tput setaf 1)
green=$(tput setaf 46)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
magenta=$(tput setaf 5)

print_y(){
	printf "${yellow}%s${normal}" "$@"
}

copy_to_clipboard() {	
	if [[ $(uname) == 'Darwin'  ]]; then
		echo "$@" | pbcopy
		printf "Copied: ${yellow}%s${normal}\n" "$@"
	fi
}

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

