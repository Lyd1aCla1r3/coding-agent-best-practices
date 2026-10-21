---
trigger: always_on
description: "Planning gate, Devin Local /plan mode, and plan.sh protocol"
---

# Planning Gate and Approval Protocol

## When to Trigger the Planning Gate
- **Trigger Conditions:** Enter the planning gate before writing application code when a task modifies 3 or more files, alters shared interfaces, touches build pipelines, or introduces new dependencies.
- **Clarify Before Planning:** Ask focused clarifying questions to resolve underspecified requirements before drafting the plan.
- **Approval Boundary:** Present the structured plan (objective, affected files, verification commands, and rollback steps) and wait for explicit user approval (`"approved"` or `"proceed"`) before executing edits.

## Native Plan Mode Integration (Windsurf / Devin Desktop)
- **Mode Activation:** Run `/plan` in Devin Local CLI to restrict the agent to read-only exploration (`read`, `grep`, `glob`, `webfetch`) while drafting `~/.devin/plans/plan-<session>.md`.
- **Workspace Persistence:** Persist or generate the project-scoped plan in `.devin/plans/` using `bash scripts/plan.sh new <slug>` so plans travel with version control.
- **Doc Reference:** https://docs.devin.ai/desktop/devin-local
