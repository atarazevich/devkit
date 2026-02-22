#!/usr/bin/env bash
set -euo pipefail

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BOLD='\033[1m'
NC='\033[0m'

# --- Version ---
DEVKIT_VERSION="2.2"

# --- Paths ---
DEVKIT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(pwd)"
CLAUDE_DIR="${PROJECT_DIR}/.claude"

# --- Helpers ---
info()    { echo -e "${GREEN}${1}${NC}"; }
warn()    { echo -e "${YELLOW}${1}${NC}"; }
err()     { echo -e "${RED}${1}${NC}" >&2; }
bold()    { echo -e "${BOLD}${1}${NC}"; }

# --- Sanity checks ---
if [ "${PROJECT_DIR}" = "${DEVKIT_DIR}" ]; then
    err "Error: Run this from your project directory, not from the DevKit repo."
    err "  cd your-project && ${DEVKIT_DIR}/install.sh"
    exit 1
fi

if ! command -v claude &>/dev/null; then
    err "Error: 'claude' CLI not found."
    err "  See: https://docs.anthropic.com/en/docs/claude-code"
    exit 1
fi

if ! command -v git &>/dev/null; then
    err "Error: 'git' not found."
    exit 1
fi

bold "Installing DevKit v${DEVKIT_VERSION} in ${PROJECT_DIR}"
echo ""

# --- Install skills (deployed as commands — Claude Code discovers them there) ---
bold "Skills..."
mkdir -p "${CLAUDE_DIR}/commands/devkit"
if [ -d "${DEVKIT_DIR}/skills/devkit" ]; then
    cp -f "${DEVKIT_DIR}/skills/devkit/"* "${CLAUDE_DIR}/commands/devkit/"
    skill_count=$(ls -1 "${DEVKIT_DIR}/skills/devkit/" | wc -l | tr -d ' ')
    info "  ${skill_count} skills"
else
    skill_count=0
fi

# --- Install commands ---
cp -f "${DEVKIT_DIR}/commands/devkit/init.md" "${CLAUDE_DIR}/commands/devkit/"
info "  1 command (init)"

# --- Install agents ---
bold "Agents..."
mkdir -p "${CLAUDE_DIR}/agents"
agent_count=0
for agent_file in "${DEVKIT_DIR}/agents/"*.md; do
    cp -f "$agent_file" "${CLAUDE_DIR}/agents/"
    agent_count=$((agent_count + 1))
done
info "  ${agent_count} agents"

# --- Install hooks ---
bold "Hooks..."
mkdir -p "${CLAUDE_DIR}/hooks/devkit"
hook_count=0
for f in "${DEVKIT_DIR}/hooks/"*.py; do
    [ -f "$f" ] && cp -f "$f" "${CLAUDE_DIR}/hooks/devkit/" && hook_count=$((hook_count + 1))
done
info "  ${hook_count} hooks"

# --- Install scripts ---
mkdir -p "${CLAUDE_DIR}/scripts/devkit"
for f in "${DEVKIT_DIR}/scripts/"*; do
    [ -f "$f" ] && cp -f "$f" "${CLAUDE_DIR}/scripts/devkit/"
done
chmod +x "${CLAUDE_DIR}/scripts/devkit/"*.sh 2>/dev/null || true

# --- Create .devkit/ structure ---
bold "Project structure..."
mkdir -p .devkit/tasks/{pending,active,archive} .devkit/knowledge
info "  .devkit/tasks/{pending,active,archive}"

# --- Set up CLAUDE.md ---
if [ ! -f "CLAUDE.md" ]; then
    cp -f "${DEVKIT_DIR}/templates/CLAUDE.md.template" ./CLAUDE.md
    info "  CLAUDE.md created from template"
else
    warn "  CLAUDE.md already exists (not overwritten)"
fi

# --- Create docs structure ---
mkdir -p docs/design
if [ ! -f "docs/index.md" ]; then
    cat > docs/index.md << 'DOCSEOF'
# Documentation Index

| Document | Description |
|----------|-------------|
DOCSEOF
    info "  docs/index.md created"
fi

# --- Update .gitignore ---
if [ -f ".gitignore" ]; then
    if ! grep -q "^\.claude/" .gitignore 2>/dev/null; then
        echo ".claude/" >> .gitignore
        info "  Added .claude/ to .gitignore"
    fi
else
    echo ".claude/" > .gitignore
    info "  Created .gitignore with .claude/"
fi

# --- Silent grepai setup ---
if command -v grepai &>/dev/null && [ ! -d ".grepai" ]; then
    if curl -s --max-time 2 http://localhost:11434/api/tags &>/dev/null; then
        grepai init --provider ollama --backend gob --yes &>/dev/null && \
        grepai watch --background &>/dev/null && \
        info "  Semantic search (grepai) activated" || true
    fi
elif command -v grepai &>/dev/null && [ -d ".grepai" ]; then
    grepai watch --status &>/dev/null || grepai watch --background &>/dev/null || true
fi

# --- Summary ---
echo ""
echo "---------------------------------------------"
info "DevKit v${DEVKIT_VERSION} ready."
echo ""
echo "  Skills:  ${skill_count}"
echo "  Agents:  ${agent_count}"
echo "  Hooks:   ${hook_count}"
echo ""
echo "  Open Claude Code in this directory and start talking."
echo "  Use /devkit:plan, /devkit:execute, /devkit:brainstorm"
echo "---------------------------------------------"
