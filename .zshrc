export ZSH="$HOME/.dotfiles/.oh-my-zsh"

ZSH_THEME="af-magic"

plugins=(
  # git
  jira
)

ZSH_DISABLE_COMPFIX=true

JIRA_URL=https://jira.atlassian.com
JIRA_PREFIX=
JIRA_NAME=noel
JIRA_RAPID_BOARD=true
JIRA_DEFAULT_ACTION=dashboard

if (( ! ${fpath[(I)/usr/local/share/zsh/site-functions]} )); then
  FPATH=/usr/local/share/zsh/site-functions:$FPATH
fi

source $ZSH/oh-my-zsh.sh
source $HOME/.dotfiles/.aliases

# if [ "$TERM" == "xterm" ]; then
# 	export TERM=xterm-256color
# fi

export LANG=en_US.UTF-8
export EDITOR='vim'


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export NVM_DIR="$HOME/.dotfiles/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Helpers
make_js_ctags() {
    if ctags -R $@ -L ~/.dotfiles/.ctags; then
	echo 'Tags generated'
	return 0
    else
	echo 'Error generating tags'
	return 1
    fi
}
alias makejstags="make_js_ctags $@"
