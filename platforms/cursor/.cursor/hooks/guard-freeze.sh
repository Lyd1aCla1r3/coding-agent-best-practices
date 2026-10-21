#!/usr/bin/env bash
# Deterministic freeze-path guard for Cursor (blocks via exit code 2).
# Protects published/ and archive/ from unapproved writes or shell modifications.

set -euo pipefail

TARGET=$(jq -r '[.command, .tool_input.file_path, .tool_input.command, .file_path] | map(select(. != null)) | join(" ")')

if [ -z "$TARGET" ]; then
  echo '{"permission":"allow"}'
exit 0
fi

FREEZE_PAT="(^|/)(published|archive)(/|$)"
if printf '%s\n' "$TARGET" |
   grep -qE "$FREEZE_PAT"; then
  echo '{"permission":"deny","user_message":"Blocked write to frozen path.","agent_message":"Frozen path protection triggered. Do not modify published/ or archive/."}'
  echo "BLOCKED [guard-freeze]: target touches a frozen path (published/ or archive/)." >&2
  exit 2
fi

echo '{"permission":"allow"}'
exit 0
