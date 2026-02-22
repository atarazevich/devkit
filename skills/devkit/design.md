# Design -- Requirements Gathering Interview
DevKit v2.2

Interactive Socratic requirements-gathering interview that walks through software design sections, surfaces unknowns, forces decisions, and collects aligned answers before handing off to a design-doc-writer sub-agent.

Usage: /devkit:design [scope description]

## When to Use

Activates when user says:
- "design", "/devkit:design"
- "design doc", "write a design doc"
- "requirements", "gather requirements"
- "what are we building"
- "let's design"
- "let's think through [X] before building"

**With scope argument:** `/devkit:design auth system` uses "auth system" as the starting scope.

**Do NOT use this command when:**
- User wants to execute or implement something (use developer agent)
- User wants a quick architectural opinion without structured interview
- User says "just build it" or "skip the design"
- User wants to edit an existing design doc (hand to developer or writer directly)

## Workflow

### Phase 1: Scope Detection

**Goal:** Determine the boundary of what we are designing.

1. **Parse the invocation.** If the user provided context (e.g., `/devkit:design auth system`), treat that string as the initial scope.
2. If no context was provided, ask: "What are we designing? A whole project, a component, a feature?"
3. Determine **scope level**:
   - **Project** -- full system with multiple components
   - **Component** -- a bounded subsystem within an existing project
   - **Feature** -- a single capability or user-facing change
4. **Check for existing design docs.** Run:
   ```
   Glob: docs/design/*.md
   Glob: docs/design/**/*.md
   ```
   If any exist, read them to understand prior decisions and avoid contradictions. Mention to the user: "I found existing design docs: [list]. I will reference them to stay consistent."
5. **Announce the scope** to the user before proceeding: "We are designing: **[scope]** at the **[level]** level. I will walk you through a structured interview. You can say 'good enough' or 'skip' at any section."

### Phase 1.5: Context Harvesting

**Goal:** Extract everything already known BEFORE asking a single question.

The user may invoke `/devkit:design` after an extensive conversation where many decisions have already been made. Do not ignore this context. Do not re-ask questions the user already answered.

1. **Scan the conversation history.** Review all prior messages in the current session. For each of the 9 sections, extract any decisions, constraints, preferences, or technical details the user has already stated.

2. **Check project files for prior context.** Run:
   ```
   Glob: docs/**/*.md
   Glob: README.md
   Glob: CLAUDE.md
   ```
   Read any relevant files that might contain architectural decisions, tech stack info, or project descriptions.

3. **Pre-fill sections.** For each of the 9 interview sections, classify it as:
   - **DEFINED** -- enough information exists to write this section without asking anything
   - **PARTIAL** -- some information exists but key details are missing
   - **DEFERRED** -- discussed and intentionally left open (with reason)
   - **NOT DISCUSSED** -- no information available, needs full interview

4. **Present the harvest to the user.** Before interviewing, show what you already know:
   ```
   Based on our conversation and existing docs, here's what I already have:

   [x] Overview: [1-sentence summary of what you extracted]
   [~] Constraints: [what you know + what's missing]
   [ ] Interfaces: No information yet
   [x] Architecture: [1-sentence summary]
   ...
   ```
   Then say: "I'll only ask about the gaps. Correct me if I got anything wrong."

5. **Skip COVERED sections entirely.** Do not re-ask. Do not "confirm" covered sections one by one -- that is just re-interviewing with extra steps. If the user wants to correct something, they will.

### Phase 2: Structured Interview

Walk through **only PARTIAL and EMPTY sections** in order. For each section:
- State the section name and its purpose in one sentence
- For PARTIAL sections: state what you already know, then ask only about the gaps
- For EMPTY sections: ask 2-4 targeted questions
- Listen to the answer, then ask follow-up questions to go deeper
- If the user does not know, record the item as **UNKNOWN** and move on
- If the user says "skip", ask briefly: "Not relevant, or revisit later?" Mark as **DEFERRED** with the reason and move on
- If the user says "good enough", "that's enough", or "let's document this" -- immediately jump to Phase 3

**Track coverage internally:**
```
[x] Overview
[x] Constraints & Boundaries
[ ] Interfaces          <-- current
[ ] Architecture
[ ] Systems
[ ] Business Logic
[ ] Configuration
[ ] Progression / Phases
[ ] UI/UX
```

---

#### Section 1: Overview

**Purpose:** Establish what this thing IS in plain language.

Questions:
- "What is this? Describe it in one paragraph as if explaining to a new team member."
- "What problem does it solve? What is painful or missing today?"
- "Who is it for? Who are the primary users or consumers?"
- (If project-level) "Does this have a name? A working title is fine."

**Go deeper if vague:** "You said it's for 'users' -- can you be more specific? Internal team? End customers? API consumers?"

---

#### Section 2: Constraints & Boundaries

**Purpose:** Define the box we are working inside before designing what goes in it.

Questions:
- "What tech stack are we working with? Languages, frameworks, infra."
- "What platforms does this need to support? Web, mobile, CLI, API-only?"
- "Are there hard limits? Budget, timeline, team size, regulatory."
- "Non-functional requirements? Performance targets, uptime SLA, data residency, security requirements."
- "What is explicitly OUT of scope?"

**Go deeper:** "You mentioned [X framework]. Is that a hard constraint or a preference?"

---

#### Section 3: Interfaces

**Purpose:** Define the surface area -- inputs, outputs, integration points -- before going deep on internals. This is the equivalent of writing controls early.

Questions:
- "What are the inputs to this system? User actions, API calls, events, data feeds?"
- "What are the outputs? What does it produce or respond with?"
- "What external systems does it integrate with? Third-party APIs, databases, other internal services?"
- "Are there existing API contracts or data models we need to conform to?"
- "What does the data look like? Key entities and their relationships."

**Go deeper:** "You mentioned integration with [X]. Is that a REST API, SDK, webhook, database view?"

---

#### Section 4: Architecture

**Purpose:** Understand the structural decomposition -- how major pieces relate.

Questions:
- "How is the system structured at a high level? Monolith, microservices, serverless, hybrid?"
- "What are the major components or modules?"
- "How do they communicate? Sync (HTTP/RPC) vs async (queues/events)?"
- "Where does state live? Database, cache, session, file system?"

**Go deeper:** "You described [N] components. Which one is the most complex or risky? Let's dig into that one."

---

#### Section 5: Systems (Always-On Infrastructure)

**Purpose:** Identify the background machinery that is always running regardless of features.

Questions:
- "Authentication and authorization -- how do users prove who they are and what they can do?"
- "Logging and observability -- what gets logged, where does it go, how do you debug?"
- "Data layer -- primary database, caching strategy, data migrations?"
- "Background processing -- queues, cron jobs, workers?"
- "Any other infrastructure that is always present? CDN, email, notifications?"

**Go deeper:** "For auth, are you building it or using a provider? What are the roles/permissions?"

---

#### Section 6: Business Logic

**Purpose:** Capture the conditional, feature-specific rules that make this system unique.

Questions:
- "What are the core business rules? The 'if this then that' logic."
- "What triggers what? User actions, time-based events, data thresholds?"
- "Are there states or workflows? (e.g., draft -> review -> published)"
- "What are the edge cases you already know about?"
- "What happens when things go wrong? Error handling, rollback, retry?"

**Go deeper:** "You described a workflow with [N] states. What happens if someone tries to skip a state? What about concurrent edits?"

---

#### Section 7: Configuration

**Purpose:** Identify values that should be tunable without code changes.

Questions:
- "What values need to be configurable? Rate limits, feature flags, thresholds?"
- "What should be externalized vs hardcoded?"
- "Environment-specific settings? Dev vs staging vs production differences."
- "Who changes these values? Developers only, or also ops/product people?"

---

#### Section 8: Progression / Phases

**Purpose:** Define what ships first and what comes later.

Questions:
- "What is the MVP -- the smallest thing that delivers value?"
- "What comes in phase 2? Phase 3?"
- "What can we cut entirely if we run out of time?"
- "Are there dependencies between phases? Does phase 2 require rearchitecting phase 1?"

**Go deeper:** "You listed [X] in MVP. Is that truly essential for first value, or is it 'nice to have' masquerading as must-have?"

---

#### Section 9: UI/UX

**Purpose:** Understand what users see and interact with. Skip if this is a backend-only / API-only system.

Questions:
- "What does the user see? Key screens, pages, or views."
- "What are the primary user flows? Happy path from start to goal."
- "Any specific UX requirements? Accessibility, mobile-first, real-time updates?"
- "Do you have wireframes, mockups, or reference designs?"

**Go deeper:** "Walk me through the flow from the user's perspective. They open the app and then what?"

**Skip condition:** If the scope is purely backend/API with no user-facing surface, say: "This looks like a backend/API system with no direct UI. Skipping UI/UX section. Correct?" and move on.

---

### Phase 3: Handoff

**Goal:** Package everything collected and hand off to the `design-doc-writer` sub-agent.

1. **Summarize what was collected.** Present a brief summary organized by section:
   ```
   DESIGN INTERVIEW SUMMARY: [scope name]

   OVERVIEW [DEFINED]: [1-2 sentences]
   CONSTRAINTS [PARTIAL]: [what's known + what's missing]
   INTERFACES [NOT DISCUSSED]: --
   ARCHITECTURE [DEFINED]: [high-level structure]
   SYSTEMS [DEFERRED: revisit after MVP]: --
   BUSINESS LOGIC [PARTIAL]: [core rules + gaps]
   CONFIGURATION [NOT DISCUSSED]: --
   PHASES [DEFINED]: [MVP vs later]
   UI/UX [DEFERRED: backend-only for now]: --

   Statuses: DEFINED | PARTIAL | DEFERRED (with reason) | NOT DISCUSSED
   ```

2. **Confirm with user:** "Here is what we collected. Should I generate the design doc now?"

3. **On confirmation**, spawn the `design-doc-writer` sub-agent via the **Task** tool:
   - Use `subagent_type: "design-doc-writer"`
   - In the prompt, include: the scope name, the target file path (`docs/design/{scope-name}.md`), and the full interview summary with all raw answers
   - The agent file at `.claude/agents/design-doc-writer.md` contains all writing rules, document structure, and behavioral constraints -- do not duplicate them in the prompt

4. **After the sub-agent finishes**, report back to the user: "Design doc written to `docs/design/{scope-name}.md`. Review it and let me know if anything needs revision."

## Key Behavioral Rules

1. **This skill does NOT write files.** Only the sub-agent writes the design doc.
2. **This skill does NOT use Claude Code's built-in plan mode.** This is requirements gathering, not execution planning.
3. **Respect "good enough" immediately.** When the user signals they are done, stop interviewing and move to Phase 3. Do not ask "are you sure?" or push for more sections.
4. **Do not assume from thin air.** If the user gives a vague answer and does not clarify after one follow-up, mark it as UNKNOWN and move on. However: if the conversation history or project files contain clear decisions, USE THEM. There is a difference between assuming and reading what was already said.
5. **Reference existing docs.** If `docs/design/` contains prior design docs, read them and flag any contradictions during the interview: "In the existing [X] doc, it says [Y]. Does that still hold?"
6. **Keep it conversational.** This is a dialogue, not a form. Ask questions naturally, react to answers, and probe where it matters.
7. **One section at a time.** Do not dump all questions at once. Present a section, ask its questions, go deeper where needed, then announce the next section.
8. **Track progress visibly.** After completing each section, briefly note the coverage tracker so the user knows where they are.
9. **Never re-interview what is already known.** If context harvesting (Phase 1.5) marked a section as COVERED, skip it entirely. Do not ask "just to confirm" -- that is re-interviewing with extra politeness. The user will correct you if you got something wrong.

## Error Handling

- **No `docs/design/` directory:** The sub-agent should create it. Mention to user: "The `docs/design/` directory does not exist yet -- it will be created."
- **User wants to resume a previous interview:** Check if a partial design doc exists in `docs/design/`. If so, read it and identify which sections are incomplete, then resume from there.
- **User provides conflicting answers:** Flag the contradiction immediately: "Earlier you said [X], but now you are saying [Y]. Which one is correct?"
- **Scope is too large:** If the user describes something that clearly needs multiple design docs, suggest splitting: "This sounds like it could be 2-3 separate design docs: [A], [B], [C]. Want to tackle them one at a time?"

## Quality Checks

Before moving to Phase 3:
- [ ] Scope level is clearly established (project / component / feature)
- [ ] At least Overview and one other section have been covered
- [ ] All unanswered items are marked as UNKNOWN, not silently skipped
- [ ] No assumptions were made on behalf of the user
- [ ] Existing design docs were checked for contradictions
- [ ] User explicitly confirmed readiness for handoff
