#!/usr/bin/env bash
# DevKit status line component
# Outputs a compact DevKit status string for the Claude Code status bar.
# Designed to be called via $() in a statusLine template or composed
# into an existing status line script.
#
# Behavior:
#   - If .devkit/ does not exist in $PWD, outputs nothing (silent).
#   - Extracts version from CLAUDE.md ("DevKit v..." pattern).
#   - Counts tasks in .devkit/tasks/pending/ and .devkit/tasks/active/.
#   - Outputs a single-line string like: DevKit v2.2 | 3 pending, 1 active
#
# Exit: always 0 (status bar scripts must never fail).

set -euo pipefail

# Not a DevKit project -- stay silent
[[ -d ".devkit" ]] || exit 0

# --- Version ---
version=""
if [[ -f "CLAUDE.md" ]]; then
    version=$(grep -oE 'DevKit v[0-9]+\.[0-9]+' CLAUDE.md 2>/dev/null | head -1 || true)
fi
version="${version:-DevKit}"

# --- Task counts ---
pending=0
active=0

if [[ -d ".devkit/tasks/pending" ]]; then
    pending=$(find .devkit/tasks/pending -maxdepth 1 -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
fi

if [[ -d ".devkit/tasks/active" ]]; then
    active=$(find .devkit/tasks/active -maxdepth 1 -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
fi

# --- Build task summary ---
if (( pending == 0 && active == 0 )); then
    tasks="no tasks"
else
    parts=""
    if (( pending > 0 )); then
        parts="${pending} pending"
    fi
    if (( active > 0 )); then
        [[ -n "$parts" ]] && parts="${parts}, "
        parts="${parts}${active} active"
    fi
    tasks="$parts"
fi

echo "${version} | ${tasks}"
