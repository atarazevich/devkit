# Version Bump
DevKit v2.2

Bump the DevKit version string across all files that carry it.

Usage: /devkit:version-bump [new version]

## Triggers

"bump version", "release X.Y", "update devkit version", or any request to change the version number.

## Source of Truth

`install.sh` contains the canonical version: `DEVKIT_VERSION="X.Y"`. Read it first. If the user didn't specify a new version, ask.

## What Gets Updated

Every file that carries a version string. Currently:

- `install.sh` -- the `DEVKIT_VERSION` variable
- `README.md` -- the `# DevKit vX.Y` header
- `templates/CLAUDE.md.template` -- the `## DevKit vX.Y` header
- Every file in `commands/devkit/` and `skills/devkit/` -- the `DevKit vX.Y` line under the title

Search for the old version string project-wide before committing. If a file carries the version and isn't in this list, update it too.

## Commit

Single commit: `[TECH] Bump DevKit to vX.Y`. No branch, no task file -- this is a housekeeping operation.
