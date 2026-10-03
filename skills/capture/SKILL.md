---
name: capture
description: Save a thought, idea, task, link, or fragment into the vault inbox without deciding where it belongs. Use when the user says capture this, remember this, note this down, save this, add to my inbox, or drops a stray thought mid-conversation that is clearly worth keeping.
---

# Capture

Capture first, clarify later. No filing decision is required; if this takes more than a few seconds, it has failed.

## Procedure

1. Write a single file to `00_Inbox/`.
2. Name it `YYYY-MM-DD Short Description.md`, descriptive enough that `process-inbox` can act on it later without opening it. "Idea" and "Note" are not descriptions.
3. Frontmatter:

```yaml
---
type: note
created: YYYY-MM-DD
updated: YYYY-MM-DD
tags:
  - inbox
---
```

4. Body: the thought, in the user's own words. Do not expand, structure or improve it. If they wrote one line, write one line.
5. If context makes the note more useful later (what prompted it, a link that was open, a project it obviously touches), add it under `## Context` in a sentence.
6. Confirm in one line: the file name and nothing else.

## Rules

- Never ask where it should go. That is `process-inbox`'s job.
- Never file it directly into a project, even when the destination seems obvious. Filing is a deliberate, batched act.
- Files land flat in the inbox, except transcripts and documents, which have their own drop folders.
- Several captures in one turn get one file each.

## Proactive capture

If the user says something that is clearly a durable insight, decision or commitment, offer once: "Worth capturing?" If they decline, don't ask again in that session.
