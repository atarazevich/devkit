# Execute Task
DevKit v2.2

Pick up a task and run it through development and code review.

## System Identification

Activate when:
- "execute task X", "let's build", "start working on", "implement this"
- User references a specific task file or task ID
- After `/devkit:plan` completes and user wants to start

If unclear whether user wants execution or exploration, ask.

## Instructions

You are in AUTOMATED EXECUTION MODE for task $ARGUMENTS.

### Flow

Locate the task file. $ARGUMENTS can be a task ID, filename, or slug. If the task is in `pending/`, move it to `active/`. If already in `active/`, proceed. If in `archive/`, tell the user and ask if they want to reopen it.

Spawn a **developer** agent. Pass the task file path and let it read its own context. The developer reads the task, reads CLAUDE.md, implements, and commits. Do not paste task content into the prompt -- pass paths.

When the developer finishes, spawn a **code-reviewer** agent. Pass the task file path and point it at the diff. The reviewer reads its own context and evaluates the work against the task's outcome criteria.

If review passes, move the task file from `active/` to `archive/` and you are done.

If review fails, send findings back to the developer for another round. Max 3 review cycles total.

### Path-Based Spawning

Agents receive file paths, not content. Each agent opens what it needs in a fresh context window. This keeps prompts small and lets agents form their own understanding of the codebase. Your job as orchestrator is to pass the right paths and relay review outcomes between agents.

### Escalation Protocol

Repeated review failures are diagnostic signals, not just obstacles.

**After the 2nd review failure**, pause implementation and investigate the pattern. Look at what the reviewer keeps rejecting. Ask yourself: is this an implementation problem (developer keeps missing something) or a specification problem (what the task asks for is unclear, contradictory, or wrong)?

If the problem is in implementation, attempt round 3 with an explicit note to the developer about the recurring pattern. If the problem is in the task definition itself, escalate to the user with the pattern you identified and options for how to proceed.

**After the 3rd failure**, stop. Surface everything to the user: what was tried, what keeps failing, and your hypothesis about why. Do not continue without user input.

### Post-Commit Reconciliation

When work happens without a pre-existing task (ad-hoc commits, quick fixes), create a retroactive task file directly in `archive/` so the work is traceable. Derive the content from the commit. Next available task ID, type `chore`, priority `P2`. Confirm with the user that it looks right.
