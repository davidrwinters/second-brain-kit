---
name: reorganize-drive
description: Move, rename or consolidate files and folders in cloud storage (Google Drive by default) safely, with a manifest written before anything moves and every vault reference repaired afterwards. Use when the user says reorganize these folders, consolidate this, move these files, clean up my Drive, or proposes a new folder structure.
---

# Reorganize Drive

Cloud storage has no useful move history. A manifest written before the move is the only undo; written after, it's fiction. The step people skip is the last one, and it's the one that breaks things: **every note that stored a path is now wrong.**

## 1. Inventory before deciding

Enumerate what exists (counts, file types, dates, sizes) before proposing a structure.

## 2. Ask the authoritative system

The local filesystem is a proxy. Ownership, sharing and parent folders come from the storage service's API or connector. Shared-with-me folders may not appear locally at all.

## 3. Write the manifest first

`06_Meta/Logs/YYYY-MM-DD-HHMM-moves.txt`, one `from -> to` per file, relative to the storage root. Mark pending decisions inline. Show it and get approval before moving anything.

## 4. Preflight

Every source exists and no destination collides. **Abort on any failure** rather than moving the subset that works.

## 5. Execute, then reconcile by count

Check and state `before + moved_in == after`. Remove folders expected to be empty with `rmdir`, which refuses if anything is still inside.

## 6. Append the outcome to the same manifest

One file is then both the undo and the receipt.

## 7. Repair every reference

Search the vault for every stored path that pointed into the moved area, and check whether each still resolves. Fix live pointers (frontmatter `origin`, links in current notes). Leave dated log entries describing where something used to be; they are correct as written.

## 8. Prefer IDs to paths

A cloud file's ID survives moves; its path does not. Record locations as named links whose URL carries the ID.

## Rules

- Propose before moving. Never delete content; empty folders aren't content.
- Keep a losing duplicate in a `_superseded/` folder beside the winner.
- Don't trust a cloud document's reported size as a content fingerprint; export text and compare.
- Read files before retiring them, and say what was salvaged into the vault.
