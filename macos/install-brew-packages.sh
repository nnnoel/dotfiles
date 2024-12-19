#!/bin/bash

FILE="brew-packages.txt"

if [[ ! -f "$FILE" ]]; then
  echo "❌ Error: File '$FILE' not found!"
  exit 1
fi

echo "🍺 Starting Homebrew package installation... 🚀"

while IFS= read -r line; do
  [[ -z "$line" || "$line" =~ ^# ]] && continue

  if brew info --cask "$line" >/dev/null 2>&1; then
    echo "📦 Installing cask: $line 🖥️"
    brew install --cask "$line"
  else
    echo "🔧 Installing formula: $line 🛠️"
    brew install "$line"
  fi
done <"$FILE"

echo "✅ All Homebrew packages from '$FILE' have been installed! 🎉"
