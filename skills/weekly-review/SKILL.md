---
name: weekly-review
description: Run the weekly maintenance pass over the vault: process the inbox, update active projects, surface stalled work, and propose archives. Use when the user says weekly review, review my projects, what is stale, or asks for a status pass across everything.
---

# Weekly Review

Five minutes, not an afternoon. The value is in the turnover it creates.

## 1. Inbox

Run `process-inbox`.

## 2. Active projects

For each project with `status: active`:

- **Still a project?** If the outcome has drifted into something unfinishable, it's become an Area. Say so.
- **A real next action?** A project with no concrete next step is stalled. Propose one.
- **Done since last review?** Check off completed actions.
- **Too big?** If it contains several independent finishes, propose splitting it.
- Update `updated` on anything touched.

## 3. Waiting On

Sweep every project's `## Waiting On`. Anything asked for more than a week ago becomes a follow-up action.

## 4. People

From the People dashboard, list anyone whose `next-touch` date has passed.

## 5. Stalled work

Report any project untouched for 30 days or more, and ask for one of: a next action, `on-hold`, or archiving.

## 6. Archive candidates

Propose archiving anything completed or abandoned, through `close-project`.

## 7. Reference check

Notes store paths, and paths move. Check that file paths and links stored in notes still resolve, and report the broken ones. A dated log entry describing where something used to live is correct as written; only live pointers get repaired.

## 8. Agent files check

- **Skill folders must match:** `diff -rq .claude/skills .agents/skills`. If they differ, `.claude/skills/` is canonical: `rsync -a --delete .claude/skills/ .agents/skills/`.
- **Snapshot `PERSONAL.md`** to `06_Meta/Logs/YYYY-MM-DD-PERSONAL.md.bak` if it changed since the last snapshot. Keep every snapshot; they are the only history.

## 9. Report

Inbox processed and remaining; projects active and stalled; waiting-on items with ages; people due a touch; proposed archives; broken references; whether the agent files check passed.

## Rules

- **Don't reorganize.** This is maintenance, not redesign.
- Propose every move; execute nothing without approval.
- If the inbox is huge after a long gap, offer to bulk-archive the old material.
