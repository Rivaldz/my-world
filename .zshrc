# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If not running interactively, do not do anything
[[ $- != *i* ]] && return
# Otherwise start tmux
[[ -z "$TMUX" ]] && exec tmux

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# if [ -z "$TMUX" ]
# then
#     tmux attach -t TMUX || tmux new -s TMUX
# fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#export TERM='xterm-256color'

alias tmux="TERM=screen-256color-bce tmux"

#For phpcs
export PATH="$HOME/.config/composer/vendor/bin:$PATH"
#/home/rivaldosetyo/.config/composer

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

#Flutter 
export PATH="$PATH:/Users/rivaldosetyo/development/flutter/bin"

#main path 
export PATH="$PATH:/bin/bash"

#Go
#export GOROOT=/usr/bin/go
#export GOPATH=~/work/pms
export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$(go env GOPATH)/bin
export PATH=$PATH:$(go env GOBIN)


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#
#brew 
#export PATH=/usr/local/bin:$PATH

#react native
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

# ZSH_THEME="powerlevel9k/powerlevel9k"

ZSH_THEME="powerlevel10k/powerlevel10k"
#ZSH_THEME="emoji"

# POWERLEVEL9K_MODE='awesome-fontconfig'

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git 
	zsh-autosuggestions 
	vi-mode
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
#     custom_apple
#     dir 
#     vcs
#     newline 
#     status)
# POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(root_indicator background_jobs history time)
# POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

# Create a custom JavaScript prompt section

# POWERLEVEL9K_CUSTOM_APPLE="echo -n '\uf302'"
# POWERLEVEL9K_CUSTOM_APPLE_FOREGROUND="white"
# POWERLEVEL9K_CUSTOM_APPLE_BACKGROUND="black"

# source /usr/local/opt/powerlevel9k/powerlevel9k.zsh-theme
# source  ~/powerlevel9k/powerlevel9k.zsh-theme

#VERSI PHP XAMPP
export PATH=/Applications/XAMPP/bin:$PATH

#export PATH=/usr/local/etc/php/7.2:$PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
#export SDKMAN_DIR="$HOME/.sdkman"
#[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

#vim bind key
bindkey -M viins 'jf' vi-cmd-mode

#Golang path
#export GOPATH="/home/rivaldosetyo/go/pms/pms-service"
#export GO111MODULE=on

#export npm
export PATH="$HOME/npm/bin:$PATH"
#set nvim default
export VISUAL=nvim
export EDITOR="$VISUAL"
# Alias
alias pas='php artisan serve'
alias pas8001='php artisan serve --port=8001'
alias clr="clear"
alias dlocal="cd /mnt/c/Users/rivaa/"
alias php82="sudo update-alternatives --set php /usr/bin/php8.2 && sudo update-alternatives --set phar /usr/bin/phar8.2 && sudo update-alternatives --set phar.phar /usr/bin/phar.phar8.2"
alias php8="sudo update-alternatives --set php /usr/bin/php8.1 && sudo update-alternatives --set phar /usr/bin/phar8.1 && sudo update-alternatives --set phar.phar /usr/bin/phar.phar8.1"
alias php7="sudo update-alternatives --set php /usr/bin/php7.4 && sudo update-alternatives --set phar /usr/bin/phar7.4 && sudo update-alternatives --set phar.phar /usr/bin/phar.phar7.4"
alias php5="sudo update-alternatives --set php /usr/bin/php5.6 && sudo update-alternatives --set phar /usr/bin/phar5.6 && sudo update-alternatives --set phar.phar /usr/bin/phar.phar5.6"
alias clr="clear"
alias phpv="php -v"
alias route="php artisan route:cache"
source ~/powerlevel10k/powerlevel10k.zsh-theme

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
