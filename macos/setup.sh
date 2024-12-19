#!/bin/bash

set -e

log() {
  echo -e "✨ \033[1;32m[INFO]\033[0m $1"
}

error() {
  echo -e "❌ \033[1;31m[ERROR]\033[0m $1"
}

DOTFILES_REPO_URL="https://github.com/nnnoel/dotfiles.git"
DOTFILES_TARGET_DIR=~/dev/personal/dotfiles

clone_dotfiles() {
  log "🛠️  Cloning dotfiles repository into $DOTFILES_TARGET_DIR..."
  if [[ -d "$DOTFILES_TARGET_DIR" ]]; then
    log "🗂️  Dotfiles already cloned at $DOTFILES_TARGET_DIR."
  else
    git clone "$DOTFILES_REPO_URL" "$DOTFILES_TARGET_DIR"
  fi
}

setup_directories() {
  log "📂 Creating base directories..."
  mkdir -p ~/dev/{personal,work,experiments,open-source,utilities}
}

symlink_dotfiles() {
  log "🔗 Creating symlinks for dotfiles..."
  bash "$DOTFILES_TARGET_DIR/macos/symlink-dotfiles.sh"
}

install_packages() {
  log "📦 Installing Homebrew and packages..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  bash "$DOTFILES_TARGET_DIR/macos/install-brew-packages.sh"
}

set_default_shell_to_zsh() {
  log "🔧 Checking if Zsh is the default shell..."

  if [[ "$SHELL" == "$(which zsh)" ]]; then
    log "✅ Zsh is already the default shell."
    return
  fi

  if ! grep -q "$(which zsh)" /etc/shells; then
    log "⚠️  Zsh is not listed in /etc/shells. Adding it now..."
    which zsh | sudo tee -a /etc/shells >/dev/null
    log "✅ Zsh added to /etc/shells."
  fi

  log "🔄 Changing the default shell to Zsh..."
  if chsh -s "$(which zsh)"; then
    log "✅ Default shell successfully changed to Zsh."
  else
    error "❌ Failed to change the default shell. Please run the following manually:"
    error "   sudo chsh -s $(which zsh) $USER"
    exit 1
  fi
}

install_oh_my_zsh() {
  log "💻 Installing Oh My Zsh..."
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    log "✅ Oh My Zsh installed."
  else
    log "🔄 Oh My Zsh is already installed. Skipping."
  fi
}

symlink_zsh_themes() {
  log "🔗 Symlinking custom Zsh themes..."
  THEMES_DIR="$HOME/.oh-my-zsh/custom/themes"
  mkdir -p "$THEMES_DIR"
  ln -sf "$DOTFILES_TARGET_DIR/themes/zsh/"* "$THEMES_DIR/"
  log "✅ Custom Zsh themes linked."
}

setup_iterm2_themes() {
  log "🎨 Setting up iTerm2 themes..."

  DEFAULT_ITERM2_PROFILE="Chuck"

  for file in "$DOTFILES_TARGET_DIR/themes/iterm2/"*.itermcolors; do
    log "🔗 Importing theme: $file..."
    open "$file"
  done

  ITERM2_PROFILES_DIR="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
  mkdir -p "$ITERM2_PROFILES_DIR"
  if [ -f "$DOTFILES_TARGET_DIR/themes/iterm2/${DEFAULT_ITERM2_PROFILE}.json" ]; then
    log "🔗 Linking profile: $DEFAULT_ITERM2_PROFILE.json..."
    ln -sf "$DOTFILES_TARGET_DIR/themes/iterm2/${DEFAULT_ITERM2_PROFILE}.json" "$ITERM2_PROFILES_DIR/${DEFAULT_ITERM2_PROFILE}.json"
  else
    error "⚠️ Profile $DEFAULT_ITERM2_PROFILE.json not found in themes/iterm2."
  fi

  log "✅ iTerm2 themes and profiles configured with default profile: $DEFAULT_ITERM2_PROFILE."
}

install_custom_fonts() {
  log "🔤 Installing custom Nerd Fonts..."

  FONT_SOURCE_DIR="$DOTFILES_TARGET_DIR/macos/nerd-fonts"
  FONT_DEST_DIR="$HOME/Library/Fonts"

  mkdir -p "$FONT_DEST_DIR"

  if [ -d "$FONT_SOURCE_DIR" ]; then
    for font in "$FONT_SOURCE_DIR"/*.ttf; do
      log "📁 Installing font: $(basename "$font")"
      cp "$font" "$FONT_DEST_DIR/"
    done
    log "✅ Fonts installed successfully to $FONT_DEST_DIR."
  else
    error "⚠️ Font source directory not found: $FONT_SOURCE_DIR"
  fi
}

setup_ssh() {
  log "🔐 Setting up SSH configuration..."

  SSH_CONFIG_SOURCE_DIR="$DOTFILES_TARGET_DIR/ssh"
  SSH_CONFIG_DEST_DIR="$HOME/.ssh"

  log "📂 Ensuring SSH directory exists at $SSH_CONFIG_DEST_DIR..."
  mkdir -p "$SSH_CONFIG_DEST_DIR"

  if [ -f "$SSH_CONFIG_SOURCE_DIR/config" ]; then
    log "🔗 Symlinking SSH config..."
    ln -sf "$SSH_CONFIG_SOURCE_DIR/config" "$SSH_CONFIG_DEST_DIR/config"
  else
    error "⚠️ SSH config file not found: $SSH_CONFIG_SOURCE_DIR/config"
  fi

  if [ -d "$SSH_CONFIG_SOURCE_DIR/config.d" ]; then
    log "🔗 Symlinking SSH config.d directory..."
    ln -sf "$SSH_CONFIG_SOURCE_DIR/config.d" "$SSH_CONFIG_DEST_DIR/config.d"
  else
    error "⚠️ SSH config.d directory not found: $SSH_CONFIG_SOURCE_DIR/config.d"
  fi

  log "🔒 Setting correct permissions on $SSH_CONFIG_DEST_DIR..."
  chmod 700 "$SSH_CONFIG_DEST_DIR"

  if [ -f "$SSH_CONFIG_DEST_DIR/config" ]; then
    chmod 600 "$SSH_CONFIG_DEST_DIR/config"
  fi

  log "✅ SSH setup completed successfully."
}

run_platform_setup() {
  log "🍏 Running macOS-specific setup..."
  bash "$DOTFILES_TARGET_DIR/macos/macos-privacy.sh"
}

main() {
  log "🍏 Starting macOS setup..."
  setup_directories
  clone_dotfiles
  symlink_dotfiles
  install_packages
  set_default_shell_to_zsh
  install_oh_my_zsh
  symlink_zsh_themes
  install_custom_fonts
  setup_iterm2_themes
  setup_ssh
  run_platform_setup
  log "🎉 macOS setup completed successfully!"
}

main "$@"
