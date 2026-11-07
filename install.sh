#!/bin/bash
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Symlink configurations
mkdir -p "${HOME}/.config/ghostty"
ln -sf "${DOTFILES}/vimrc" "${HOME}/.vimrc"
ln -sf "${DOTFILES}/ghostty/config" "${HOME}/.config/ghostty/config"

# Ensure Vim Gruvbox Material theme is present
THEME_DIR="${HOME}/.vim/pack/themes/start/gruvbox-material"
if [ ! -d "${THEME_DIR}" ]; then
  echo "Installing Vim gruvbox-material theme..."
  mkdir -p "$(dirname "${THEME_DIR}")"
  git clone --depth 1 https://github.com/sainnhe/gruvbox-material.git "${THEME_DIR}"
fi

echo "✅ Dotfiles installed successfully."
