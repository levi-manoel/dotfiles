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

dalepapai() {
  if git diff --staged --quiet; then
    echo "Error: No staged changes found. Run 'git add' first."
    return 1
  fi

  echo "Generating commit message..."
  
  local raw_output
  raw_output=$(copilot --model "gpt-4.1" -p "Review ONLY the STAGED git changes (e.g., via git diff --staged). Completely ignore unstaged files. Write a concise, conventional git commit message (feat, fix, chore, etc.) for the staged changes. Output ONLY the raw commit string. Do not output usage stats, markdown, or conversational text.")

  if [ -z "$raw_output" ]; then
    echo "Failed to generate message. The AI tool returned nothing."
    return 1
  fi

  local msg
  msg=$(echo "$raw_output" | grep -E "^(feat|fix|chore|refactor|docs|style|test|perf|ci|build|revert)(\(|: )" | tail -n 1)

  if [ -z "$msg" ]; then
    echo "Error: Could not parse a clean conventional commit message from the AI output."
    echo "Raw output was:"
    echo "$raw_output"
    return 1
  fi

  echo -e "\nProposed commit message:"
  echo "$msg"
  echo ""
  
  printf "Commit with this message? (y/n): "
  read -r confirm
  
  if [[ "$confirm" == [yY] || "$confirm" == [yY][eE][sS] ]]; then
    git commit -m "$msg"
  else
    echo "Commit aborted."
  fi
}
