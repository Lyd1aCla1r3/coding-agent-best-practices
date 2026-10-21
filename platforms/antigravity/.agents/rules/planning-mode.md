---
trigger: always_on
description: "Planning gate, Implementation Plan artifact review, and plan.sh protocol"
---

# Planning Gate and Approval Protocol

## When to Trigger the Planning Gate
- **Trigger Conditions:** Enter the planning gate before writing application code when a task modifies 3 or more files, alters shared interfaces, touches build pipelines, or introduces new dependencies.
- **Clarify Before Planning:** Ask focused clarifying questions to resolve underspecified requirements before drafting the plan.
- **Approval Boundary:** Present the structured plan (objective, affected files, verification commands, and rollback steps) and wait for explicit user approval (`"approved"` or `"proceed"`) before executing edits.

## Native Plan Mode Integration (Antigravity)
- **Mode Activation:** Select **Planning** mode in the conversation mode selector, invoke `/plan`, or set `agentMode` to `"plan"` and `artifactReviewPolicy` to `"asks-for-review"` in `settings.json`.
- **Implementation Plan Artifact:** Present the design in the Implementation Plan artifact and wait for the user to click **Proceed**, or mirror the plan in `.agents/plans/` via `bash scripts/plan.sh new <slug>`.
- **Doc Reference:** https://antigravity.google/docs/artifacts
