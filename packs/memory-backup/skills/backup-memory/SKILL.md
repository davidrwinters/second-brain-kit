---
name: backup-memory
description: Copy the AI agent's machine-local memory files into the vault (06_Meta/agent-memory) so they are backed up with it, and confirm the copy matches. Use when the user says back up memory, sync memory, or asks whether their agent memory is backed up.
---

# Backup memory

The agent's memory lives only on this computer. The vault copy in `06_Meta/agent-memory/` is what survives a move to a new one.

## Procedure

1. Get the memory folder path from `PERSONAL.md` (ask once and record it there if missing).
2. Run `bash 06_Meta/Kit/packs/memory-backup/backup-agent-memory.sh "<memory folder>" "<vault path>"` and report its output.
3. Verify with `diff -rq "<memory folder>" 06_Meta/agent-memory/`. No output means an exact match.
4. If the script refused (missing folder, no files, a sharp drop in count), say which check stopped it. Never force the copy.
5. If `06_Meta/agent-lessons.md` has entries from other agents, and this is the agent whose memory is backed up, fold each into memory, remove it from the file, and run the backup again.
