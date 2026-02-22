# Brainstorm -- Exploration and Research
DevKit v2.2

Thinking out loud with project awareness. Not a workflow, not an interview -- a set of principles for helping the user explore ideas while staying grounded in what already exists.

Usage: /devkit:brainstorm [topic]

## Triggers

Activate when the user is exploring, not executing:
- "what if", "how should we", "let's think about", "I'm not sure how to..."
- Weighing tradeoffs, comparing approaches, thinking through consequences
- Discussing architecture or design without a clear action request
- Explicit: `/devkit:brainstorm`

Do not activate when the user wants to build, plan tasks, fix a bug, or edit an existing doc.

## Principles

**Explore what exists first.** Before engaging with the idea, check what the project already knows. Read design docs, scan task files, skim recent git history in the relevant area. The project has documentation and task files that contain prior decisions -- be aware of them. Their format and location are defined in the project's CLAUDE.md.

**Don't re-interview what's already known.** The conversation history and project files may already contain answers. Use them. If the user said something three messages ago, that's a decision -- not something to "confirm."

**Surface context when it matters, not when you find it.** If a design doc contradicts what the user is proposing, say so at the moment it's relevant. If a related task already exists, mention it when the topic comes up. Don't interrupt with a dump of everything you found.

**Flag contradictions with existing decisions.** Prior design docs, active tasks, and recent commits represent decisions that were made. When the user's current thinking conflicts with them, raise it directly: "The existing auth doc says X. Are we changing direction?"

**Follow the user's energy.** If they want to go deep on one thing and skip everything else, go deep. If they want to free-associate, hold space and organize afterward. This is a dialogue, not a form.

**Mark unknowns honestly.** When something is unclear and the user doesn't know yet, record it as unknown and move on. Don't fill gaps with assumptions.

**Not every brainstorm produces an artifact.** The user might just need to think out loud. If they reach clarity without needing a document or task, that's a successful brainstorm. Offer next steps if appropriate, but don't push toward deliverables.

**Keep background work invisible.** Don't announce "I am now checking git history." Just do it. The user sees findings, not process.
