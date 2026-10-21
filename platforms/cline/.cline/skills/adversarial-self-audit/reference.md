# Adversarial Self-Audit Reference Checklist

## 1. Evidence and Ground-Truth Checks
- Every CLI flag, configuration key, and hook event name traces to a primary vendor documentation URL.
- Every numerical metric in prose traces to a measurement script output.

## 2. Hook and Script Safety Checks
- Shell scripts set `set -euo pipefail`.
- Security guards fail closed when inputs are missing or unparseable.
- Each guard has at least one recorded allow case and one recorded deny case.

## 3. Privacy and Hygiene Checks
- Zero occurrences of local home directory paths (`/Users/<username>` or `/home/<username>`).
- Zero occurrences of restricted terms listed in `.style-denylist.txt`.
- Zero plaintext credentials or private key headers in tracked files.
- Prose follows the project writing conventions in the `writing-style` rule.
