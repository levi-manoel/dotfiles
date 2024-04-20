source /home/levi/dev/scripts/git-prompt.sh

function changes_in_branch() { 
    if [ -d .git ] || [ -d ../.git ] || [ -d ../../.git ] || [ -d ../../../.git ] || [ -d ../../../../.git ]; then
	if expr length + "$(git status -s)" 2>&1 > /dev/null; then     
	    echo -ne "\033[0;33m$(__git_ps1)\033[0m"; 
	else
	    echo -ne "\033[0;32m$(__git_ps1)\033[0m"; fi; 
    fi
}

export XDG_DATA_HOME="$HOME/.local/share"

PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \[\033[0;36m\]\h \w\[\033[0m\]$(changes_in_branch)\n\[\033[0;32m\]└─\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\] ▶\[\033[0m\]  '

## general
alias source-bash="source /home/levi/.bashrc"
alias cd-personal="cd /home/levi/dev/personal"
alias cd-irancho="cd /home/levi/dev/irancho"

## nixos
alias nixos-config="sudo bash /home/levi/dev/scripts/sync-config-files.sh"

## git
alias gst="git status"
alias ga="git add"
alias gcmsg="git commit -m"
alias gp="git push"
alias gl="git pull"
alias gunst="git restore --staged"
alias gcp="git cherry-pick"
