# Bug Fix
DevKit v2.2

A bug is a source of information, not an obstacle. Exhaust what it reveals before writing a single line of fix.

## Triggers

- User reports something broken, wrong, or unexpected
- Failing test or error surfaces during another skill
- If ambiguous: "Is this something that used to work, or something never built?"

## Philosophy

The instinct is to fix fast. Resist it. A bug means your model of the system is wrong somewhere — the fix is a side effect of finding where. Prove you understand the bug completely before touching code. If you can't explain the root cause to someone with no context, you don't understand it yet.

## Approach

**Reproduce.** Pin down three things: expected behavior, actual behavior, conditions under which it fails. If you can't reproduce it, you can't prove you fixed it.

**Hypothesize with evidence.** Form 1-3 hypotheses about the root cause. Each must cite specific code, state, or data — never "maybe it's X." For each, state what you'll check and what result would confirm or reject it.

**Verify each hypothesis.** Trace execution, inspect state, read the code. Cross-reference with `git log` and `git blame` on affected files — recent changes are the most likely culprits. Log what you tried and what you found.

**Prove root cause.** You need a causal chain: this input, through this path, hits this flaw, produces this wrong output. If all hypotheses are rejected, form new ones. After 3 rounds without a proven root cause, stop and escalate to the user with what you tested and what remains unclear.

**Only then, fix.** The fix addresses the root cause, not the symptom. Delegate to the developer agent for implementation.

## The Pay Streak

After proving root cause, mine it. The bug you found is one instance; the pattern it belongs to may have siblings.

**Categorize the gap.** Was this a design flaw, an oversight, a regression, or a wrong assumption? What would have caught it earlier?

**Find siblings.** Grep for the same pattern, API misuse, or broken assumption in adjacent code. Check other callers of the same function, other consumers of the same data. Siblings become future work — surface them to the user so they can decide whether to act now or plan separately.

## Escalation

- Root cause unclear after 3 hypothesis rounds: stop, report what was tested and what would help, ask the user.
- Fix requires architectural change: stop, present the root cause and options with tradeoffs, ask the user.
