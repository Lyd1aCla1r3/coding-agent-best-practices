---
name: adversarial-self-audit
description: Red-team plans, code changes, and prose drafts against failure modes and style rules before delivery.
---

# Adversarial Self-Audit Protocol

## Purpose
Switch from author mindset to red-team reviewer mindset. Actively search for unverified assumptions, edge-case failures, security gaps, and style violations before presenting work as complete.

## Execution Steps
1. **Enumerate Attack Vectors:** Generate at least 5 concrete attacks against the current artifact (see `reference.md` for standard categories):
   - **Evidence Attack:** Which claims or numbers lack a recorded command output or primary doc URL?
   - **Boundary Attack:** What happens on empty input, malformed JSON, missing directories, or non-zero exit codes?
   - **Drift Attack:** Where do tailored files or documentation tables diverge from the tested implementation?
   - **Leakage Attack:** Do any files expose local home paths, secrets, or restricted terms?
   - **Style Attack:** Does prose pass `python3 scripts/lint_prose.py` with zero violations?
2. **Execute Deterministic Checks:** Run the project linter, test suite, and hook self-tests rather than inspecting files visually.
3. **Log Resolutions:** Record each identified defect and the concrete fix applied in the audit table.
