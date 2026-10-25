#!/bin/bash
# second-brain-kit: rebuild AGENTS.md and keep the two skill folders identical.
#
# AGENTS.md is the one rules file every agent loads: Codex reads it directly, and Claude Code
# reads it through the one-line CLAUDE.md loader. It is generated from 06_Meta/Kit/RULES.md,
# the RULES.md of each installed pack, and PERSONAL.md (last, so it wins). Edit those, never
# AGENTS.md.
#
# Skills live in .claude/skills (Claude Code) and .agents/skills (Codex), because neither tool
# reads the other's folder. For each file that differs, the newer copy replaces the older one,
# and the older one is saved to 06_Meta/Logs/skill-backups/ first. Nothing is deleted: a skill
# removed from one folder is copied back from the other, so remove it from both.
#
# Runs from the installer, from optional agent hooks after every reply (docs/guide.md), and by hand:
#   bash 06_Meta/Kit/agent-sync.sh [vault path]     (default: the vault this script sits in)
set -u

VAULT="${1:-$(cd "$(dirname "$0")/../.." && pwd)}"
VAULT="${VAULT%/}"
KITDIR="$VAULT/06_Meta/Kit"
RULES="$KITDIR/RULES.md"
OUT="$VAULT/AGENTS.md"
LAST="$KITDIR/agents-md.cksum"   # checksum of the last AGENTS.md this script wrote
OLD_POINTER="549830258 976"      # checksum of the v0.1.0 AGENTS.md pointer, replaced without a backup
STAMP="$(date +%Y-%m-%d-%H%M%S)"
STATUS=0

[ -d "$KITDIR" ] || { echo "Not a second-brain-kit vault (no 06_Meta/Kit): $VAULT" >&2; exit 1; }

# One run at a time: hooks in two agents can fire together. Wait briefly, then give up quietly;
# the next run catches up. A lock left by a crashed run is cleared after ten minutes.
# The lock and the scratch file live outside the vault, so a run that changes nothing never
# touches the synced folder.
LOCK="${TMPDIR:-/tmp}/sbk-agent-sync-$(printf '%s' "$VAULT" | cksum | cut -d' ' -f1).lock"
tries=0
until mkdir "$LOCK" 2>/dev/null; do
  if [ -n "$(find "$LOCK" -maxdepth 0 -mmin +10 2>/dev/null)" ]; then rmdir "$LOCK" 2>/dev/null; continue; fi
  tries=$((tries + 1))
  [ "$tries" -ge 10 ] && exit 0
  sleep 1
done
TMP=""; NEW=""
trap 'rmdir "$LOCK" 2>/dev/null; [ -n "$TMP" ] && rm -f "$TMP"; [ -n "$NEW" ] && rm -f "$NEW"' EXIT

# 1. AGENTS.md
if [ ! -s "$RULES" ]; then
  echo "No framework rules at 06_Meta/Kit/RULES.md; AGENTS.md left as it is." >&2
  STATUS=1
else
  TMP="$(mktemp "${TMPDIR:-/tmp}/sbk-agents.XXXXXX")" || exit 1
  {
    echo "<!-- second-brain-kit: generated from 06_Meta/Kit/RULES.md, pack rules and PERSONAL.md. Do not edit. Edit PERSONAL.md, then run: bash 06_Meta/Kit/agent-sync.sh -->"
    echo
    echo "# Vault instructions"
    echo
    echo "These are the rules for every AI agent working in this vault. Codex loads this file directly; Claude Code loads it through \`CLAUDE.md\`. It is assembled from the framework rules, the rules of each installed pack, and the owner's \`PERSONAL.md\`, which comes last and wins where they disagree. **Never edit this file**, because it is rebuilt from those sources: to change a rule, edit \`PERSONAL.md\` and run \`bash 06_Meta/Kit/agent-sync.sh\`."
    echo
    echo "---"
    echo
    cat "$RULES"
    if [ -f "$KITDIR/installed-packs.txt" ]; then
      while IFS= read -r p || [ -n "$p" ]; do
        p="$(printf '%s' "$p" | tr -d '\r' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
        [ -n "$p" ] || continue
        if [ ! -f "$KITDIR/packs/$p/RULES.md" ]; then
          echo "Pack \"$p\" is listed in installed-packs.txt but its rules are missing; re-run the installer." >&2
          continue
        fi
        echo; echo "---"; echo
        cat "$KITDIR/packs/$p/RULES.md"
      done < "$KITDIR/installed-packs.txt"
    fi
    if [ -f "$VAULT/PERSONAL.md" ]; then
      echo; echo "---"; echo
      echo "<!-- From PERSONAL.md. These rules win where they disagree with anything above. -->"
      echo
      cat "$VAULT/PERSONAL.md"
    fi
  } > "$TMP" || { echo "Could not write $TMP" >&2; exit 1; }

  if [ -f "$OUT" ] && cmp -s "$TMP" "$OUT"; then
    rm -f "$TMP"
  else
    # Never lose an AGENTS.md this script didn't write (a hand edit, or one from before the kit).
    if [ -f "$OUT" ]; then
      CUR="$(cksum < "$OUT")"
      if [ "$CUR" != "$(cat "$LAST" 2>/dev/null)" ] && [ "$CUR" != "$OLD_POINTER" ]; then
        mkdir -p "$VAULT/06_Meta/Logs"
        BAK="06_Meta/Logs/$STAMP-AGENTS.md.bak"
        cp -p "$OUT" "$VAULT/$BAK"
        echo "Saved the previous AGENTS.md to $BAK: it wasn't written by this script (a hand edit, or a file from before the kit). Move anything worth keeping into PERSONAL.md." >&2
      fi
    fi
    # Stage next to the target and rename, so no reader ever sees a half-written AGENTS.md.
    NEW="$VAULT/.AGENTS.md.new.$$"
    if cp "$TMP" "$NEW" && mv -f "$NEW" "$OUT"; then
      NEW=""
      cksum < "$OUT" > "$LAST"
      echo "AGENTS.md rebuilt."
    else
      echo "Could not replace AGENTS.md." >&2
      STATUS=1
    fi
    rm -f "$TMP"
  fi
  TMP=""

  SIZE=$(wc -c < "$OUT" | tr -d ' ')
  if [ "$SIZE" -gt 32768 ]; then
    echo "Warning: AGENTS.md is $SIZE bytes. Codex stops reading at 32 KB unless project_doc_max_bytes is raised in ~/.codex/config.toml (see docs/guide.md); shorten PERSONAL.md or raise the limit." >&2
  fi
fi

# 2. Skills: for each file that differs, the newer copy wins and the older is backed up first.
A="$VAULT/.claude/skills"
B="$VAULT/.agents/skills"
backup_skill() { # side relpath
  local dest="$VAULT/06_Meta/Logs/skill-backups/$STAMP/$1/$2"
  mkdir -p "$(dirname "$dest")" && cp -p "$3" "$dest"
}
if [ -d "$A" ] || [ -d "$B" ]; then
  mkdir -p "$A" "$B"
  while IFS= read -r f; do
    f="${f#./}"
    a="$A/$f"; b="$B/$f"
    if [ ! -e "$a" ]; then mkdir -p "$(dirname "$a")"; cp -p "$b" "$a"; continue; fi
    if [ ! -e "$b" ]; then mkdir -p "$(dirname "$b")"; cp -p "$a" "$b"; continue; fi
    cmp -s "$a" "$b" && continue
    if [ "$a" -nt "$b" ]; then
      backup_skill .agents/skills "$f" "$b" && cp -p "$a" "$b"
    elif [ "$b" -nt "$a" ]; then
      backup_skill .claude/skills "$f" "$a" && cp -p "$b" "$a"
    else
      echo "Skill file differs between the folders with the same timestamp, left as it is: $f" >&2
      STATUS=1
    fi
  done < <( { (cd "$A" && find . -type f ! -name .DS_Store); (cd "$B" && find . -type f ! -name .DS_Store); } | sort -u )
fi

exit $STATUS
