#!/usr/bin/env bash
# Deterministic network-safety guard for Cursor (blocks via exit code 2).
# Blocks curl/wget pipe-to-shell execution, netcat listeners, and credential uploads.

set -euo pipefail

CMD=$(jq -r '[.command, .tool_input.command] | map(select(. != null)) | join(" ")')

if [ -z "$CMD" ]; then
  echo '{"permission":"allow"}'
exit 0
fi

NETWORK_PAT="((curl|wget)[[:space:]].*\|[[:space:]]*(ba)?sh|nc[[:space:]]+-l|curl[[:space:]].*(-d|--data|--upload-file)[[:space:]]*@?.*(\.env|id_rsa|credentials))"
if printf '%s\n' "$CMD" |
   grep -qE "$NETWORK_PAT"; then
  echo '{"permission":"deny","user_message":"Blocked untrusted network command.","agent_message":"Remote pipe-to-shell or exfiltration command blocked by guard-network.sh."}'
  echo "BLOCKED [guard-network]: untrusted network execution or exfiltration pattern detected." >&2
  exit 2
fi

echo '{"permission":"allow"}'
exit 0
