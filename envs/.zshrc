ZSH_THEME="robbyrussell"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

eval "$(direnv hook zsh)"

alias src="source $HOME/.zshrc"
alias gsw="git switch"
alias gst="git status --short"
alias ga="git add"
alias gap="git add --patch"
alias gcm="git commit -m"
alias gd="git diff"
alias gds="git diff --staged"
alias gr="git restore" 
alias grs="git restore --staged"
alias gp="git push"
alias gl="git pull"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/home/levi/.bun/_bun" ] && source "/home/levi/.bun/_bun"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$HOME/dev/personal/dotfiles/bin:$PATH

