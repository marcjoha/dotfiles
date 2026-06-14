#!/bin/bash
# install.sh - Safely symlink dotfiles from this repo to the home directory.

set -euo pipefail

# Directories
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOTFILES_DIR="${SCRIPT_DIR}/dotfiles"
BACKUP_DIR="${HOME}/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

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

# Enable nullglob to handle empty folders or non-matching globs safely
shopt -s nullglob

# Dynamically discover all files and directories in the dotfiles/ subfolder
for src in "${DOTFILES_DIR}"/*; do
  # Skip if the item doesn't exist
  [ -e "$src" ] || continue

  # Get the basename (e.g. "bash_profile", "config", "vim")
  file="$(basename "$src")"

  if [ "$file" = "config" ]; then
    # Special safety handling for the .config directory to prevent wiping out other untracked configs
    echo "📂 Processing config/ subdirectory..."
    mkdir -p "${HOME}/.config"
    for sub_src in "${src}"/*; do
      [ -e "$sub_src" ] || continue
      sub_file="$(basename "$sub_src")"
      create_symlink "$sub_src" "${HOME}/.config/${sub_file}"
    done
  else
    # Standard dotfile/dotfolder symlinking
    dest="${HOME}/.${file}"
    create_symlink "$src" "$dest"
  fi
done

echo "=== Dotfiles Installation Complete! ==="
