export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

plugins=(git gcloud)

eval "$(direnv hook zsh)"

alias src="source $HOME/.zshrc"
alias gst="git status --short"
alias gcm="git commit -m"
alias gds="git diff --staged"
alias gr="git restore" 
alias grs="git restore --staged"
alias gap="git add --patch"

# bun completions
[ -s "/home/levi/.bun/_bun" ] && source "/home/levi/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH=$HOME/dev/personal/dotfiles/bin:$PATH

