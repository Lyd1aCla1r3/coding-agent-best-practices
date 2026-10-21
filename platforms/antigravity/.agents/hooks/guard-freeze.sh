#!/usr/bin/env bash
# Deterministic freeze-path guard for Antigravity (.agents/hooks.json).
# Antigravity PreToolUse hooks return JSON {"decision": "deny"|"allow", "reason": "..."} on stdout (exit 0).

set -euo pipefail

TARGET=$(jq -r '[.toolCall.args.TargetFile, .toolCall.args.CommandLine] | map(select(. != null)) | join(" ")')

if [ -n "$TARGET" ] &&
   printf '%s\n' "$TARGET" |
   grep -qE "(^|/)(published|archive)(/|$)"; then
  echo '{"decision":"deny","reason":"BLOCKED [guard-freeze]: target touches a frozen path (published/ or archive/)."}'
  exit 0
fi

echo '{"decision":"allow"}'
exit 0
