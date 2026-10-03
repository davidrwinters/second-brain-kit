# Guide

The background for second-brain-kit: what a second brain is, the PARA method, why the notes live in cloud storage, and how the pieces fit. The rules the agent follows are in [`kit/RULES.md`](../kit/RULES.md); Obsidian setup is in [`obsidian.md`](obsidian.md).

## What this is, and what it is not

**It is a knowledge base.** Notes about your projects, responsibilities, interests and the people in your life, written so that you (and an AI agent) can find and use them months later. Every file is plain Markdown with a small block of YAML properties at the top.

**It is not a code repository.** That is the mistake to avoid. Coding agents default to treating any folder of files as a software project: they run `git init`, push to GitHub, add `README.md`, `src/` and `docs/`, and organize by file type. None of that fits a personal knowledge base:

| Code-project habit | Why it is wrong here | What to do instead |
| --- | --- | --- |
| Git and GitHub for sync and history | Requires commits and pushes; personal and family information ends up on a code host; phones and other computers can't easily read it | **Google Drive syncs automatically**, works on every device, and already holds your documents |
| Organize by type (`docs/`, `notes/`, `meetings/`) | Says what a file *is*, not what you're *doing* with it | **Organize by actionability (PARA)**: where a note lives reflects your current relationship to it |
| `README.md` in every folder | Dozens of files with the same name break Obsidian's linking and quick switcher | **A folder note** whose name matches the folder |
| Create the whole folder tree up front | Empty folders are clutter that never gets used | **Create a folder only when there is a file to put in it** |
| Git history as the undo button | Not available without Git | **Never delete** (archive instead), and **write a move manifest** before any bulk move (see the rules) |

**Partial PARA is also a failure.** Using "projects" and "resources" but skipping Areas, or having no Archive, or mixing them, loses the point. All four categories, plus an inbox, are required.

---

## The PARA method in one page

PARA was created by Tiago Forte. It sorts everything into four categories by **how actionable it is**, not by topic.

| Category | What goes here | The test |
| --- | --- | --- |
| **Projects** | Short-term efforts with a defined outcome and a deadline. "Renovate the kitchen", "Choose a high school", "Plan the June trip" | Can you say what "done" looks like, and roughly when? |
| **Areas** | Ongoing responsibilities with a standard to maintain, and no end date. "Health", "Home", "Finances", "Kids' school", "Car" | Is there a standard you keep up indefinitely? |
| **Resources** | Topics of interest with no responsibility attached. "Gardening", "Recipes", "Travel ideas" | Is it useful or interesting, but you're not on the hook for it? |
| **Archive** | Anything from the three above that went inactive: finished projects, areas you no longer hold, resources you lost interest in | Is it no longer active? |

**The sorting rule, applied in order:**

1. Will it help move a **project** forward? Then `01_Projects`.
2. If not, does it uphold a standard in an **area** of responsibility? Then `02_Areas`.
3. If not, does it support an **interest**? Then `03_Resources`.
4. If none of these, `04_Archive`.

**Things move.** A note's location reflects its *current* relationship to you. When a project finishes, it moves to the Archive. When a resource becomes the basis for a project, the note moves into the project. **Move notes; never duplicate them.**

**A project without an outcome and a deadline is really an Area.** If you can't write "done means X, by roughly Y", it belongs in Areas. The agent should say so rather than create a vague project.

**CODE**, Forte's companion workflow, describes what you do with notes: **Capture** (get it in quickly), **Organize** (file by PARA), **Distill** (summarize, with the summary at the top), **Express** (use it to produce something). The skills in the rules map onto these steps.

---

## Where the files live: Google Drive as the backing store

**Install Google Drive for desktop** and sign in. On a Mac, your Drive appears in Finder and at a path like:

```
~/Library/CloudStorage/GoogleDrive-<your-email>/My Drive/
```

**Create the vault as a folder inside My Drive**, for example `My Drive/secondbrain/`. That folder is the whole system: Claude Code works in it, Obsidian opens it, Drive syncs it.

**Use Mirror mode, not Stream mode,** in Google Drive for desktop's preferences, at least for the vault folder. In Stream mode files can be "online only" and appear empty or missing to Obsidian and Claude Code until opened. Mirror keeps real copies on disk.

**Why Drive works well here:**

- **Sync is automatic.** No commits, no pushes. Edit on one computer, and it's on the others.
- **It's where your documents already are.** PDFs, scans, Google Docs and photos are one folder away from the notes about them.
- **Google Docs, Sheets and Slides stay in Google.** On disk they appear as small `.gdoc` / `.gsheet` / `.gslides` files, which are **JSON pointers** (about 200 bytes) containing a `doc_id`, not the content. The agent reads their content through the **Google Drive connector** (see the rules), or via the export URL `https://docs.google.com/document/d/<doc_id>/export?format=txt`.
- **Drive has some history of its own.** Deleted files go to Drive's Trash for 30 days, and non-Google files keep a version history in the Drive web interface. This is a safety net, not a substitute for the "never delete" rule.

**Things to know:**

- **Link Drive items by name, with the URL.** Write `[Insurance policy 2026](https://drive.google.com/file/d/<id>/view)`, not a bare ID and not a local path. Drive IDs never change when files move; paths do. URL forms: Docs `docs.google.com/document/d/<id>/edit`, Sheets `docs.google.com/spreadsheets/d/<id>/edit`, other files `drive.google.com/file/d/<id>/view`, folders `drive.google.com/drive/folders/<id>`.
- **Getting a local file's Drive ID instantly (Mac):** `xattr -p 'com.google.drivefs.item-id#S' "<file>"`.
- **Which route to use:** Google Docs, Sheets and Slides through the connector (the local file is only a pointer). PDFs, Word files, images and Markdown through the local path (faster, no API call). Folder listings with `ls` and `find` locally.
- **Opening a note in Obsidian from the terminal (Mac):** pass Obsidian a URL-encoded absolute path. Use the `~/Library/CloudStorage/...` form; a symlinked path to the same folder can fail silently.

```bash
P="/Users/<you>/Library/CloudStorage/GoogleDrive-<email>/My Drive/secondbrain/01_Projects/Example/Example.md"
ENC=$(python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1],safe=''))" "$P")
open "obsidian://open?path=$ENC"
```

---

## How the kit maps onto this

- **The rules** (`06_Meta/Kit/RULES.md` in your vault) are loaded every session through `CLAUDE.md` (Claude Code) or `AGENTS.md` (Codex). They are replaced when you update the kit.
- **Your own rules** go in `PERSONAL.md`, which overrides the framework and is never overwritten.
- **Skills** in `.claude/skills/` (mirrored to `.agents/skills/`) are the repeatable workflows: capture, inbox processing, new projects, adding sources, finding context, the weekly review, closing projects, and reorganizing storage.
- **Templates and dashboards** in `06_Meta/` are yours to customize once installed.
- **Packs** add optional capabilities; installed packs are listed in `06_Meta/Kit/installed-packs.txt`.

## Privacy

A second brain accumulates health, financial, family and other people's information. Put rules in `PERSONAL.md`:

- **Secrets never go in the vault.** Passwords, recovery codes and account numbers belong in a password manager. At most, note *where* something is kept.
- **Other people's sensitive details** (health, private opinions shared in confidence) are recorded only as far as they matter to you, and never travel outward.
- **Nothing from the vault is sent to an external service, published or shared** unless you ask.

---

## Agent memory, and moving computers

AI coding agents keep their own **memory files** on the computer, outside the vault (Claude Code's are under `~/.claude/projects/`). They do **not** sync with your cloud storage. The optional **memory-backup pack** copies them into `06_Meta/agent-memory/` so they're backed up with the vault; it can run automatically through an agent hook. Keep a short note in `06_Meta` of what to redo on a new computer: the cloud storage client, Obsidian, your agent, connectors, and any hooks.

---

## Further reading

**PARA and Building a Second Brain (Tiago Forte)**

- [The PARA Method: The Simple System for Organizing Your Digital Life](https://fortelabs.com/blog/para/): the original explanation of the four categories.
- [Building a Second Brain: the definitive introductory guide](https://fortelabs.com/blog/basboverview/): the broader method, including CODE.
- [The PARA Method](https://www.buildingasecondbrain.com/para) and the book *Building a Second Brain* (2022) and *The PARA Method* (2023), both by Tiago Forte.
- [Progressive Summarization](https://fortelabs.com/blog/progressive-summarization-a-practical-technique-for-designing-discoverable-notes/): the "summary on top, detail below" distillation technique.

**Obsidian**

- [Obsidian Help](https://help.obsidian.md/), including [Properties](https://help.obsidian.md/properties), [Internal links](https://help.obsidian.md/links) and [Bases](https://help.obsidian.md/bases).
- [Obsidian URI](https://help.obsidian.md/Extending+Obsidian/Obsidian+URI): the `obsidian://open` links used in the rules.
- [Templates plugin](https://help.obsidian.md/plugins/templates), [Settings for files and links](https://help.obsidian.md/files-and-folders/manage-files) and [Obsidian Web Clipper](https://obsidian.md/clipper).

**Google Drive**

- [Use Google Drive for desktop](https://support.google.com/drive/answer/10838124), including streaming versus mirroring files.

**Claude Code**

- [Claude Code documentation](https://docs.claude.com/en/docs/claude-code/overview), especially [memory and CLAUDE.md](https://docs.claude.com/en/docs/claude-code/memory), [skills](https://docs.claude.com/en/docs/claude-code/skills), [hooks](https://docs.claude.com/en/docs/claude-code/hooks) and [MCP connectors](https://docs.claude.com/en/docs/claude-code/mcp).
- [Agent Skills specification](https://agentskills.io): the open format the skills follow.

If a link has moved, search for its title; the concepts are stable even when URLs change.

