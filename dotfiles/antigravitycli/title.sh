#!/bin/bash
set -euo pipefail

# Read JSON payload from stdin
DATA=$(cat)

eval $(echo "$DATA" | jq -r '
  "STATE=\"\(.agent_state // "idle")\"
   CWD=\"\(.workspace.current_dir // "")\"
  "
' 2>/dev/null || echo 'STATE="idle" CWD=""')

if [ -n "$CWD" ]; then
  WORKSPACE=$(basename "$CWD")
else
  WORKSPACE="unknown"
fi

# Add an emoji based on the current state
case "$STATE" in
  idle) EMOJI="☕" ;;
  thinking|running|working) EMOJI="🧠" ;;
  error|failed) EMOJI="❌" ;;
  tool*|calling*) EMOJI="🛠️" ;;
  waiting) EMOJI="⏳" ;;
  *) EMOJI="✨" ;;
esac

# Output the title string
echo "$EMOJI agy: $STATE — $WORKSPACE"
