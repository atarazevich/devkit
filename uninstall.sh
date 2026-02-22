#!/usr/bin/env bash
set -euo pipefail

# --- Colors ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

# --- Paths ---
CLAUDE_DIR=".claude"

# --- Helpers ---
info()    { echo -e "${GREEN}${1}${NC}"; }
warn()    { echo -e "${YELLOW}${1}${NC}"; }
bold()    { echo -e "${BOLD}${1}${NC}"; }

if [ ! -d "${CLAUDE_DIR}" ]; then
    warn "No .claude/ directory found in $(pwd). Nothing to uninstall."
    exit 0
fi

removed=0

# --- Remove directories ---
for dir in \
    "${CLAUDE_DIR}/commands/devkit" \
    "${CLAUDE_DIR}/hooks/devkit" \
    "${CLAUDE_DIR}/scripts/devkit"; do

    if [ -d "$dir" ]; then
        rm -rf "$dir"
        info "Removed ${dir}/"
        removed=$((removed + 1))
    fi
done

# --- Remove agent files ---
for agent in developer.md code-reviewer.md design-doc-writer.md; do
    target="${CLAUDE_DIR}/agents/${agent}"
    if [ -f "$target" ]; then
        rm -f "$target"
        info "Removed ${target}"
        removed=$((removed + 1))
    fi
done

# --- Summary ---
echo ""
if [ "$removed" -gt 0 ]; then
    bold "DevKit uninstalled from $(pwd). Removed ${removed} items."
else
    warn "Nothing to remove — DevKit was not installed in this project."
fi
echo ""
echo "Note: .devkit/ directory and CLAUDE.md are not removed."
echo "Clean those up manually if needed."
