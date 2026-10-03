# Obsidian

The installer applies the recommended settings below to a brand-new vault. For an existing vault, set them by hand.

**Obsidian** is a free app for reading and editing Markdown. It doesn't store your notes anywhere special: it simply opens a folder of `.md` files (it calls the folder a "vault"), which is why it pairs so well with Google Drive and Claude Code. Claude Code writes the files; Obsidian is where you read, browse, search and edit them, with links, properties and dashboards rendered properly.

## Install and open the vault

1. Download Obsidian from [obsidian.md](https://obsidian.md) and install it.
2. On the start screen choose **Open folder as vault** and select the vault folder inside My Drive (on a Mac, the `~/Library/CloudStorage/GoogleDrive-<email>/My Drive/secondbrain` folder).
3. Trust the folder when asked. **Don't install community plugins to start**; the built-in features are enough.

Obsidian creates a hidden `.obsidian/` folder inside the vault for its settings. Leave it there; it syncs through Drive like everything else.

## Settings to change (Settings, the gear icon)

**Files and links**
- **Default location for new notes:** `In the folder specified below`, then `00_Inbox`.
- **New link format:** `Shortest path when possible`.
- **Use [[Wikilinks]]:** on.
- **Automatically update internal links:** on, so links survive when notes move between PARA folders.
- **Default location for new attachments:** `In the folder specified below`, then `05_Attachments/Files`.
- **Detect all file extensions:** on, so PDFs and other files show in the file list.

**Editor**
- **Readable line length:** on.
- Leave **Strict line breaks** at its default (off). That is why notes use one long line per paragraph.
- **Properties in document:** `Visible`, so the frontmatter shows as a clean property panel.

**Core plugins** (Settings, Core plugins): turn on
- **Templates**, with **Template folder location** `06_Meta/Templates` and **Date format** `YYYY-MM-DD`.
- **Bases**, for the dashboards in `06_Meta/Dashboards/`.
- **Backlinks** and **Outgoing links**, to see what links to and from a note.
- **Quick switcher** (Cmd-O / Ctrl-O), **Search**, **File explorer**, **Bookmarks** and **Properties view**.
- Optional: **Graph view**, **Daily notes** (point it at `00_Inbox` if used), **Command palette**.

## Everyday use

- **Find anything** with the quick switcher (Cmd-O) or search (Cmd-Shift-F).
- **Insert a template** in a new note with the command palette (Cmd-P) → "Templates: Insert template".
- **Bookmark the dashboards** (`06_Meta/Dashboards/*.base`) and the active project notes for one-click access.
- **Edit freely.** Changes you make in Obsidian and changes Claude Code makes are the same files; just avoid editing the same note in both at the same moment.
- **Open a note from Claude Code:** ask the agent to "open it in Obsidian"; it uses the `obsidian://` link in the rules.
- **Optional:** the official [Obsidian Web Clipper](https://obsidian.md/clipper) browser extension saves web pages as Markdown straight into `00_Inbox`.

## Things to know

- **Choose one sync method.** Google Drive is the sync. Don't also turn on Obsidian Sync or iCloud for the same vault, or the two will fight and create conflict copies.
- **Phones and tablets:** Obsidian's mobile apps can't open a vault stored in Google Drive directly (iOS in particular only opens local or iCloud vaults). On a phone, read notes through the Google Drive app, or treat the computer as the place for the vault. If mobile editing becomes important, that's a separate decision (Obsidian Sync is the usual answer).
- **Conflict files.** If Drive ever creates a duplicate like `Note (1).md`, it means a file was edited in two places at once. Compare, merge into the original, and archive the copy.
- **Obsidian's command-line tool** (optional, needs Obsidian running) lets the agent open notes and run searches inside the app; Claude Code works fine without it.
