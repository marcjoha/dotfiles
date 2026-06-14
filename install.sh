#!/bin/bash
# install.sh - Safely symlink dotfiles from this repo to the home directory.

set -euo pipefail

# Directories
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="${SCRIPT_DIR}/dotfiles"
BACKUP_DIR="${HOME}/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# The list of configuration files inside the dotfiles/ subfolder
FILES=(
  "bash_profile"
  "bashrc"
  "tmux.conf"
  "vimrc"
  "gitconfig"
)

echo "=== Initializing Dotfiles Installation ==="

create_symlink() {
  local src="$1"
  local dest="$2"

  # Check if file exists or is a broken symlink
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    # If it is already a symlink pointing to the correct place, do nothing
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$src" ]; then
      echo "✅ $dest is already correctly linked."
      return
    fi

    # Otherwise, back it up safely
    echo "⚠️  Found existing file/link at $dest. Backing up to $BACKUP_DIR..."
    mkdir -p "$BACKUP_DIR"
    mv "$dest" "$BACKUP_DIR/"
  fi

  # Create the symlink
  ln -s "$src" "$dest"
  echo "🔗 Created symlink: $dest -> $src"
}

for file in "${FILES[@]}"; do
  create_symlink "${DOTFILES_DIR}/${file}" "${HOME}/.${file}"
done

echo "=== Dotfiles Installation Complete! ==="
