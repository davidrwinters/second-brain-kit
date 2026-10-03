# Memory-backup pack: rules

AI agents keep memory files on the computer, outside the vault, and they don't sync. This pack copies them into `06_Meta/agent-memory/` so they're backed up with the vault.

- **The memory folder's path is recorded in `PERSONAL.md`** under "Where things live". If it's missing, ask once and record it.
- **The copy script refuses** when the memory folder is missing or empty, or has shrunk sharply since the last backup. Never force it; report which check stopped it.
- **On a new computer,** copy `06_Meta/agent-memory/` back into the agent's memory folder before the first session.
- Setup details, including an optional automatic hook, are in `06_Meta/Kit/packs/memory-backup/README.md`.

## Intent routing (added)

| The person says | Skill |
| --- | --- |
| "back up memory", "is my memory backed up?" | `backup-memory` |
