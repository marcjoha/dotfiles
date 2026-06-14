#!/bin/bash
# hooks/antigravitycli.sh - Configure Antigravity CLI custom statusline and title scripts.

set -euo pipefail

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
