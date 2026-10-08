# second-brain-kit

A starter kit for a "second brain": it uses the **PARA method** to organize all of your digital information (notes, documents, meetings, sources, people and projects), with AI coding agents such as **Claude Code** and **Codex** doing the filing, linking and summarizing. Everything is plain Markdown, stored in a cloud folder you already use (**Google Drive** by default; iCloud Drive, Dropbox or a local folder also work), and read and edited in **Obsidian**.

The kit gives the agent a clear set of rules and repeatable skills, so it files, links, summarizes and reviews your notes the same way every time, and asks before it moves anything.

## What you get

- **Rules** the agent reads every session: the PARA structure, naming and linking conventions, frontmatter, writing style, privacy, and operating rules like *propose before moving* and *never delete*.
- **Skills** (workflows the agent runs when you ask): `capture`, `process-inbox`, `new-project`, `add-source`, `find-context`, `weekly-review`, `close-project`, `reorganize-drive`.
- **Templates** for projects, areas, resources, sources and people, and **Obsidian Bases dashboards** that list them live.
- **Packs** (optional): `meetings` (meeting notes, transcript processing, action items pushed to projects) and `memory-backup` (copies the agent's machine-local memory into the vault).
- **Your own rules** in `PERSONAL.md`, which the kit never overwrites, so you can update the kit without losing your changes.
- **An example vault** in `examples/vault/` to see what a working one looks like.

## Why this shape

- **It's a knowledge base, not a code repo.** Notes live in your cloud storage, which syncs automatically to every device, with no commits and no pushes. This repository holds only the framework; your notes never go in it.
- **PARA, the whole method.** Projects (outcome and deadline), Areas (ongoing standard), Resources (interests), Archive (inactive). A note's location reflects how actionable it is, not its topic.
- **Agent-neutral.** Rules load through `CLAUDE.md` (Claude Code) and `AGENTS.md` (Codex and others); skills are mirrored to `.claude/skills/` and `.agents/skills/`.

## Quick start

1. **Install the prerequisites:** [Obsidian](https://obsidian.md), [Claude Code](https://docs.claude.com/en/docs/claude-code/overview) or [Codex](https://developers.openai.com/codex), and your cloud storage client. For Google Drive, install [Google Drive for desktop](https://support.google.com/drive/answer/10838124) and either use **Mirror** mode or, in Stream mode, mark the vault folder **Available offline**.
2. **Clone and install:**

```bash
git clone https://github.com/davidrwinters/second-brain-kit.git
cd second-brain-kit
./install.sh
```

The installer asks where the vault should live (it suggests a folder in Google Drive if it finds one) and which packs you want. Re-run it any time to update: kit-managed files (rules, loaders, skills, pack files) are refreshed. Your notes and `PERSONAL.md` are never touched, and nothing is deleted. Templates and dashboards become yours once installed and are never overwritten, so improvements to them in new kit versions don't apply automatically; compare with the repo's `templates/` and `dashboards/` if you want them. The installer won't overwrite an existing `CLAUDE.md` or `AGENTS.md` without backing it up and asking first.

3. **Open the folder in Obsidian** (Open folder as vault). The installer applies recommended settings to a new vault; see `docs/obsidian.md`.
4. **Start your agent in the vault folder** and paste the prompt from [`SETUP-PROMPT.md`](SETUP-PROMPT.md). It interviews you and builds your areas, projects and people.

## Using it

Talk normally; the rules map everyday phrases to skills:

| Say | What happens |
| --- | --- |
| "capture this: ..." | A note lands in `00_Inbox` in your words |
| "process my inbox" | The agent proposes where each item goes, then files on your OK |
| "start a project for ..." | A project from the template, with an outcome and deadline (or it tells you it's an Area) |
| "add this doc to ..." | The document is read, summarized into a source note, and linked from the project |
| "what do I know about ...?" | Context gathered from the vault, including the archive |
| "weekly review" | Inbox, stalled projects, overdue follow-ups, people due a touch |
| "... is done" | Retrospective, harvest anything reusable, archive |

## Layout after install

```
your-vault/
├── CLAUDE.md, AGENTS.md     Loaders (kit-managed)
├── PERSONAL.md              Your rules (yours; never overwritten)
├── 00_Inbox/ 01_Projects/ 02_Areas/ 03_Resources/ 04_Archive/ 05_Attachments/
├── 06_Meta/                 Metadata: the files that run the vault, not notes
│   ├── Kit/                 RULES.md, VERSION, installed-packs.txt, packs/ (kit-managed)
│   ├── Templates/           Note templates (yours once installed)
│   └── Dashboards/          Obsidian Bases (yours once installed)
├── .claude/skills/          Skills (kit-managed), mirrored to .agents/skills/
└── .obsidian/               Settings (only created for a new vault)
```

## Learn more

- [`docs/guide.md`](docs/guide.md): the full guide (PARA, conventions, cloud storage, Obsidian, agent setup)
- [`docs/obsidian.md`](docs/obsidian.md): Obsidian settings and everyday use
- [The PARA Method](https://fortelabs.com/blog/para/) by Tiago Forte

## Contributing

Issues are welcome: bugs, ideas, questions. Pull requests aren't being accepted yet; see [`CONTRIBUTING.md`](CONTRIBUTING.md).

## License

[MIT](LICENSE)

Built with the help of AI coding agents.
