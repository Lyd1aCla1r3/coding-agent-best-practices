#!/usr/bin/env bash
# Deterministic secret-leak guard for Cursor (blocks via exit code 2).
# Scans file write/edit payloads and shell commands for API keys and private key headers.

set -euo pipefail

PAYLOAD_TEXT=$(jq -r '[.command, .tool_input.content, .tool_input.new_string, .tool_input.command] | map(select(. != null)) | join(" ")')

if [ -z "$PAYLOAD_TEXT" ]; then
  echo '{"permission":"allow"}'
exit 0
fi

SECRET_PAT="(sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----)"
if printf '%s\n' "$PAYLOAD_TEXT" |
   grep -qE "$SECRET_PAT"; then
  echo '{"permission":"deny","user_message":"Blocked secret or private key write.","agent_message":"High-confidence API key or private key blocked by guard-secrets.sh."}'
  echo "BLOCKED [guard-secrets]: payload contains a secret token or private key header." >&2
  exit 2
fi

echo '{"permission":"allow"}'
exit 0
