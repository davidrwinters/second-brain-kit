# Setup prompt

After running `./install.sh`, open Claude Code or Codex **in the vault folder** and paste the prompt below. The agent interviews you and builds your vault.

```text
Set up my second brain. This folder was just created with second-brain-kit.

First read CLAUDE.md (or AGENTS.md), 06_Meta/Kit/RULES.md, PERSONAL.md, and the RULES.md of
each pack listed in 06_Meta/Kit/installed-packs.txt. Those files are the specification;
follow them, not your defaults. In particular: this is a knowledge base, not a software
project. Do not run git init, do not add README.md files, and do not create empty folders.

Then interview me in short batches (two or three questions at a time, not all at once):
1. Who I am and what this vault is for, and anything that must stay private.
2. Where the vault lives (confirm the path and the cloud storage service), and whether I
   want connectors for documents, email or calendar.
3. My Areas: the ongoing responsibilities I hold (home, health, finances, family members,
   work, pets, a volunteer role...). Each needs a one-line standard.
4. My current Projects: each needs a one-sentence outcome and a rough deadline. If I can't
   give a deadline, tell me it's probably an Area.
5. Resources: topics I collect information about.
6. People worth a note now (a handful is plenty to start).
7. Existing material I want to bring in later (folders, notes in another app, a previous
   attempt). Propose; don't move or delete anything.
8. Writing preferences.

Record what I tell you about myself, my paths and my preferences in PERSONAL.md. Then create
the Areas, Projects, Resources and People notes from the templates in 06_Meta/Templates,
with real outcome, deadline and standard values. Show me what you created, and suggest
three concrete next actions for each project. Finally, run a short weekly-review so I can
see how it works.
