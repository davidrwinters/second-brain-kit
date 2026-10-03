#!/bin/bash
# Copy an AI agent's machine-local memory folder into the vault so it is backed up with it.
# Usage: backup-agent-memory.sh "<memory folder>" "<vault path>"
SRC="${1:?usage: backup-agent-memory.sh <memory folder> <vault path>}"
VAULT="${2:?usage: backup-agent-memory.sh <memory folder> <vault path>}"
DEST="$VAULT/06_Meta/agent-memory/"
SRC="${SRC%/}/"

# Safety checks: never mirror an empty or missing memory folder over a good backup.
if [ ! -d "$SRC" ]; then echo "Memory folder not found: $SRC" >&2; exit 1; fi
COUNT=$(find "$SRC" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')
if [ "$COUNT" -lt 1 ]; then echo "No memory files in $SRC; not copying, to protect the backup." >&2; exit 1; fi
if [ ! -d "$VAULT/06_Meta" ]; then echo "Not a vault (no 06_Meta): $VAULT" >&2; exit 1; fi
if [ -d "$DEST" ]; then
  OLD=$(find "$DEST" -maxdepth 1 -name '*.md' | wc -l | tr -d ' ')
  if [ "$OLD" -gt 0 ] && [ "$COUNT" -lt $((OLD / 2)) ]; then
    echo "Memory shrank from $OLD to $COUNT files; not copying. Check before overwriting the backup." >&2; exit 1
  fi
fi
mkdir -p "$DEST"
# --delete keeps the backup an exact copy, so a memory removed for being wrong doesn't come back.
rsync -a --delete --include='*.md' --exclude='*' "$SRC" "$DEST" || exit 1
echo "Memory backed up: $COUNT files to 06_Meta/agent-memory"
