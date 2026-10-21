---
name: handoff
description: Generate a self-contained handoff prompt for starting the next session with fresh context.
---

# Cross-Session Handoff Workflow

## Purpose
Produce a copy-pasteable bootstrap prompt that loads `session_checkpoint.md` and the specific files required for the next phase without carrying stale conversation history.

## Execution Steps
1. **Verify Checkpoint Freshness:** Confirm `session_checkpoint.md` reflects all work completed in the current session and passes `wc -l` (150 lines or fewer).
2. **Select Required Reading:** List only the specific files the next session must read before acting (always starting with `session_checkpoint.md`).
3. **Draft the Handoff Prompt:** Output a single fenced markdown code block containing:
   - **Context Statement:** Active project, completed phases, and current phase objective.
   - **Mandatory Reading List:** Specific relative paths to read in full before making edits.
   - **Scoped Tasks:** Numbered deliverables for the next session only.
   - **Scope Boundary:** Explicit instruction stating which directories are frozen and when to stop.
