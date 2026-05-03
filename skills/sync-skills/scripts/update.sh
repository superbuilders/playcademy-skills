#!/usr/bin/env bash
set -euo pipefail

# Full update pipeline: snapshot lockfile, detect agents, install, compare.
#
# Usage: bash update.sh
# Output: one line per changed skill (new:<name> or updated:<name>)
#         If no output, everything is already up to date.

LOCKFILE="skills-lock.json"
SNAPSHOT="/tmp/playcademy-skills-snapshot.json"
SKILLS_DIR=".agents/skills"
REPO="superbuilders/playcademy-skills"

# --- Snapshot ---

if [ -f "$LOCKFILE" ]; then
    cp "$LOCKFILE" "$SNAPSHOT"
else
    echo '{}' > "$SNAPSHOT"
fi

# --- Detect agents ---

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

agent_flags=()
for dir in "${!AGENT_MAP[@]}"; do
    if compgen -G "$dir/playcademy-*" > /dev/null 2>&1; then
        agent_flags+=("-a" "${AGENT_MAP[$dir]}")
    fi
done

if [ ${#agent_flags[@]} -eq 0 ]; then
    agent_flags=("-a" "claude-code")
fi

# --- Install ---

npx skills add "$REPO" --skill '*' -y "${agent_flags[@]}" 2>&1

# --- Compare ---

extract_hashes() {
    local file="$1"
    if [ ! -f "$file" ]; then
        return
    fi
    python3 -c "
import json
with open('$file') as f:
    data = json.load(f)
for name, info in sorted(data.get('skills', {}).items()):
    if name.startswith('playcademy-'):
        print(f\"{name}={info.get('computedHash', '')}\")
" 2>/dev/null || true
}

declare -A old_map
while IFS='=' read -r name hash; do
    [ -n "$name" ] && old_map["$name"]="$hash"
done <<< "$(extract_hashes "$SNAPSHOT")"

while IFS='=' read -r name hash; do
    [ -n "$name" ] || continue
    if [ -z "${old_map[$name]:-}" ]; then
        echo "new:$name"
    elif [ "${old_map[$name]}" != "$hash" ]; then
        echo "updated:$name"
    fi
done <<< "$(extract_hashes "$LOCKFILE")"

rm -f "$SNAPSHOT"
