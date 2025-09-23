ZSH_THEME="robbyrussell"
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"

alias src="source $HOME/.zshrc"
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias cd="zd"

export PATH=$HOME/dev/personal/dotfiles/bin:$PATH

# nix
if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# bun completions
[ -s "/home/levi/.bun/_bun" ] && source "/home/levi/.bun/_bun"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/levi/dev/irancho/google-cloud-sdk/path.zsh.inc' ]; then . '/home/levi/dev/irancho/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/levi/dev/irancho/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/levi/dev/irancho/google-cloud-sdk/completion.zsh.inc'; fi

zd() {
  if [ $# -eq 0 ]; then
    builtin cd ~ && return
  elif [ -d "$1" ]; then
    builtin cd "$1"
  else
    z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
  fi
}
