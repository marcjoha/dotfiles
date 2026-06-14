#!/bin/bash
set -euo pipefail

# ─── ANSI Helpers (True Color Solarized Dark) ─────────────────────────────────
R="\033[0m"         # Reset
B="\033[1m"         # Bold
D="\033[2m"         # Dim
I="\033[3m"         # Italic

# Precise Solarized Dark Colors (True Color 24-bit RGB)
SOL_BASE03="\033[38;2;0;30;39m"     # Background (High Contrast)
SOL_BASE02="\033[38;2;0;40;49m"     # Background Highlights
SOL_BASE01="\033[38;2;88;110;117m"   # Comments / Separators / Labels
SOL_BASE00="\033[38;2;101;123;131m"  # Muted body text
SOL_BASE0="\033[38;2;131;148;150m"   # Main body text
SOL_BASE1="\033[38;2;147;161;161m"   # Highlight body text
SOL_BASE2="\033[38;2;238;232;213m"   # Light background
SOL_BASE3="\033[38;2;253;246;227m"   # Light background highlight

SOL_YELLOW="\033[38;2;181;137;0m"
SOL_ORANGE="\033[38;2;203;75;22m"
SOL_RED="\033[38;2;220;50;47m"
SOL_MAGENTA="\033[38;2;211;54;130m"
SOL_VIOLET="\033[38;2;108;113;196m"
SOL_BLUE="\033[38;2;38;139;210m"
SOL_CYAN="\033[38;2;42;161;152m"
SOL_GREEN="\033[38;2;133;153;0m"

# Map script colors to Solarized TrueColor
FG_BLACK="${SOL_BASE02}"
FG_RED="${SOL_RED}"
FG_GREEN="${SOL_GREEN}"
FG_YELLOW="${SOL_YELLOW}"
FG_BLUE="${SOL_BLUE}"
FG_MAGENTA="${SOL_MAGENTA}"
FG_CYAN="${SOL_CYAN}"
FG_WHITE="${SOL_BASE1}"

FG_GRAY="${SOL_BASE01}"
FG_BRIGHT_RED="${SOL_ORANGE}"
FG_BRIGHT_GREEN="${SOL_GREEN}"
FG_BRIGHT_YELLOW="${SOL_YELLOW}"
FG_BRIGHT_BLUE="${SOL_BLUE}"
FG_BRIGHT_MAGENTA="${SOL_VIOLET}"
FG_BRIGHT_CYAN="${SOL_CYAN}"
FG_BRIGHT_WHITE="${SOL_BASE0}"

# True Color Override (now using standard precise Solarized Green)
FG_TRUE_GREEN="${SOL_GREEN}"

# Number Highlight Color
NUM_COLOR="${SOL_BASE0}${B}"

# ─── Parse JSON from stdin (Single jq pass for performance) ──────────────────
# Extract all fields in one pass to prevent spawning jq 8 times.
{
  read -r STATE
  read -r USED_PCT
  read -r VCS_BRANCH
  read -r VCS_DIRTY
  read -r SANDBOX
  read -r ARTIFACTS
  read -r SUBAGENTS
  read -r BG_TASKS
  read -r MODEL
  read -r COLS
} <<< "$(
  jq -r '
    (.agent_state // "idle"),
    (.context_window.used_percentage // 0),
    (.vcs.branch // ""),
    (.vcs.dirty // false),
    (.sandbox.enabled // false),
    (.artifact_count // 0),
    (if .subagents | type == "array" then (.subagents | length) else 0 end),
    (.task_count // 0),
    (.model.display_name // ""),
    (.terminal_width // 80)
  ' 2>/dev/null || printf "idle\n0\n\nfalse\nfalse\n0\n0\n0\n\n80\n"
)"

# ─── Computed Values ─────────────────────────────────────────────────────────
# Use LC_NUMERIC=C to prevent bash printf errors in locales that use commas for decimals
PCT_FMT=$(LC_NUMERIC=C printf "%.1f" "$USED_PCT")
PCT_INT=${USED_PCT%.*}; PCT_INT=${PCT_INT:-0}

# ─── State Indicator (With True Color Override for idle) ─────────────────────
case "$STATE" in
  idle)     S="${FG_TRUE_GREEN}${B}● READY${R}" ;;
  thinking) S="${FG_BRIGHT_YELLOW}${B}◆ THINKING${R}" ;;
  working)  S="${FG_BRIGHT_CYAN}${B}⚙ WORKING${R}" ;;
  tool_use) S="${FG_BRIGHT_MAGENTA}${B}🔧 TOOL${R}" ;;
  *)        S="${FG_WHITE}${B}⏳ $(echo "$STATE" | tr '[:lower:]' '[:upper:]')${R}" ;;
esac

# ─── VCS Branch ──────────────────────────────────────────────────────────────
V=""
if [ -n "$VCS_BRANCH" ]; then
  if [ "$VCS_DIRTY" = "true" ]; then
    V="${FG_GRAY} ╱ ${FG_BRIGHT_RED}${VCS_BRANCH}${FG_BRIGHT_YELLOW}*${R}"
  else
    V="${FG_GRAY} ╱ ${FG_BRIGHT_BLUE}${VCS_BRANCH}${R}"
  fi
fi

# ─── Model (No leading separator for right-alignment flexibility) ───────────
M=""
if [ -n "$MODEL" ]; then
  M="${FG_BRIGHT_MAGENTA}${I}${MODEL}${R}"
fi

# ─── Sandbox Badge ───────────────────────────────────────────────────────────
if [ "$SANDBOX" = "true" ]; then
  SB="${FG_GRAY}sandbox ${FG_BRIGHT_GREEN}${B}ON${R}"
else
  SB="${FG_GRAY}sandbox off${R}"
fi

# ─── Context Bar (15 segments, fine-grain Unicode) ────────────────────────────
BAR_LEN=15
FILLED=$((PCT_INT * BAR_LEN / 100))
REMAINDER=$(( (PCT_INT * BAR_LEN) % 100 ))

# Pick color based on percentage
if [ "$PCT_INT" -ge 90 ]; then
  BAR_COLOR="$FG_BRIGHT_RED"
elif [ "$PCT_INT" -ge 60 ]; then
  BAR_COLOR="$FG_BRIGHT_YELLOW"
else
  BAR_COLOR="$FG_BRIGHT_WHITE"
fi

# Build bar with partial-fill last block
BAR=""
for ((i = 0; i < BAR_LEN; i++)); do
  if [ "$i" -lt "$FILLED" ]; then
    BAR="${BAR}█"
  elif [ "$i" -eq "$FILLED" ]; then
    if [ "$REMAINDER" -ge 75 ]; then
      BAR="${BAR}▓"
    elif [ "$REMAINDER" -ge 50 ]; then
      BAR="${BAR}▒"
    elif [ "$REMAINDER" -ge 25 ]; then
      BAR="${BAR}░"
    else
      BAR="${BAR}·"
    fi
  else
    BAR="${BAR}·"
  fi
done

# ─── Stats ───────────────────────────────────────────────────────────────────
CTX="${FG_GRAY}ctx ${BAR_COLOR}${BAR} ${NUM_COLOR}${PCT_FMT}%${R}"
ART_FMT="${FG_GRAY}artifacts ${NUM_COLOR}${ARTIFACTS}${R}"
SUB_FMT="${FG_GRAY}subagents ${NUM_COLOR}${SUBAGENTS}${R}"
BG_FMT="${FG_GRAY}tasks ${NUM_COLOR}${BG_TASKS}${R}"

# ─── Separators ──────────────────────────────────────────────────────────────
DOT="${FG_GRAY} · ${R}"

# ─── Alignment Helper Functions ──────────────────────────────────────────────
visible_length() {
  local stripped
  # Strip ANSI escape sequences to compute actual visible length
  stripped=$(echo -e "$1" | sed $'s/\e\\[[0-9;]*[a-zA-Z]//g')
  echo "${#stripped}"
}

align_line() {
  local left="$1"
  local right="$2"
  local width="$3"
  
  local len_left
  len_left=$(visible_length "$left")
  local len_right
  len_right=$(visible_length "$right")
  
  local pad_len=$((width - len_left - len_right))
  local padding=""
  if [ "$pad_len" -gt 0 ]; then
    padding=$(printf "%${pad_len}s" " ")
  fi
  
  echo -e "${left}${padding}${right}"
}

# ─── Output Layout Execution ─────────────────────────────────────────────────
if [ "$COLS" -ge 120 ]; then
  # Wide: single-line layout with right-alignment
  # Left: State, VCS branch, and then stats
  L_LEFT="${S}${V}${FG_GRAY}  │  ${R}${ART_FMT}${DOT}${SUB_FMT}${DOT}${BG_FMT}${DOT}${SB}"
  # Right: Model and Context bar
  if [ -n "$M" ]; then
    L_RIGHT="${M}${FG_GRAY}  │  ${R}${CTX}"
  else
    L_RIGHT="${CTX}"
  fi
  
  align_line "$L_LEFT" "$L_RIGHT" "$COLS"

elif [ "$COLS" -ge 80 ]; then
  # Medium: two-line layout with border and right-alignment
  # Line 1: Left has State + VCS branch, Right has Model name (border takes 3 spaces: "╭─ ")
  L1_LEFT="${S}${V}"
  L1_RIGHT="${M}"
  L1_CONTENT=$(align_line "$L1_LEFT" "$L1_RIGHT" $((COLS - 3)))
  echo -e "${FG_GRAY}╭─${R} ${L1_CONTENT}"
  
  # Line 2: Left has Stats + Sandbox, Right has Context bar (border takes 2 spaces: "╰─")
  # Note: Left has a leading space before the content to align with Line 1
  L2_LEFT=" ${ART_FMT}${DOT}${SUB_FMT}${DOT}${BG_FMT}${DOT}${SB}"
  L2_RIGHT="${CTX}"
  L2_CONTENT=$(align_line "$L2_LEFT" "$L2_RIGHT" $((COLS - 2)))
  echo -e "${FG_GRAY}╰─${R}${L2_CONTENT}"

else
  # Narrow: compact two-line, minimal chrome, no fancy right-alignment to avoid wrapping
  if [ -n "$M" ]; then
    echo -e "${S}${FG_GRAY} ╱ ${R}${M}"
  else
    echo -e "${S}"
  fi
  echo -e "${CTX}${DOT}${BG_FMT}"
fi
