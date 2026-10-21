---
name: checkpoint
description: Save a structured session checkpoint capturing accomplished work, verified state, and next steps.
---

# Session Checkpoint Workflow

## Purpose
Persist verified session state into `session_checkpoint.md` (capped at 150 lines) and archive a timestamped copy in `checkpoints/` so subsequent sessions start from ground truth.

## Execution Steps
1. **Audit Current State:** Run `git status -s` and list all files created, modified, or verified during the current session.
2. **Archive Full Snapshot:** Write a detailed session log to `checkpoints/checkpoint_YYYY-MM-DD_<phase>.md` containing full command outputs, architectural rationale, and resolved questions.
3. **Update Rolling Checkpoint:** Overwrite `session_checkpoint.md` in the project root with four concise sections:
   - `## Project & Scope`: Target deliverables, active phase, and restore-point commit SHA.
   - `## Constraints & Decisions`: Non-negotiable rules, frozen paths, and confirmed design choices.
   - `## Accomplished & Verified`: Completed deliverables and the commands that verified them.
   - `## Next Phase Tasks`: Ordered, actionable checklist for the next session.
4. **Enforce Line Cap:** Run `wc -l session_checkpoint.md` and confirm the file is 150 lines or fewer. Move verbose tables or logs into the archived snapshot under `checkpoints/`.
