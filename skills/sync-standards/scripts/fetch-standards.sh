#!/usr/bin/env bash
set -euo pipefail

# Fetch the latest Playcademy team standards from the canonical repo.
# Requires: gh (GitHub CLI), authenticated via `gh auth login`.
#
# Usage: bash fetch-standards.sh
# Output: standards content written to stdout

REPO="superbuilders/playcademy-skills"
DIR="standards"

files=$(gh api "repos/$REPO/contents/$DIR" --jq 'sort_by(.name) | .[].name') || {
    echo "ERROR: Failed to fetch standards listing from $REPO." >&2
    echo "Make sure you are authenticated: gh auth login" >&2
    exit 1
}

for file in $files; do
    content=$(gh api "repos/$REPO/contents/$DIR/$file" --jq '.content' | base64 -d) || {
        echo "ERROR: Failed to fetch $DIR/$file from $REPO." >&2
        exit 1
    }
    printf '%s\n\n' "$content"
done
