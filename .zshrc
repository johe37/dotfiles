export ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"

# Skip insecure-directory audit during compinit.
ZSH_DISABLE_COMPFIX=true

# Which plugins would you like to load?
plugins=(
  git git-extras colored-man-pages common-aliases
  command-not-found dircycle dirhistory history
  zsh-syntax-highlighting ssh-agent ssh
  brew kubectl nmap
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Lets me jump between words with option + left/right arrow
bindkey "^[f" forward-word
bindkey "^[b" backward-word

# Environments
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export XDG_CONFIG_HOME="$HOME/.config"

# Include $HOME/.johe/zshrc.d/* user settings
for file in ~/.config/zshrc.d/* ; do source "$file" ; done

# My scripts
export PATH="$HOME/.scripts/:$PATH"
