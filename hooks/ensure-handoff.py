#!/usr/bin/env python3
"""ensure-handoff: prevents the agent from stopping without a proper handoff.

If the session touched an active task (.devkit/tasks/active/) but no
--handoff: block was written, the agent is blocked from stopping.
This ensures continuity — the next agent or human always has a handoff
note to pick up from.

Completed or archived tasks don't require a handoff; only active ones do.

Hook type: stop
"""
import json
import sys


def main():
    hook_data = json.loads(sys.stdin.read())

    has_work = False
    has_handoff = False

    for msg in hook_data.get("messages", []):
        content = str(msg.get("content", ""))

        # Check for evidence of active task work
        if ".devkit/tasks/active/" in content and ("Starting:" in content or "Session" in content):
            has_work = True
        if "in_progress" in content and ".devkit/tasks/active/" in content:
            has_work = True

        # Check for handoff
        if "--handoff:" in content:
            has_handoff = True

        # Task completion counts as a valid handoff
        if "in_review" in content and ".devkit/tasks/active/" in content:
            has_handoff = True
        if "status: done" in content and ".devkit/tasks/" in content:
            has_handoff = True

    # No active work done — agent can stop freely
    if not has_work:
        return

    if has_handoff:
        return

    print(json.dumps({
        "decision": "block",
        "reason": (
            "You have an active task. Write a --handoff: block in the task file "
            "(with done/remaining/uncertain) before stopping."
        ),
    }))


if __name__ == "__main__":
    main()
