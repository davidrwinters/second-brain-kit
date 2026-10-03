#!/usr/bin/env python3
"""Scan files for personal information before they are committed or published.

Checks every file for:
  - terms from a private denylist (whole word, case-insensitive), if one is configured
  - email addresses, phone numbers, home-directory paths, and Google Drive/Docs IDs

The denylist is personal by nature (it contains the very names it guards against), so it
must live OUTSIDE this repository. Point to it with the SBK_DENYLIST environment variable,
or once per clone with:  git config sbk.denylist /path/outside/the/repo/denylist.txt
Maintainer-specific exceptions go in a private allowlist the same way (SBK_ALLOWLIST or
git config sbk.allowlist); scripts/privacy-allowlist.txt holds only generic phrases.

Usage:
  scripts/privacy_scan.py                 # scan every file in the working tree
  scripts/privacy_scan.py FILE [FILE...]  # scan specific files (used by the pre-commit hook)
Exit status is 1 if anything is found.
"""
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SKIP_DIRS = {".git", "node_modules"}
SKIP_FILES = {"scripts/privacy_scan.py", "scripts/privacy-allowlist.txt"}

PATTERNS = {
    "email address": re.compile(r"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}"),
    "phone number": re.compile(r"(?<!\d)(?:\+?1[ .-]?)?\(?\d{3}\)?[ .-]\d{3}[ .-]\d{4}(?!\d)"),
    "home directory path": re.compile(r"/(?:Users|home)/(?!you\b|<|\$|USER\b|example\b)[A-Za-z0-9._-]+"),
    "Google Drive/Docs ID": re.compile(r"(?:/d/|/folders/|[?&]id=)[A-Za-z0-9_-]{20,}"),
    "CloudStorage account path": re.compile(r"GoogleDrive-[^/<\s]+@"),
}
SAFE_EMAILS = {"you@example.com", "name@example.com", "user@example.com"}


def git_config(key):
    out = subprocess.run(["git", "-C", ROOT, "config", "--get", key], capture_output=True, text=True).stdout.strip()
    return out or None


def load_lines(path):
    if not path or not os.path.exists(path):
        return []
    with open(path, encoding="utf-8") as fh:
        return [ln.strip() for ln in fh if ln.strip() and not ln.lstrip().startswith("#")]


def list_files(args):
    if args:
        out = []
        for a in args:
            p = a if os.path.isabs(a) else os.path.join(ROOT, a)
            if os.path.isfile(p):
                out.append(os.path.relpath(p, ROOT))
        return out
    out = []
    for dirpath, dirnames, filenames in os.walk(ROOT):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for f in filenames:
            out.append(os.path.relpath(os.path.join(dirpath, f), ROOT))
    return out


def main():
    denylist_path = os.environ.get("SBK_DENYLIST") or git_config("sbk.denylist")
    private_allow = os.environ.get("SBK_ALLOWLIST") or git_config("sbk.allowlist")
    terms = load_lines(denylist_path)
    allow = [a.lower() for a in load_lines(os.path.join(ROOT, "scripts/privacy-allowlist.txt")) + load_lines(private_allow)]
    allow.sort(key=len, reverse=True)
    if denylist_path and not terms:
        print(f"privacy-scan: denylist {denylist_path} is missing or empty", file=sys.stderr)
        return 2
    term_res = [(t, re.compile(r"(?<![\w])" + re.escape(t) + r"(?![\w])", re.IGNORECASE)) for t in terms]

    findings = 0
    for rel in list_files(sys.argv[1:]):
        if rel in SKIP_FILES:
            continue
        path = os.path.join(ROOT, rel)
        name_scrubbed = rel.lower()
        for a in allow:
            name_scrubbed = name_scrubbed.replace(a, " " * len(a))
        for t, rx in term_res:
            if rx.search(name_scrubbed):
                findings += 1
                print(f"{rel}: file name contains denylist term '{t}'")
        try:
            with open(path, encoding="utf-8") as fh:
                lines = fh.readlines()
        except (UnicodeDecodeError, OSError):
            continue
        for n, line in enumerate(lines, 1):
            scrubbed = line.lower()
            for a in allow:
                scrubbed = scrubbed.replace(a, " " * len(a))
            hits = []
            for t, rx in term_res:
                if rx.search(scrubbed):
                    hits.append(f"denylist term '{t}'")
            for label, rx in PATTERNS.items():
                for m in rx.finditer(line):
                    if label == "email address" and (m.group(0).lower() in SAFE_EMAILS or m.group(0).lower().endswith("@example.com")):
                        continue
                    hits.append(f"{label} '{m.group(0)}'")
            for h in hits:
                findings += 1
                print(f"{rel}:{n}: {h}")
    if findings:
        print(f"\nprivacy-scan: {findings} finding(s). Fix them, or add a genuinely generic phrase to scripts/privacy-allowlist.txt.", file=sys.stderr)
        return 1
    mode = "with denylist" if terms else "pattern checks only (SBK_DENYLIST not set)"
    print(f"privacy-scan: clean ({mode})")
    return 0


if __name__ == "__main__":
    sys.exit(main())
