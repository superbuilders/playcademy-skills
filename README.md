# Playcademy Skills

Shared [agent skills](https://agentskills.io) and coding standards for Playcademy game repos.

## Setup

```bash
npx skills add superbuilders/playcademy-skills --skill '*'
```

Then run `/playcademy-sync-standards` in your agent to set up `AGENTS.md`.

## Keeping in Sync

Run `/playcademy-sync-skills` to pull the latest.

<!-- Keep table descriptions under 60 characters to avoid wrapping -->

## Skills

| Command | Description |
|---------|-------------|
| `/playcademy-sync-standards` | Fetch team standards and apply them to `AGENTS.md` |
| `/playcademy-sync-skills` | Pull latest skills from this repo, including new ones |

## Standards

Applied to `AGENTS.md` via `/playcademy-sync-standards`:

| Standard | Description |
|----------|-------------|
| [Conventional Commits](standards/commits.md) | Commit message format, types, and scoping rules |
