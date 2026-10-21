#!/usr/bin/env bash
# Deterministic network-safety guard for Posit Assistant (blocks via exit code 2).
# Blocks curl/wget pipe-to-shell execution, netcat listeners, and credential uploads.

set -euo pipefail

CMD=$(jq -r '.tool_input.command // empty')

if [ -z "$CMD" ]; then
  exit 0
fi

NETWORK_PAT="((curl|wget)[[:space:]].*\|[[:space:]]*(ba)?sh|nc[[:space:]]+-l|curl[[:space:]].*(-d|--data|--upload-file)[[:space:]]*@?.*(\.env|id_rsa|credentials))"
if printf '%s\n' "$CMD" |
   grep -qE "$NETWORK_PAT"; then
  echo "BLOCKED [guard-network]: untrusted network execution or exfiltration pattern detected." >&2
  exit 2
fi

exit 0
