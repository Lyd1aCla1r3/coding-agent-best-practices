#!/usr/bin/env bash
# Deterministic secret-leak guard for Antigravity (.agents/hooks.json).
# Returns JSON {"decision": "deny"|"allow"} on stdout.

set -euo pipefail

PAYLOAD_TEXT=$(jq -r '[.toolCall.args.CodeContent, .toolCall.args.ReplacementContent, .toolCall.args.CommandLine, (.toolCall.args.ReplacementChunks // [] | map(.ReplacementContent) | join(" "))] | map(select(. != null)) | join(" ")')

SECRET_PAT="(sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----)"
if [ -n "$PAYLOAD_TEXT" ] &&
   printf '%s\n' "$PAYLOAD_TEXT" |
   grep -qE "$SECRET_PAT"; then
  echo '{"decision":"deny","reason":"BLOCKED [guard-secrets]: payload contains a secret token or private key header."}'
  exit 0
fi

echo '{"decision":"allow"}'
exit 0
