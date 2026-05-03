#!/usr/bin/env bash
set -euo pipefail

# Compare skills-lock.json before and after an update to determine
# which Playcademy skills were added, updated, or unchanged.
#
# Usage:
#   bash diff-skills.sh snapshot           # Before update: save current state
#   bash diff-skills.sh compare            # After update: compare against snapshot
#
# Output (compare mode), one line per changed skill:
#   new:<skill-name>
#   updated:<skill-name>
#
# Unchanged skills produce no output.

LOCKFILE="skills-lock.json"
SNAPSHOT="/tmp/playcademy-skills-snapshot.json"

extract_playcademy_hashes() {
    local file="$1"
    if [ ! -f "$file" ]; then
        echo "{}"
        return
    fi
    # Extract playcademy-* skill names and their computedHash values
    # Output: name=hash lines, sorted
    python3 -c "
import json, sys
with open('$file') as f:
    data = json.load(f)
for name, info in sorted(data.get('skills', {}).items()):
    if name.startswith('playcademy-'):
        print(f\"{name}={info.get('computedHash', '')}\")
" 2>/dev/null || true
}

case "${1:-}" in
    snapshot)
        if [ -f "$LOCKFILE" ]; then
            cp "$LOCKFILE" "$SNAPSHOT"
        else
            echo '{}' > "$SNAPSHOT"
        fi
        ;;
    compare)
        old_hashes=$(extract_playcademy_hashes "$SNAPSHOT")
        new_hashes=$(extract_playcademy_hashes "$LOCKFILE")

        # Build associative arrays
        declare -A old_map
        while IFS='=' read -r name hash; do
            [ -n "$name" ] && old_map["$name"]="$hash"
        done <<< "$old_hashes"

        while IFS='=' read -r name hash; do
            [ -n "$name" ] || continue
            if [ -z "${old_map[$name]:-}" ]; then
                echo "new:$name"
            elif [ "${old_map[$name]}" != "$hash" ]; then
                echo "updated:$name"
            fi
        done <<< "$new_hashes"

        # Clean up snapshot
        rm -f "$SNAPSHOT"
        ;;
    *)
        echo "Usage: diff-skills.sh [snapshot|compare]" >&2
        exit 1
        ;;
esac
