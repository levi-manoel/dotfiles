ZSH_THEME="robbyrussell"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh
eval "$(direnv hook zsh)"

alias src="source $HOME/.zshrc"
export PATH=$HOME/dev/personal/dotfiles/bin:$PATH

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# go
export PATH="$PATH:/usr/local/go/bin"

# bun completions
[ -s "/home/levi/.bun/_bun" ] && source "/home/levi/.bun/_bun"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/levi/dev/irancho/google-cloud-sdk/path.zsh.inc' ]; then . '/home/levi/dev/irancho/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/levi/dev/irancho/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/levi/dev/irancho/google-cloud-sdk/completion.zsh.inc'; fi

