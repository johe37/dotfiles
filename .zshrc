# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Skip insecure-directory audit during compinit.
ZSH_DISABLE_COMPFIX=true

# Don't print "Starting ssh-agent ..." (breaks p10k instant prompt after reboot).
zstyle :omz:plugins:ssh-agent quiet yes

# Which plugins would you like to load?
plugins=(
  git git-extras colored-man-pages common-aliases
  command-not-found dircycle dirhistory history
  zsh-syntax-highlighting ssh-agent ssh
  brew kubectl nmap
)

# Grok completions must be on fpath before oh-my-zsh runs compinit.
# A second compinit at the bottom rewrote the dump file on every start.
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)

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


# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
# <<< grok installer <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
