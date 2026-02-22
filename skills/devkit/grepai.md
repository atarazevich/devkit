# Semantic Search (grepai)
DevKit v2.2

Query your codebase by meaning using grepai semantic search.

Usage: /devkit:grepai <query>
       /devkit:grepai status
       /devkit:grepai stop

## Triggers

"semantic search", "search code by meaning", "natural language search", "grepai"

## Instructions

grepai is set up automatically during `/devkit:init` when the binary and Ollama are available. This skill is for running searches and managing the watcher.

### If `$ARGUMENTS` is "status"

Run `grepai watch --status`. Report watcher state.

### If `$ARGUMENTS` is "stop"

Run `grepai watch --stop`. Confirm the watcher has stopped.

### Otherwise (search query)

The entire `$ARGUMENTS` is the search query. Run:

```bash
grepai search "$ARGUMENTS" --toon -n 10
```

Present results to the user. If no results, suggest rephrasing — grepai works best with English descriptions of intent ("authentication middleware") rather than symbol names ("handleAuth").

### If `.grepai/` doesn't exist

Tell the user: "Semantic search is not set up in this project. Run `/devkit:init` with grepai and Ollama available, or install manually:
1. `brew install yoanbernabeu/tap/grepai` (or `curl -sSL https://raw.githubusercontent.com/yoanbernabeu/grepai/main/install.sh | sh`)
2. `ollama pull nomic-embed-text`
3. `grepai init --provider ollama --backend gob --yes && grepai watch --background`"

## Additional Commands

**Trace call graphs**:
```bash
grepai trace callers "FunctionName" --json
grepai trace callees "FunctionName" --json
grepai trace graph --json --depth 3
```
