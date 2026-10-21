# Planning Gate and Approval Protocol

## When to Trigger the Planning Gate
- **Trigger Conditions:** Enter the planning gate before writing application code when a task modifies 3 or more files, alters shared interfaces, touches build pipelines, or introduces new dependencies.
- **Clarify Before Planning:** Ask focused clarifying questions to resolve underspecified requirements before drafting the plan.
- **Approval Boundary:** Present the structured plan (objective, affected files, verification commands, and rollback steps) and wait for explicit user approval (`"approved"` or `"proceed"`) before executing edits.
