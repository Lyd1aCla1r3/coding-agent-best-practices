#!/usr/bin/env bash
# Deterministic freeze-path guard for Posit Assistant (blocks via exit code 2).
# Protects published/ and archive/ from unapproved writes or shell modifications.

set -euo pipefail

TARGET=$(jq -r '[.tool_input.file_path, .tool_input.command] | map(select(. != null)) | join(" ")')

if [ -z "$TARGET" ]; then
  exit 0
fi

FREEZE_PAT="(^|/)(published|archive)(/|$)"
if printf '%s\n' "$TARGET" |
   grep -qE "$FREEZE_PAT"; then
  echo "BLOCKED [guard-freeze]: target touches a frozen path (published/ or archive/)." >&2
  exit 2
fi

exit 0
