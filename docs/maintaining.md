# Maintaining second-brain-kit

How a change gets from an idea to a release. This is the process actually followed so far, written down so it's repeated every time. It is a living document: after each release, add whatever the last change taught us.

The kit makes three promises to the people who install it, and every step below exists to keep them:

1. **Nothing is deleted.** Not notes, not skills, not old versions of files.
2. **Nothing the person wrote is overwritten without a copy.** `PERSONAL.md`, notes, templates and dashboards are never touched; anything else they may have edited (a loader, a kit skill, a generated file) is saved to `06_Meta/Logs/` before it is replaced.
3. **Nothing personal is published.** The repo is public; it holds only the framework.

## 1. Start from evidence

- **Reproduce the problem before fixing it**, and keep the evidence: the command, its output, the versions involved. Example: v0.2.0 started when `codex debug prompt-input` showed that Codex loaded the kit's `AGENTS.md` pointer but none of the rules it pointed to.
- **Name what's being tested,** with versions (Claude Code, Codex, macOS, bash, rsync). Agent behavior changes from release to release.

## 2. Research, then verify by test

- **Official documentation first.** Blogs, forums and AI summaries are leads, not facts, and they disagree with each other often.
- **Verify anything load-bearing by direct test** on the installed versions, in a throwaway folder. Documentation describes intent; a test shows behavior. Record which claims were tested and which were only read.
- Useful probes: `codex debug prompt-input "hi"` prints exactly what Codex loads, without calling a model; `claude -p "<question>" --model <a small model>` with a sentinel word planted in a test `PERSONAL.md` shows whether Claude Code loaded it.

## 3. Decide before building

- When there is a real design choice, write the options with their trade-offs and a recommendation, and let the maintainer decide. Don't build two versions.
- Check the change against the kit's stated scope before starting. Fixing behavior the kit already claims is maintenance; a new product direction deserves a separate decision.

## 4. Build on a branch

- **Never commit to `main` directly.** One branch per change.
- **Match the existing style:** plain bash, short comments that say why, the installer's `added` / `updated` / `kept` / `saved` messages.
- **Portability:** macOS ships bash 3.2 and BSD tools (`openrsync`, BSD `find`, `sed`, `stat`). No associative arrays, no GNU-only flags. Prefer `cmp`, `cksum`, `find`, `test -nt`, which behave the same on macOS and Linux.
- **Safety by construction:**
  - Refuse, and say why, when an input is missing (no `RULES.md` means no rebuild of `AGENTS.md`, not an empty one).
  - Back up before replacing anything the person might have edited, and say where the copy went.
  - Never delete. Sync by copying; removing something is the person's job.
  - Re-running must be safe and quiet: an install over an up-to-date vault changes nothing and backs up nothing.
- **Scripts that hooks run after every reply** need extra care: several agents may fire at once (take a lock, and give up quietly if it's held), readers must never see a half-written file (write to a temp file, then rename), and a run that changes nothing must write nothing inside the synced folder (keep locks and scratch files in `$TMPDIR`).
- **Update the docs in the same change:** `README.md`, `docs/guide.md`, `kit/RULES.md`, the skills, the packs and `SETUP-PROMPT.md`. Then search the whole repo for wording that still describes the old behavior.
- **Bump `kit/VERSION`.** Minor version for new behavior, patch for fixes.

## 5. Test in throwaway vaults only

**Never point `install.sh` or any kit script at a real vault.** Always pass an explicit `--vault` inside a temporary folder, and use a path that contains a space. Delete the test folders afterwards.

The matrix, run in full after the change and again after every round of fixes:

| Area | Cases |
| --- | --- |
| Install | Fresh install with all packs; with none |
| Re-run | Installing twice changes nothing, rebuilds nothing, backs up nothing |
| Upgrade | Install the previous release (`git worktree add <tmp> v0.1.0`), add personal content, then upgrade with the new installer; nothing personal lost, no needless backups |
| Edits preserved | `PERSONAL.md`, notes, an edited `CLAUDE.md`, an edited kit skill, a hand-edited generated file: each kept or backed up |
| Error paths | Missing inputs, a pack listed but not installed, Windows line endings in config files |
| Concurrency | Several runs at once, repeated (for example 3 in parallel, 30 times): no stray files, no lock left behind, no false backups |
| Limits | Size warnings fire where they should |
| Agents | Codex loads the rules from the vault root and from a subfolder; Claude Code loads them through `CLAUDE.md` |

Write down the results; they go in the pull request.

## 6. Privacy check

- `scripts/privacy_scan.py` on every changed file, and `gitleaks`. The pre-commit hook runs both; also run them by hand before asking for review.
- No real names, email addresses, usernames in paths, account or document IDs. Examples are invented.
- The denylist and allowlist that feed the scan live outside the repo and are never committed.

## 7. Fresh-eyes review

- Before anything is merged, someone with no context reviews it: another person, or a separate agent session that has seen none of the work. Give them the diff, a short description of what the change is meant to do, the three promises above, and two rules: test only in throwaway folders, and change nothing in the repo.
- Ask for a ranked list of concrete findings (file, line, failure scenario, suggested fix), with real bugs separated from nits.
- Fix every real bug, then **re-run the whole test matrix**, not just the cases that failed. Fixes break things too.
- This step earns its place: the v0.2.0 review found an overwrite bug that had shipped in v0.1.0, and a way the new two-way sync could silently drop an edit.

## 8. Pull request

- Push the branch and open a pull request. The description has a TL;DR first, then: what changed and why, upgrade notes, test results, and the review findings with their fixes.
- The maintainer reads the pull request and decides. Nothing is merged or tagged before that.

## 9. Commit, merge, release

- Commits use the GitHub noreply address, and messages describe the change in plain words. No tool attributions, co-author trailers or session links.
- After approval: merge, tag `vX.Y.Z` on `main`, push the tag.
- Verify as an anonymous visitor: the repository page loads, the files are the expected ones, and nothing private is present.

## 10. Record and improve

- Note what was released, and why, in the maintainer's own records (outside the repo).
- Add to this document anything the change taught us.

## Lessons so far

- **v0.2.0:** Codex loads only `AGENTS.md`; a file that tells it to "read these other files" is not enough, so `AGENTS.md` is now generated with the rules inside it. Codex finds a project's root by `.git`, which a vault doesn't have. `rsync --update` overwrites a file whose timestamp is equal but whose size differs, so the skill sync compares files itself and backs up whatever it replaces. The installer's "is this a kit file?" check (does it contain the kit's name?) let it overwrite a kit file the person had edited, so it now compares against what the kit actually shipped.
