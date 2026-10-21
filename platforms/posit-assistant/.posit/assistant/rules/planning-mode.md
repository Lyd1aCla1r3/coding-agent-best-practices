# Planning Gate and Approval Protocol

## When to Trigger the Planning Gate
- **Trigger Conditions:** Enter the planning gate before writing application code when a task modifies 3 or more files, alters shared interfaces, touches build pipelines, or introduces new dependencies.
- **Clarify Before Planning:** Ask focused clarifying questions to resolve underspecified requirements before drafting the plan.
- **Approval Boundary:** Present the structured plan (objective, affected files, verification commands, and rollback steps) and wait for explicit user approval (`"approved"` or `"proceed"`) before executing edits.

## Native Plan Mode Integration (Posit Assistant)
- **Mode Activation:** Invoke `/plan` in the Posit Assistant chat box to enter read-only planning mode.
- **Workspace Persistence:** Keep `.posit/assistant/plans/` present in the repository (created automatically by `bash scripts/plan.sh new <slug>`) so `/plan` writes durable markdown plans to the project rather than ephemeral session storage.
- **Doc Reference:** https://assistant.posit.co/docs/features/plan-mode/
