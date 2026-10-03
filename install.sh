#!/bin/bash
# second-brain-kit installer: copies the framework into a vault folder.
# Safe to re-run to update: kit-managed files are refreshed; your notes, PERSONAL.md,
# templates and dashboards you've edited are never overwritten, and nothing is deleted.
#
# Usage:
#   ./install.sh                                   # interactive
#   ./install.sh --vault "/path/to/vault" --packs meetings,memory-backup --yes
set -euo pipefail

KIT="$(cd "$(dirname "$0")" && pwd)"
VAULT=""; PACKS=""; PACKS_SET=0; YES=0
ALL_PACKS="meetings memory-backup"

need() { [ $# -ge 2 ] && [ -n "${2:-}" ] || { echo "$1 needs a value" >&2; exit 2; }; }
while [ $# -gt 0 ]; do
  case "$1" in
    --vault) need "$@"; VAULT="$2"; shift 2 ;;
    --packs) [ $# -ge 2 ] || { echo "--packs needs a value (use \"\" for none)" >&2; exit 2; }
             PACKS="$(echo "$2" | tr ',' ' ')"; PACKS_SET=1; shift 2 ;;
    --yes|-y) YES=1; shift ;;
    -h|--help) sed -n '2,9p' "$0"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; exit 2 ;;
  esac
done

ask() { # ask "question" "default" -> echoes answer
  local reply
  if [ "$YES" -eq 1 ]; then echo "$2"; return; fi
  read -r -p "$1 [$2]: " reply </dev/tty || true
  echo "${reply:-$2}"
}

# 1. Where the vault goes. Default: a new folder in Google Drive if it is installed.
if [ -z "$VAULT" ]; then
  [ "$YES" -eq 1 ] && { echo "--yes needs an explicit --vault path" >&2; exit 2; }
  BASE="$HOME"
  for d in "$HOME"/Library/CloudStorage/GoogleDrive-*/"My Drive"; do
    [ -d "$d" ] && BASE="$d" && break
  done
  DEFAULT="$BASE/secondbrain"; n=2
  while [ -e "$DEFAULT" ]; do DEFAULT="$BASE/secondbrain-$n"; n=$((n + 1)); done
  echo "Where should the vault live? Google Drive, iCloud Drive, Dropbox or a local folder all work."
  VAULT="$(ask "Vault folder" "$DEFAULT")"
fi
VAULT="${VAULT/#\~/$HOME}"
VAULT="${VAULT%/}"
case "$VAULT" in /*) ;; *) VAULT="$(pwd)/$VAULT" ;; esac

# 2. Which packs.
if [ "$PACKS_SET" -eq 0 ]; then
  for p in $ALL_PACKS; do
    desc="$(cat "$KIT/packs/$p/DESCRIPTION")"
    a="$(ask "Install the $p pack? ($desc) y/n" "n")"
    case "$a" in y|Y|yes) PACKS="$PACKS $p" ;; esac
  done
fi
for p in $PACKS; do
  [ -d "$KIT/packs/$p" ] || { echo "Unknown pack: $p (available: $ALL_PACKS)" >&2; exit 2; }
done

echo
echo "Installing second-brain-kit $(cat "$KIT/kit/VERSION") into: $VAULT"
[ -n "${PACKS// /}" ] && echo "Packs:$PACKS"
EXISTING=0
for f in CLAUDE.md AGENTS.md; do
  if [ -e "$VAULT/$f" ] && ! grep -q "second-brain-kit" "$VAULT/$f"; then
    echo "  Warning: $f already exists here and isn't from the kit. It will be backed up to 06_Meta/Logs/ and replaced."
    EXISTING=1
  fi
done
if [ -d "$VAULT/01_Projects" ] && [ ! -d "$VAULT/06_Meta/Kit" ]; then
  echo "  Warning: this looks like an existing vault that wasn't set up with the kit."
  EXISTING=1
fi
if [ "$EXISTING" -eq 1 ] && [ "$YES" -eq 1 ]; then
  echo "Refusing to modify an existing vault non-interactively. Re-run without --yes to confirm." >&2; exit 1
fi
if [ "$YES" -eq 0 ]; then
  a="$(ask "Continue? y/n" "y")"; case "$a" in y|Y|yes) ;; *) echo "Cancelled."; exit 0 ;; esac
fi
[ -d "$VAULT/.git" ] && echo "Note: this folder is a Git repository. A vault is a knowledge base, not a code project; that's fine, but the kit doesn't need Git."

STAMP="$(date +%Y-%m-%d-%H%M)"
copy_if_absent() { # src dest
  if [ -e "$2" ]; then echo "  kept     ${2#$VAULT/} (already exists)"; else cp "$1" "$2"; echo "  added    ${2#$VAULT/}"; fi
}
refresh() { # src dest (kit-managed)
  if [ -e "$2" ] && cmp -s "$1" "$2"; then return; fi
  if [ -e "$2" ]; then cp "$1" "$2"; echo "  updated  ${2#$VAULT/}"; else cp "$1" "$2"; echo "  added    ${2#$VAULT/}"; fi
}

# 3. PARA folders (top level only; subfolders appear when a file needs them).
for d in 00_Inbox 01_Projects 02_Areas 03_Resources 04_Archive 05_Attachments 06_Meta/Kit 06_Meta/Templates 06_Meta/Dashboards; do
  mkdir -p "$VAULT/$d"
done

# 4. Framework rules and version (kit-managed).
refresh "$KIT/kit/RULES.md" "$VAULT/06_Meta/Kit/RULES.md"
refresh "$KIT/kit/VERSION" "$VAULT/06_Meta/Kit/VERSION"

# 5. Loaders at the vault root. Back up any existing non-kit file first.
for f in CLAUDE.md AGENTS.md; do
  dest="$VAULT/$f"
  if [ -e "$dest" ] && ! grep -q "second-brain-kit" "$dest"; then
    mkdir -p "$VAULT/06_Meta/Logs"
    cp "$dest" "$VAULT/06_Meta/Logs/$STAMP-$f.bak"
    echo "  saved    06_Meta/Logs/$STAMP-$f.bak (your previous $f; move anything you want to keep into PERSONAL.md)"
  fi
  refresh "$KIT/loaders/$f" "$dest"
done
copy_if_absent "$KIT/personal/PERSONAL.md" "$VAULT/PERSONAL.md"

# 6. Templates and dashboards (yours once installed; never overwritten).
for t in "$KIT"/templates/*.md; do copy_if_absent "$t" "$VAULT/06_Meta/Templates/$(basename "$t")"; done
for b in "$KIT"/dashboards/*.base; do copy_if_absent "$b" "$VAULT/06_Meta/Dashboards/$(basename "$b")"; done

# 7. Skills (kit-managed), for Claude Code and Codex.
install_skill() { # skill dir
  local name; name="$(basename "$1")"
  mkdir -p "$VAULT/.claude/skills/$name"
  refresh "$1/SKILL.md" "$VAULT/.claude/skills/$name/SKILL.md"
}
for s in "$KIT"/skills/*/; do install_skill "${s%/}"; done

# 8. Packs.
touch "$VAULT/06_Meta/Kit/installed-packs.txt"
for p in $PACKS; do
  P="$KIT/packs/$p"; D="$VAULT/06_Meta/Kit/packs/$p"; mkdir -p "$D"
  for f in "$P"/*; do [ -f "$f" ] && refresh "$f" "$D/$(basename "$f")"; done
  [ -d "$P/skills" ] && for s in "$P"/skills/*/; do install_skill "${s%/}"; done
  [ -d "$P/templates" ] && for t in "$P"/templates/*.md; do copy_if_absent "$t" "$VAULT/06_Meta/Templates/$(basename "$t")"; done
  [ -d "$P/dashboards" ] && for b in "$P"/dashboards/*.base; do copy_if_absent "$b" "$VAULT/06_Meta/Dashboards/$(basename "$b")"; done
  grep -qx "$p" "$VAULT/06_Meta/Kit/installed-packs.txt" || echo "$p" >> "$VAULT/06_Meta/Kit/installed-packs.txt"
done
chmod +x "$VAULT"/06_Meta/Kit/packs/*/*.sh 2>/dev/null || true

# 9. Mirror skills for Codex and other agents (.claude/skills is canonical).
mkdir -p "$VAULT/.agents/skills"
rsync -a "$VAULT/.claude/skills/" "$VAULT/.agents/skills/"

# 10. Recommended Obsidian settings, only for a brand-new vault.
if [ ! -d "$VAULT/.obsidian" ]; then
  mkdir -p "$VAULT/.obsidian"
  cp "$KIT"/obsidian/*.json "$VAULT/.obsidian/"
  echo "  added    .obsidian/ (recommended settings)"
fi

echo
echo "Done. Next:"
echo "  1. Open the folder in Obsidian: Open folder as vault -> $VAULT"
echo "  2. Start Claude Code or Codex in that folder and paste the prompt from:"
echo "     $KIT/SETUP-PROMPT.md"
echo "     (it interviews you and builds your areas and projects)."
