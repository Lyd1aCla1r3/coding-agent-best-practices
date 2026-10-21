# Session Checkpoint

## Project & Scope
- **Project:** <project-name>
- **Active Phase:** Phase 1 (Initial Implementation)
- **Restore Point SHA:** <record git rev-parse HEAD before integration edits>
- **Frozen Paths:** `published/`, `archive/` (configured in `.freeze-paths.txt`)

## Constraints & Decisions
- **Verification Policy:** Every quantitative metric traces to a command output; every platform claim cites an official vendor documentation URL.
- **Style Policy:** Prose follows the `writing-style` rule, and `python3 scripts/lint_prose.py` reports zero violations.
- **Selected Architecture:** <summarize chosen Tree of Thought branch and rationale>

## Accomplished & Verified
- [x] Initialized configuration layout, rules, skills, subagents, and deterministic hooks.
- [x] Verified hook guards against synthetic allow and deny payloads.

## Next Phase Tasks
1. Read `session_checkpoint.md` and the active plan in full before editing.
2. Execute the next scoped deliverable and verify with `python3 scripts/lint_prose.py`.
3. Run the `checkpoint` and `handoff` skills before closing the session.
