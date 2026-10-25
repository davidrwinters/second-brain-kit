# Contributing

Thanks for your interest.

- **Issues are welcome:** bugs, ideas, questions, and stories of how you use the kit. Please use the issue templates.
- **Pull requests aren't being accepted yet.** The kit is young and its shape is still settling. That may change; if it does, this file will say how.

**Please never paste personal information into an issue:** no real names, paths that include your username, email addresses, or excerpts from your own notes. Use made-up examples.

## For the maintainer

The full change process (research, build, test matrix, privacy check, review, release) is in [`docs/maintaining.md`](docs/maintaining.md).

Every commit passes a privacy check: `scripts/privacy_scan.py` (a private denylist plus patterns for email addresses, phone numbers, home-directory paths and cloud document IDs) and `gitleaks`, run by the pre-commit hook in `.githooks/`. Enable it once per clone:

```bash
git config core.hooksPath .githooks
git config sbk.denylist /path/outside/the/repo/denylist.txt
```
