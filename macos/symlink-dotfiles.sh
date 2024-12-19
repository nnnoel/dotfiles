#!/bin/bash

if [[ -z "$DOTFILES_DIR" ]]; then
  echo "❌ DOTFILES_DIR is not set. Please define it before running this script."
  exit 1
fi

FILES_TO_SYMLINK=(
  ".aliases"
  ".config"
  ".gitconfig"
  ".tigrc"
  ".tmux.conf"
  ".zshrc"
  ".ssh"
)

create_symlinks() {
  for file in "${FILES_TO_SYMLINK[@]}"; do
    SOURCE="$DOTFILES_DIR/$file"
    DESTINATION="$HOME/$file"

    if [ -e "$DESTINATION" ] || [ -L "$DESTINATION" ]; then
      echo "⚠️  $DESTINATION already exists. Backing up to ${DESTINATION}.backup"
      mv "$DESTINATION" "${DESTINATION}.backup"
    fi

    echo "🔗 Creating symlink: $DESTINATION -> $SOURCE"
    ln -s "$SOURCE" "$DESTINATION"
  done
}

create_symlinks

echo "✅ Symlinking completed!"
