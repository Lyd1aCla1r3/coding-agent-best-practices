#!/usr/bin/env bash
# Deterministic destructive-command guard for Antigravity (.agents/hooks.json).
# Returns JSON {"decision": "deny"|"allow"} on stdout.

set -euo pipefail

CMD=$(jq -r '.toolCall.args.CommandLine // empty')

DESTRUCTIVE_PAT="(rm[[:space:]]+-[a-zA-Z]*r[a-zA-Z]*f|rm[[:space:]]+-[a-zA-Z]*f[a-zA-Z]*r|git[[:space:]]+reset[[:space:]]+--hard|git[[:space:]]+push[[:space:]]+(--force|-f)|git[[:space:]]+clean[[:space:]]+-[a-zA-Z]*f|DROP[[:space:]]+TABLE)"
if [ -n "$CMD" ] &&
   printf '%s\n' "$CMD" |
   grep -qE "$DESTRUCTIVE_PAT"; then
  echo '{"decision":"deny","reason":"BLOCKED [guard-destructive]: destructive shell command detected."}'
  exit 0
fi

echo '{"decision":"allow"}'
exit 0
