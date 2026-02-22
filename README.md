# DevKit v2.2

An opinionated development workflow for Claude Code. For the person who builds alone, ships often, and wants their AI to remember what happened yesterday.

DevKit is not a framework. It's a harness — a small set of skills, three agents, and a file convention that turns Claude Code into something that can pick up where it left off, explain why it made a choice, and stop when it doesn't know what to do.

## How It Works

DevKit uses **plain markdown files as task memory** and **git as the source of truth**.

```
.devkit/tasks/
  pending/    ← work that hasn't started
  active/     ← work in progress
  archive/    ← work that's done
```

Status is the directory. `ls pending/` tells you what's queued. No database. No CLI tool. No index file. Every task is a markdown file with a structured log that agents read and write to — decisions, hypotheses, failed approaches, handoff notes. When a session ends, the next session reads the log and picks up exactly where the last one stopped.

Git commit trailers (`Task:`, `Decision:`, `Tried:`, `Discovered:`) make every commit traceable back to a task and the reasoning behind it.

## What DevKit Is (And What It's Not)

**DevKit is for one person.** If you're a solo developer or a small-team lead who does most of the building, and you want an AI that works the way you'd train a junior engineer — explore first, explain your reasoning, stop when confused — this is for you.

**DevKit is opinionated.** It has a specific philosophy about how AI agents should behave: logging is memory, errors are diagnostic signals (not obstacles), and escalation is always better than guessing. You don't have to agree with all of it, but it works as a coherent system because the opinions are consistent.

**DevKit is not an IDE plugin, a SaaS product, or a framework that supports eight different AI tools.** It's for Claude Code. It uses Claude Code's native primitives — skills, agents, commands — and doesn't try to abstract over them.

## Skills

You don't need to memorize commands. Just talk. DevKit identifies the right skill from context.

| Skill | What It Does |
|-------|-------------|
| `brainstorm` | Think out loud with project awareness. Surfaces related decisions and existing docs without you asking. |
| `plan` | Break a feature into 3-8 executable tasks with dependency ordering. |
| `execute` | Pick up a task. Spawn a developer agent, run code review, commit, archive. |
| `bug-fix` | Prove the root cause before writing a fix. Hypothesis-driven, not symptom-driven. |
| `quick` | Small change? Skip the ceremony. One task file, do the work, done. |
| `design` | Gather requirements through a structured Socratic interview, then hand off to the design-doc-writer. |
| `wrap-up` | End-of-session hygiene. Uncommitted changes, dangling tasks, knowledge capture. |
| `grepai` | Semantic code search by meaning, not just text. |
| `version-bump` | Bump the version number across README, install script, and CLAUDE.md. |

## Agents

Three agents, each with a clear boundary:

- **developer** — Implements and tests. Follows a verify-or-retry loop. Won't claim success without proof.
- **code-reviewer** — Reviews diffs against the task spec. No style nits, no praise — just substance.
- **design-doc-writer** — Produces design documents from structured input. Doesn't gather requirements (that's the design skill's job).

Skills orchestrate agents. You talk to skills, skills delegate to agents. The orchestrator passes file paths, not content — each agent opens what it needs in a fresh 200k context window.

## How DevKit Compares

The Claude Code ecosystem has grown fast. Here's how DevKit sits relative to the most prominent alternatives:

### vs. GSD (Get Shit Done)

GSD and DevKit share a core insight: spawn fresh sub-agents per task so context rot doesn't compound. GSD does this through a meta-prompting layer with PLAN.md as the executable instruction. DevKit does it with task files that carry the full work history — not just the spec, but every decision, failed approach, and handoff note from previous sessions.

**Where they diverge:** GSD optimizes for speed within a single plan execution (max 3 tasks, fire-and-forget). DevKit optimizes for continuity across sessions — the assumption is that real work spans days, not minutes, and the hard part isn't starting a task but resuming one after context is lost.

### vs. BMAD Method

BMAD is a full lifecycle framework with 21+ specialized agents (Analyst, PM, Architect, Scrum Master, Developer, QA, UX Designer...) and 50+ workflows. It models an entire software organization.

**Where they diverge:** DevKit models one person with good habits. BMAD's document sharding and step-file architecture solve the same context problem DevKit solves with task file logs, but with significantly more moving parts. If you need enterprise governance and role-based agent boundaries, BMAD is built for that. If you need to go from idea to shipped code without configuring a simulated org chart, DevKit is simpler.

### vs. Superpowers

Superpowers is a popular skills framework that enforces TDD discipline — it will delete code written before tests and force the RED-GREEN-REFACTOR cycle. It's opinionated about development methodology.

**Where they diverge:** DevKit is opinionated about agent behavior (logging, escalation, memory), not about your coding methodology. It won't force TDD. The developer agent verifies its work, but how you structure your tests is your call.

### vs. Spec Kit

Spec Kit is GitHub's spec-driven development toolkit. Five sequential phases from constitution to implementation, supporting 8 different AI coding environments.

**Where they diverge:** Spec Kit is IDE-agnostic and spec-first. DevKit is Claude Code-native and conversation-first — you can start from a brainstorm and let the system figure out when planning is needed. Spec Kit is a better choice if you need cross-tool compatibility. DevKit is a better choice if you want depth in one tool.

## Install

```bash
git clone https://github.com/atarazevich/devkit.git ~/devkit
cd your-project
~/devkit/install.sh
```

That's it. The script copies skills, agents, and hooks into your project's `.claude/` directory, creates `.devkit/tasks/`, and writes a `CLAUDE.md` protocol file. Everything stays local to the project — nothing is installed globally.

Only dependency: [Claude Code](https://claude.ai/code).

To verify or repair an existing setup, run `/devkit:init` inside Claude Code.

## Philosophy

**Logging is memory.** Task files bridge agent sessions across context windows. When an agent picks up a task, it reads what previous agents discovered — not just the original spec, but every decision, hypothesis, failed approach, and handoff note.

**Errors are pay streaks.** A bug isn't an obstacle; it's a trail leading to a deeper misunderstanding in the design, the requirements, or the codebase's assumptions. Agents follow the trail before routing around it.

**Escalation is explicit.** Agents stop and ask instead of guessing. A wrong guess costs more than a pause.

## Uninstall

From your project directory:

```bash
~/devkit/uninstall.sh
```

Removes DevKit from `.claude/` but leaves `.devkit/` and `CLAUDE.md` intact.
