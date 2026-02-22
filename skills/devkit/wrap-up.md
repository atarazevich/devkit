# Wrap Up
DevKit v2.2

Close out a work session cleanly. Capture what matters, leave nothing dangling.

Usage: /devkit:wrap-up

## Triggers

"wrap up", "we're done", "let's close out", "end of session", "that's it for today"

## Instructions

Run through these checks quickly. No fanfare, no ceremony.

### 1. What Changed

```bash
git status
git diff --stat
```

If there are uncommitted changes, summarize what they are and ask the user: "Commit these before wrapping up?"

### 2. Task Hygiene

Check `.devkit/tasks/active/` — are there tasks still marked active?

For each active task:
- If the work is done, write a `--handoff:` block and move to `archive/`
- If the work is NOT done, write a `--handoff:` with what's done, what remains, and what's uncertain. Leave in `active/`

Never leave an active task without a handoff.

### 3. Session Knowledge

This is the important part. Review the conversation and ask yourself:

**What was decided that isn't written down anywhere?**
- Architectural choices, tradeoff resolutions, "let's go with X" moments
- If any exist, append them to the relevant task log or CLAUDE.md

**What broke and how was it fixed?**
- Gotchas, workarounds, non-obvious solutions
- Worth saving only if someone would hit the same wall again

**What does the next session need to know?**
- Context that would take 5+ minutes to reconstruct
- State of partially-done work, open questions, blocked items

Write anything worth preserving to ONE of these places (pick the most natural fit):
- **Task log** (`--handoff:` block) — if it's about a specific task
- **CLAUDE.md** — if it's a project-wide convention that should be ambient
- **`.devkit/knowledge/`** — if it's a decision, pattern, or solved problem that future sessions should be able to find

Knowledge files are topical markdown, named by subject: `grepai-setup.md`, `auth-architecture.md`, `portkey-gotchas.md`. Keep them short and greppable. Agents discover them when exploring — they're not auto-injected into context.

If nothing is worth saving, say so. Not every session produces lasting knowledge.

### 4. Summary

Print a brief summary:

```
SESSION WRAP-UP

Changes: [X files modified, Y uncommitted / all committed]
Tasks: [N active → archived, M still in progress]
Captured: [what was saved and where, or "nothing new to capture"]
```

Done. Keep it under 10 lines.

## Rules

- Don't over-document. If it's obvious from the code or commit history, skip it.
- Don't update CLAUDE.md unless something genuinely project-wide was established.
- Don't create task files retroactively unless the user asks.
- Ask before committing — never auto-commit.
- The whole wrap-up should take under a minute. If it's getting long, you're overthinking it.
