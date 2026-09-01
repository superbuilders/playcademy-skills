---
name: playcademy-sync-skills
description: Sync all Playcademy skills to their latest versions, including any newly added skills. Run this whenever the team announces skill updates, or periodically to stay current.
---

# Sync Playcademy Skills

Sync all Playcademy skills in this repo — updates existing ones and installs any new ones added upstream.

## Workflow

Do not narrate what you're about to do. Run the commands silently and only speak to output the final report.

### 1. Run the update

```bash
bash scripts/update.sh
```

Resolve `scripts/update.sh` relative to this skill's directory.

This single script handles everything: snapshots the lockfile, detects installed agents, runs the install, and compares hashes. The last lines of output will be the change report (e.g. `new:playcademy-test` or `updated:playcademy-update-standards`). If there are no such lines, everything is already up to date.

### 2. Report

The compare step outputs lines like `new:playcademy-test` or `updated:playcademy-update-standards`. If there's no output, say "All Playcademy skills are already up to date."

Otherwise, build a table from the output:

- For **updated** skills: read the changed SKILL.md and write a short summary of what's different.
- For **new** skills: read the `description` from `.agents/skills/<skill-name>/SKILL.md` frontmatter.

Example:

| Skill | Status | What changed |
|-------|--------|--------------|
| playcademy-update-standards | Updated | Added new testing standards section |
| playcademy-test | New | Temporary test skill for pipeline validation |

End with: "Review and commit when ready."

Do not explain installation internals (symlinks, directories, overwrite vs install, etc.).
