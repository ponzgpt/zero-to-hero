#!/usr/bin/env bash
# The one runnable check: if zth check or zth drift stops being right, this fails.
#   ./tests/run.sh
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ZTH="$ROOT/bin/zth"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass=0; fail=0

assert() { # assert <desc> <expected-exit> <cmd...>
  local desc="$1" want="$2"; shift 2
  local out; out="$("$@" 2>&1)"; local got=$?
  if [ "$got" -eq "$want" ]; then pass=$((pass+1)); printf '  ok   %s\n' "$desc"
  else fail=$((fail+1)); printf '  FAIL %s (exit %s, wanted %s)\n%s\n' "$desc" "$got" "$want" "$out"; fi
}

assert_says() { # assert_says <desc> <substring> <cmd...>
  local desc="$1" want="$2"; shift 2
  local out; out="$("$@" 2>&1)"
  if grep -q "$want" <<<"$out"; then pass=$((pass+1)); printf '  ok   %s\n' "$desc"
  else fail=$((fail+1)); printf '  FAIL %s (output lacked %q)\n%s\n' "$desc" "$want" "$out"; fi
}

# A valid SOP, parameterised by verified-on date and an optional extra frontmatter line.
sop() { # sop <file> <date> [extra]
  cat > "$1" <<EOF
---
zth: 1
title: Do the thing
goal: From nothing to the thing being done.
done_when:
  - "the thing is done"
route: The short way
verified:
  on: $2
  by: tester
  env: fixture
recheck_every: 90d
${3:-}
---

## Context
For someone with a shell.

## The path
1. Do it.

## Traps
### it did not work
**Cause.** Reasons. **Escape.** Do it again.

## Routes not taken
- **The long way** — more steps, same blast radius.

## Keep fresh
- The version pin.
EOF
}

echo "zth self-check"

# --- install ---------------------------------------------------------------
REPO="$TMP/repo"; mkdir -p "$REPO/sops"
assert "install lays down .zth"            0 "$ZTH" install "$REPO"
assert "installed payload has the method"  0 test -f "$REPO/.zth/method.md"
assert "installed copy is runnable"        0 test -x "$REPO/.zth/bin/zth"
assert "update is idempotent"              0 "$ZTH" update "$REPO"
assert "install seeds AGENTS.md"           0 test -f "$REPO/AGENTS.md"
assert "install places the claude skill"   0 test -f "$REPO/.claude/skills/zero-to-hero/SKILL.md"
assert "install seeds the drift workflow"  0 test -f "$REPO/.github/workflows/drift.yml"
echo "hand-written" > "$REPO/AGENTS.md"
assert      "update keeps a custom AGENTS.md"  0 "$ZTH" update "$REPO"
assert_says "...and says how to wire it"       "add a line pointing agents" "$ZTH" update "$REPO"
assert "custom AGENTS.md survived"         0 grep -qx "hand-written" "$REPO/AGENTS.md"

# --- check -----------------------------------------------------------------
sop "$REPO/sops/good.md" "$(date +%Y-%m-%d)"
assert "valid SOP passes check"            0 "$ZTH" check "$REPO"
assert "installed zth checks too"          0 "$REPO/.zth/bin/zth" check "$REPO"

cp "$REPO/sops/good.md" "$TMP/good.bak"

grep -v '^route:' "$TMP/good.bak" > "$REPO/sops/good.md"
assert "missing frontmatter key fails"     1 "$ZTH" check "$REPO"

sed 's/^  env:.*//' "$TMP/good.bak" > "$REPO/sops/good.md"
assert "missing verified.env fails"        1 "$ZTH" check "$REPO"

sed 's/^  on: .*/  on: 17-09-2026/' "$TMP/good.bak" > "$REPO/sops/good.md"
assert "malformed verified.on fails"       1 "$ZTH" check "$REPO"

sed 's/^recheck_every: .*/recheck_every: 3 months/' "$TMP/good.bak" > "$REPO/sops/good.md"
assert "malformed recheck_every fails"     1 "$ZTH" check "$REPO"

grep -v '^## Traps$' "$TMP/good.bak" > "$REPO/sops/good.md"
assert "missing section fails"             1 "$ZTH" check "$REPO"

# Swap two headings: all five are present, only the order is wrong.
sed -e 's/^## Traps$/##__SWAP/' -e 's/^## Routes not taken$/## Traps/' \
    -e 's/^##__SWAP$/## Routes not taken/' "$TMP/good.bak" > "$REPO/sops/good.md"
assert      "sections out of order fail"   1 "$ZTH" check "$REPO"
assert_says "...and say so"                "out of order" "$ZTH" check "$REPO"

printf 'no frontmatter here\n' > "$REPO/sops/good.md"
assert "file without frontmatter fails"    1 "$ZTH" check "$REPO"

cp "$TMP/good.bak" "$REPO/sops/good.md"
assert "restored SOP passes again"         0 "$ZTH" check "$REPO"

# --- drift -----------------------------------------------------------------
assert "freshly verified SOP is fresh"     0 "$ZTH" drift "$REPO"

# 90d window, verified 200 days ago -> stale.
OLD="$(date -v-200d +%Y-%m-%d 2>/dev/null || date -d '200 days ago' +%Y-%m-%d)"
sop "$REPO/sops/good.md" "$OLD"
assert "SOP past recheck_every is stale"   1 "$ZTH" drift "$REPO"

# Inside the window but within 14 days of expiry -> due, still exit 0.
SOON="$(date -v-80d +%Y-%m-%d 2>/dev/null || date -d '80 days ago' +%Y-%m-%d)"
sop "$REPO/sops/good.md" "$SOON"
assert "SOP near expiry warns, not fails"  0 "$ZTH" drift "$REPO"

# A draft has not been executed, so it is not on the clock yet.
sop "$REPO/sops/good.md" "$OLD" "status: draft"
assert "draft is exempt from drift"        0 "$ZTH" drift "$REPO"

# --- new -------------------------------------------------------------------
assert "new scaffolds a satellite"         0 "$ZTH" new "$TMP/sat"
assert "satellite carries the method"      0 test -f "$TMP/sat/.zth/method.md"
assert "unfilled template fails check"     1 "$ZTH" check "$TMP/sat"
assert "new refuses to clobber"            1 "$ZTH" new "$TMP/sat"
# The suggested repo name must come from the dir name, never the path.
assert_says "new names the repo from the dir"  "gh repo create zero-to-hero-sat2" "$ZTH" new "$TMP/sat2"
assert_says "new does not double the prefix"   "gh repo create zero-to-hero-omarchy " "$ZTH" new "$TMP/zero-to-hero-omarchy"

echo
printf '%s passed, %s failed\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
