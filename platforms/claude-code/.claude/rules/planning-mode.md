# Planning Gate and Approval Protocol

## When to Trigger the Planning Gate
- **Trigger Conditions:** Enter the planning gate before writing application code when a task modifies 3 or more files, alters shared interfaces, touches build pipelines, or introduces new dependencies.
- **Clarify Before Planning:** Ask focused clarifying questions to resolve underspecified requirements before drafting the plan.
- **Approval Boundary:** Present the structured plan (objective, affected files, verification commands, and rollback steps) and wait for explicit user approval (`"approved"` or `"proceed"`) before executing edits.

## Native Plan Mode Integration (Claude Code)
- **Mode Activation:** Start complex sessions in native Plan mode (`Shift+Tab`, `/plan`, or `claude --permission-mode plan`), or set `permissions.defaultMode` to `"plan"` in `.claude/settings.json`.
- **Durable Plan File:** Pair native Plan mode with `bash scripts/plan.sh new <slug>` so the approved plan persists in `.claude/plans/` across sessions.
- **Doc Reference:** https://code.claude.com/docs/en/permission-modes
