#!/usr/bin/env bash
set -euo pipefail

# Detect which agents have Playcademy skills installed in the current project.
# Outputs ready-to-use -a flags for the skills CLI.
#
# Usage: bash detect-agents.sh
# Output: e.g. "-a claude-code -a cursor"

# Map of project skill directories to --agent CLI values.
# .agents/skills/ is the universal/shared dir used by Cursor, Codex, Gemini CLI,
# etc. We map it to "universal" so those get updated too.
declare -A AGENT_MAP=(
    [.agents/skills]="universal"
    [.claude/skills]="claude-code"
    [.cursor/skills]="cursor"
    [.codex/skills]="codex"
    [.windsurf/skills]="windsurf"
    [.roo/skills]="roo"
    [.kiro/skills]="kiro-cli"
    [.goose/skills]="goose"
    [.trae/skills]="trae"
)

agents=()

for dir in "${!AGENT_MAP[@]}"; do
    # Check if this agent's skill directory contains any playcademy-* skills
    if compgen -G "$dir/playcademy-*" > /dev/null 2>&1; then
        agents+=("${AGENT_MAP[$dir]}")
    fi
done

# If no agent-specific dirs found, fall back to claude-code
# (the skill is being run by an agent, so at least one must exist)
if [ ${#agents[@]} -eq 0 ]; then
    agents=("claude-code")
fi

# Output as -a flags ready to append to the command
printf -- '-a %s ' "${agents[@]}"
