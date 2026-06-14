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

# --- Antigravity CLI Autoconfiguration ---
echo "=== Configuring Antigravity CLI Settings ==="
AGY_SETTINGS_DIR="${HOME}/.gemini/antigravity-cli"
AGY_SETTINGS_FILE="${AGY_SETTINGS_DIR}/settings.json"

if [ -d "$AGY_SETTINGS_DIR" ] || mkdir -p "$AGY_SETTINGS_DIR"; then
  # If the settings.json file does not exist, initialize it
  if [ ! -f "$AGY_SETTINGS_FILE" ]; then
    echo "📄 Creating new Antigravity settings.json..."
    cat << 'EOF' > "$AGY_SETTINGS_FILE"
{
  "statusLine": {
    "type": "command",
    "command": "HOME_REPLACE/.antigravitycli/statusline.sh"
  },
  "title": {
    "type": "command",
    "command": "HOME_REPLACE/.antigravitycli/title.sh"
  }
}
EOF
    # Safely replace HOME_REPLACE with actual $HOME path
    sed -i '' "s|HOME_REPLACE|${HOME}|g" "$AGY_SETTINGS_FILE" 2>/dev/null || sed -i "s|HOME_REPLACE|${HOME}|g" "$AGY_SETTINGS_FILE"
    echo "✅ Antigravity settings.json created and configured."
  else
    # If settings.json exists, merge statusLine and title using python3 to avoid destroying existing settings
    echo "📄 Existing Antigravity settings.json found. Merging custom scripts..."
    python3 -c "
import json, os
path = '$AGY_SETTINGS_FILE'
home = os.path.expanduser('~')
try:
    with open(path, 'r') as f:
        data = json.load(f)
except Exception:
    data = {}

if 'statusLine' not in data or not isinstance(data['statusLine'], dict):
    data['statusLine'] = {}
data['statusLine']['type'] = 'command'
data['statusLine']['command'] = os.path.join(home, '.antigravitycli/statusline.sh')

if 'title' not in data or not isinstance(data['title'], dict):
    data['title'] = {}
data['title']['type'] = 'command'
data['title']['command'] = os.path.join(home, '.antigravitycli/title.sh')

with open(path, 'w') as f:
    json.dump(data, f, indent=2)
" && echo "✅ Antigravity settings.json successfully updated." || echo "⚠️  Failed to update settings.json automatically. Please manually configure the scripts in $AGY_SETTINGS_FILE."
  fi
else
  echo "⚠️  Could not access or create $AGY_SETTINGS_DIR. Skipping Antigravity settings setup."
fi

echo "=== Dotfiles Installation Complete! ==="
