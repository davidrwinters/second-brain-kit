# Memory-backup pack (optional)

AI coding agents keep their own memory on the computer, outside the vault, and it doesn't sync. This pack copies that memory into `06_Meta/agent-memory/` so it's backed up with the vault and survives a move to a new computer.

## What it installs

- `06_Meta/Kit/packs/memory-backup/backup-agent-memory.sh`: the copy script, with safety checks so an empty or missing memory folder never overwrites a good backup.
- The `backup-memory` skill.

## Setup

1. Find your agent's memory folder. For Claude Code it's under `~/.claude/projects/<project-folder>/memory/`, where `<project-folder>` is the vault path with `/` and other punctuation replaced by `-`.
2. Set it once in `PERSONAL.md` (the agent reads it from there), or pass it to the script:

```bash
bash 06_Meta/Kit/packs/memory-backup/backup-agent-memory.sh "<memory folder>" "<vault path>"
```

3. **Optional, automatic:** add a Claude Code hook in `~/.claude/settings.json` that runs the script after each reply (`Stop` event). See the Claude Code hooks documentation; ask your agent to set it up.

On a new computer, copy `06_Meta/agent-memory/` back into the agent's memory folder before starting.
