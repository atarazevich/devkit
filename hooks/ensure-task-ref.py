#!/usr/bin/env python3
"""ensure-task-ref: blocks git commits that lack a Task trailer.

Every commit must be traceable to a task. The commit message must contain
a "Task:" trailer (e.g., Task: add-auth-middleware) or an explicit
opt-out (Task: none / Task: ad-hoc). This keeps the git history connected
to the task files (.devkit/tasks/{pending,active,archive}/) for traceability.

Hook type: pre_tool_use
Triggers on: Bash (when command contains git commit)
"""
import json
import re
import sys


def extract_commit_message(command: str) -> str | None:
    """Extract the commit message from a git commit command."""
    # Match -m "message", -m 'message'
    match = re.search(r'git\s+commit\s+.*?-m\s+["\'](.+?)["\']', command, re.DOTALL)
    if match:
        return match.group(1)

    # Heredoc pattern: -m "$(cat <<'EOF' ... EOF )"
    match = re.search(r"git\s+commit\s+.*?-m\s+\"\$\(cat\s+<<'?EOF'?(.+?)EOF", command, re.DOTALL)
    if match:
        return match.group(1)

    return None


def main():
    hook_data = json.loads(sys.stdin.read())
    tool_name = hook_data.get("tool_name", "")

    if tool_name != "Bash":
        return

    command = hook_data.get("tool_input", {}).get("command", "")

    if "git commit" not in command:
        return

    # Allow --amend without message (keeps existing message)
    if "--amend" in command and "-m" not in command:
        return

    message = extract_commit_message(command)

    if message is None:
        return

    # Check for Task: trailer (case-insensitive)
    if re.search(r"Task:", message, re.IGNORECASE):
        return

    print(json.dumps({
        "decision": "block",
        "reason": (
            "Include a Task: trailer in the commit message "
            "(e.g., Task: add-auth-middleware) or Task: ad-hoc for untracked work."
        ),
    }))


if __name__ == "__main__":
    main()
