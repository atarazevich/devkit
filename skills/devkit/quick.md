# Quick
DevKit v2.2

Minimal-ceremony path for small, straightforward changes. If it's small, just do it.

Usage: /devkit:quick <description>

## Triggers

"Can you just...", "quickly add...", "small fix", config tweaks, doc updates, one-off changes — anything that doesn't need a plan.

## How It Works

Confirm a 1-line summary with the user. Create a task file directly in `.devkit/tasks/active/`, do the work, move it to `archive/`. That's the whole flow.

## Guard Rail

If the change touches 3+ files or requires design thinking, pause and suggest `/devkit:plan` instead. This applies both before starting and mid-flight — if it grows beyond simple, stop and escalate.

## What This Skill Does NOT Cover

No wave/plan computation. No code review cycle. Commits, trailers, and branch conventions are handled by CLAUDE.md — not repeated here.
