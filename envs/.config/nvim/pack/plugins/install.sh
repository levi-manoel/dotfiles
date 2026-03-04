#!/usr/bin/env bash
# Install plugins for native Neovim package manager (pack/).
# Run from this script's directory or from ~/.config/nvim.

set -e
PACK_DIR="$(cd "$(dirname "$0")" && pwd)"
PACK_START="${PACK_DIR}/start"
mkdir -p "$PACK_START"
cd "$PACK_START"

clone() {
  local repo=$1
  local dir=${2:-$(basename "$repo")}
  local branch=$3
  local tag=$4
  if [[ -d "$dir" ]]; then
    echo "  skip (exists): $dir"
    return
  fi
  local -a opts=(--depth 1)
  if [[ -n "$branch" ]]; then
    opts+=(--branch "$branch")
  fi
  if [[ -n "$tag" ]]; then
    opts=(--depth 1 --branch "$tag" --single-branch)
  fi
  echo "  clone: $repo -> $dir"
  git clone "${opts[@]}" "https://github.com/${repo}.git" "$dir"
}

echo "Installing plugins to $PACK_START"

# Dependencies (load first by naming / order)
clone "nvim-lua/plenary.nvim"

# UI / colors
clone "rose-pine/neovim" "neovim"

# Editing / navigation
clone "nvim-telescope/telescope.nvim" "telescope.nvim" "" "0.1.5"
clone "ThePrimeagen/harpoon" "harpoon" "harpoon2"
clone "MagicDuck/grug-far.nvim"
clone "mbbill/undotree"
clone "sbdchd/neoformat"

# LSP and completion
clone "neovim/nvim-lspconfig"
clone "williamboman/mason.nvim" "mason.nvim"
clone "williamboman/mason-lspconfig.nvim" "mason-lspconfig.nvim"
clone "hrsh7th/nvim-cmp"
clone "hrsh7th/cmp-nvim-lsp"
clone "j-hui/fidget.nvim" "fidget.nvim"
clone "nanotee/sqls.nvim" "sqls.nvim"

# Treesitter
clone "nvim-treesitter/nvim-treesitter"
clone "nvim-treesitter/nvim-treesitter-context"

# Diagnostics / trouble
clone "folke/trouble.nvim" "trouble.nvim"

# Games / fun
clone "eandrju/cellular-automaton.nvim"
clone "piersolenski/skifree.nvim"
clone "theprimeagen/vim-be-good" "vim-be-good"

# Copilot
clone "github/copilot.vim" "copilot.vim"

echo "Done. Run :checkhealth and :TSUpdate if needed."
