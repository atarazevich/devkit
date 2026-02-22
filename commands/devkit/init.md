# DevKit Init
DevKit v2.2

Verify and repair the DevKit setup in the current project. This is safe to run multiple times.

Usage: /devkit:init

## Instructions

Check the current project's DevKit installation and fix anything missing.

### Step 1: Check .claude/ Installation

Verify these directories exist:
- `.claude/commands/devkit/` — should contain skill files
- `.claude/agents/` — should contain developer.md, code-reviewer.md, design-doc-writer.md
- `.claude/hooks/devkit/` — should contain ensure-*.py hooks

If any are missing, tell the user: "DevKit is not fully installed. Run install.sh from the DevKit repo to set up this project."

### Step 2: Check .devkit/ Structure

Verify `.devkit/tasks/pending/`, `.devkit/tasks/active/`, `.devkit/tasks/archive/`, and `.devkit/knowledge/` exist. Create any missing directories:

```bash
mkdir -p .devkit/tasks/{pending,active,archive} .devkit/knowledge
```

### Step 3: Check CLAUDE.md

If `CLAUDE.md` does not exist, tell the user: "No CLAUDE.md found. Run install.sh to create one from the DevKit template, or create one manually."

If it exists, check for key DevKit sections:
- "Task Files" or "Task Management"
- "Git Commit Convention"
- "Orchestration"

If sections are missing, note which ones and offer to append them. Do NOT auto-modify.

### Step 4: Check docs/ Structure

```bash
mkdir -p docs/design
```

If `docs/index.md` doesn't exist, create it:

```markdown
# Documentation Index

| Document | Description |
|----------|-------------|
```

### Step 5: Check .gitignore

Verify `.gitignore` contains `.claude/`. Add if missing.

### Step 6: Semantic Search (grepai)

Silently check if grepai is available and set up. Do not ask the user or report failure.

```bash
which grepai 2>/dev/null
```

If available and `.grepai/` doesn't exist, try to initialize silently. If `.grepai/` exists, ensure the watcher is running.

### Step 7: Report

```
DEVKIT STATUS

Structure:  .devkit/tasks/ [ok / fixed]
CLAUDE.md:  [ok / missing]
Skills:     [count] installed
Agents:     [count] installed
Hooks:      [count] installed
Grepai:     [active / not available]

Everything looks good. Just talk — I'll figure out the right skill.
```

### Rules

- NEVER overwrite an existing CLAUDE.md
- NEVER delete existing .gitignore entries
- This command verifies and repairs — install.sh does the initial setup
- Keep it idempotent — running /devkit:init twice is always safe
