#!/usr/bin/env bash
# Deterministic network-safety guard for Antigravity (.agents/hooks.json).
# Returns JSON {"decision": "deny"|"allow"} on stdout.

set -euo pipefail

CMD=$(jq -r '.toolCall.args.CommandLine // empty')

NETWORK_PAT="((curl|wget)[[:space:]].*\|[[:space:]]*(ba)?sh|nc[[:space:]]+-l|curl[[:space:]].*(-d|--data|--upload-file)[[:space:]]*@?.*(\.env|id_rsa|credentials))"
if [ -n "$CMD" ] &&
   printf '%s\n' "$CMD" |
   grep -qE "$NETWORK_PAT"; then
  echo '{"decision":"deny","reason":"BLOCKED [guard-network]: untrusted network execution or exfiltration pattern detected."}'
  exit 0
fi

echo '{"decision":"allow"}'
exit 0
