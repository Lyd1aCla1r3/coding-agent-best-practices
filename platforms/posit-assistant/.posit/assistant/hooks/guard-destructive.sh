#!/usr/bin/env bash
# Deterministic destructive-command guard for Posit Assistant (blocks via exit code 2).
# Rejects recursive force-deletes, hard resets, force pushes, and schema drops.

set -euo pipefail

CMD=$(jq -r '.tool_input.command // empty')

if [ -z "$CMD" ]; then
  exit 0
fi

DESTRUCTIVE_PAT="(rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f|rm[[:space:]]+-[a-zA-Z]*f[a-zA-Z]*r|git[[:space:]]+reset[[:space:]]+--hard|git[[:space:]]+push[[:space:]]+(--force|-f)|git[[:space:]]+clean[[:space:]]+-[a-zA-Z]*f|DROP[[:space:]]+TABLE)"
if printf '%s\n' "$CMD" |
   grep -qE "$DESTRUCTIVE_PAT"; then
  echo "BLOCKED [guard-destructive]: destructive command pattern detected." >&2
  exit 2
fi

exit 0
