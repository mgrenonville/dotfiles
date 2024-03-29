# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="bira"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"





# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git vagrant sbt scala screen knife nix-shell knife_ssh)

source $ZSH/oh-my-zsh.sh

unsetopt correct_all
# Customize to your needs...
alias ls="ls --color"


cd() {
  builtin cd "$@" && ls  
}

export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64/

export VOLTDB_HOME=/tank/voltdb/voltdb-3.7
export M2_HOME=/tank/maven3/
export PLAY2_HOME=/tank/play2/

export PATH=$PLAY2_HOME:$M2_HOME/bin:/opt/idea/bin:/opt/firefox/:~/.bloop/:$PATH

export PAGER="less -FRX"
if [ -d /opt/firefox ] ; then
    PATH=/opt/firefox:$PATH
fi
export DEV_HOME=~/dev

export PATH=/tank/idea-IU-129.1359/bin/:$PATH
# The next line updates PATH for the Google Cloud SDK.
export PATH=/home/mgrenonville/google-cloud-sdk/bin:$PATH


[ -d ~/.ssh ] && find ~/.ssh/ -name "id_*" -not -name "*pub" -exec keychain '{}' +
[ -f ~/.keychain/$HOST-sh ] && source ~/.keychain/$HOST-sh

fpath=(~/dotfiles/completions/src $fpath)

setopt APPEND_HISTORY


[[ -z "$terminfo[kdch1]" ]] || bindkey -M vicmd "$terminfo[kdch1]" vi-delete-char
[[ -z "$terminfo[khome]" ]] || bindkey -M vicmd "$terminfo[khome]" vi-beginning-of-line
[[ -z "$terminfo[kend]" ]] || bindkey -M vicmd "$terminfo[kend]" vi-end-of-line
[[ -z "$terminfo[kich1]" ]] || bindkey -M vicmd "$terminfo[kich1]" overwrite-mode

bindkey '^[[1;5C' forward-word # [Ctrl-RightArrow] - move forward one word
bindkey '^[[1;5D' backward-word # [Ctrl-LeftArrow] - move backward one word

bindkey "^[Od" backward-word  \# control-left
bindkey "^[Oc" forward-word   \# control-right



export NVM_DIR="/home/mgrenonville/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

#export SBT_OPTS="$SBT_OPTS  -Dsbt.override.build.repos=true"

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
base16_tomorrow-night


autoload -U compinit
fpath=($HOME/.bloop/zsh $fpath)
compinit
