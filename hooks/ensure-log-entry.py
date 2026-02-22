#!/usr/bin/env python3
"""ensure-log-entry: blocks vague log entries appended to task files.

When an agent edits a task file in .devkit/tasks/{pending,active,archive}/
to append log entries, this hook checks that the new content is meaningful —
not bare verbs like "Started" or "Done" that carry no context for future
sessions.

Entries using structured prefixes (--hypothesis, --decision, --tried,
--blocker, --handoff) pass automatically because the prefix itself
provides context.

Hook type: pre_tool_use
Triggers on: Edit (when file_path contains .devkit/tasks/)
"""
import json
import sys


STRUCTURED_PREFIXES = ("--hypothesis:", "--decision:", "--tried:", "--blocker:", "--handoff:")

MIN_CONTENT_LENGTH = 20


def main():
    hook_data = json.loads(sys.stdin.read())
    tool_name = hook_data.get("tool_name", "")

    if tool_name != "Edit":
        return

    tool_input = hook_data.get("tool_input", {})
    file_path = tool_input.get("file_path", "")

    if ".devkit/tasks/" not in file_path:
        return

    new_string = tool_input.get("new_string", "")

    if not new_string.strip():
        return

    # Structured prefixes always pass
    for prefix in STRUCTURED_PREFIXES:
        if prefix in new_string:
            return

    # Session headers always pass
    if new_string.strip().startswith("### Session"):
        return

    # Check each non-empty line for quality
    lines = [line.strip() for line in new_string.strip().split("\n") if line.strip()]

    for line in lines:
        # Skip markdown headers and list markers
        clean = line.lstrip("#").lstrip("-").lstrip("*").strip()
        if not clean:
            continue

        # Allow if line is long enough OR contains a colon (structured)
        if len(clean) >= MIN_CONTENT_LENGTH or ":" in clean:
            continue

        # Found a vague line
        print(json.dumps({
            "decision": "block",
            "reason": (
                f'Log quality gate: "{clean}" is too vague. '
                f'Add context after a colon (e.g., "Starting: reading auth module to understand token flow") '
                f"or use a structured prefix (--hypothesis:, --decision:, --tried:, --blocker:)."
            ),
        }))
        return


if __name__ == "__main__":
    main()
