# Oh My Zsh Configuration
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="chuck"
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-interactive-cd
)
source $ZSH/oh-my-zsh.sh

# Aliases
source $HOME/.aliases

# Editor
export EDITOR='vim'

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# PATH Configurations
# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1

# OpenSSL
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

# Android
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"

# PNPM
export PNPM_HOME="$HOME/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"

# Flashlight
export PATH="$HOME/.flashlight/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Maestro
export PATH="$PATH:$HOME/.maestro/bin"

# Windsurf
export PATH="$HOME/.codeium/windsurf/bin:$PATH"

# Expo
export EXPO_NO_CAPABILITY_SYNC=1

# Zsh History
export HISTSIZE=8000
export SAVEHIST=8000

# Environment Variables
source $HOME/.zshenv

# Conda Initialization
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Auto tmux Session
if [ -z "$TMUX" ]; then
    if [ "$TERM_PROGRAM" = "iTerm.app" ]; then
        tmux attach-session -t default || tmux new-session -s default
    fi
fi
