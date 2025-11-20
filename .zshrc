if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ -f "$HOME/.env-global" ]; then
  export $(grep -v '^#' $HOME/.env-global | xargs)
fi

# If not running interactively, do not do anything
[[ $- != *i* ]] && return
# Otherwise start tmux
[[ -z "$TMUX" ]] && exec tmux

alias tmux="TERM=screen-256color-bce tmux"

#For phpcs
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

source "$HOME/my-world/config.sh"

#ZSH_THEME="powerlevel10k/powerlevel10k"

# plugins=(
# 	git 
# 	zsh-autosuggestions 
# 	vi-mode
# )

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#vim bind key
bindkey -M viins 'jf' vi-cmd-mode

#export npm
export PATH="$HOME/npm/bin:$PATH"

#set nvim default
export VISUAL=nvim
export EDITOR="$VISUAL"

#source ~/powerlevel10k/powerlevel10k.zsh-theme

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias avante='nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'

#nix path, condition 
if [ -f /home/rivaldo/.nix-profile/etc/profile.d/nix.sh ]; then
  . /home/rivaldo/.nix-profile/etc/profile.d/nix.sh
fi


# Nix multi-user env
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi
