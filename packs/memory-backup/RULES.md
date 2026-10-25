# Memory-backup pack: rules

AI agents keep memory files on the computer, outside the vault, and they don't sync. This pack copies them into `06_Meta/agent-memory/` so they're backed up with the vault.

- **The memory folder's path is recorded in `PERSONAL.md`** under "Where things live". If it's missing, ask once and record it.
- **The copy script refuses** when the memory folder is missing or empty, or has shrunk sharply since the last backup. Never force it; report which check stopped it.
- **Every agent reads the backed-up memory.** At the start of a session, read the memory index in `06_Meta/agent-memory/` (Claude Code's is `MEMORY.md`) and open the entries that bear on the task; they carry the same weight as the rules.
- **Only the agent whose memory is backed up writes there.** Each backup replaces the folder, so another agent's edits would be lost. Other agents add new lessons (a correction, a stated preference, a mistake not to repeat) to `06_Meta/agent-lessons.md` instead, one dated entry each, creating the file when the first lesson needs it. The agent whose memory it is folds each entry into its memory and removes it from the file.
- **On a new computer,** copy `06_Meta/agent-memory/` back into the agent's memory folder before the first session.
- Setup details, including an optional automatic hook, are in `06_Meta/Kit/packs/memory-backup/README.md`.

## Intent routing (added)

| The person says | Skill |
| --- | --- |
| "back up memory", "is my memory backed up?" | `backup-memory` |
