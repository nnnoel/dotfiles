# Text styling
normal=$(tput sgr0) # Normalize text
# Foreground coloring
yellow=$(tput setaf 3)

print_y() {
  printf "${yellow}%s${normal}" "$@"
}

copy_to_clipboard() {
  if [[ $(uname) == 'Darwin' ]]; then
    echo "$@" | pbcopy | awk '{$1=$1};1'
    printf "Copied: ${yellow}%s${normal}\n" "$@"
  fi
}
