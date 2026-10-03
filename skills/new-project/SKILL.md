---
name: new-project
description: Create a new project, area, or resource in the vault from the standard templates. Use when the user says start a project, new project for X, set up an area for X, create a resource on X, or describes something new they are taking on that needs a home.
---

# New Project

The main job is getting the category right. Most people call everything a project, and a project list full of unfinishable items destroys the motivation the system is supposed to create.

## The test, before creating anything

- **Project:** an outcome you can mark complete, and a rough deadline. "Renovate the bathroom."
- **Area:** a standard maintained indefinitely, with no finish line. "Home." "Health."
- **Resource:** a topic of interest with no responsibility attached. "woodworking."

If the user asks for a project but can't say what "done" looks like, or there's no plausible end date, **say so directly**: it's an Area, and offer to create one. Never create a project with an empty `outcome` or `deadline`. The reverse applies too: an "area" with a clear end state is a project.

## Procedure

1. **Ask for what's missing** in one message: for a project, a name, a one-sentence outcome and a rough deadline ("sometime this fall" is fine).
2. **Check `04_Archive`** for related past work, and link anything relevant under `## Related`.
3. **Check for overlap** with an active project; offer to add to it instead of splitting context.
4. **Create the folder and folder note** from `06_Meta/Templates/`:
   - `01_Projects/<Project Name>/<Project Name>.md`
   - `02_Areas/<Area Name>/<Area Name>.md`
   - `03_Resources/<lowercase name>/<lowercase name>.md`

   Fill in `created` and `updated`, plus `outcome`, `deadline` and `area` for projects, `standard` for areas.
5. **No subfolders.** `Meetings/`, `Sources/` and `Output/` are created when there is a file for them.
6. **Link it up.** If the project serves an area, add it to the area's `## Current Projects` and set the project's `area`.
7. **Offer three or four concrete first actions.** Physical and specific: "email the contractor for a quote," not "think about contractors."
