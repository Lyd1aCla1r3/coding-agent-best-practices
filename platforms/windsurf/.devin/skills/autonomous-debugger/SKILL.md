---
name: autonomous-debugger
description: Isolate and resolve test failures, hook errors, and build regressions through hypothesis-driven reproduction.
---

# Autonomous Debugging Protocol

## Purpose
Resolve defects systematically through minimal reproduction, hypothesis testing, and regression verification without speculative multi-file edits.

## Execution Steps
1. **Reproduce Deterministically:** Run the failing command or payload test and capture the exit code, stdout, and stderr before touching any code.
2. **Isolate the Fault Boundary:** Trace the data flow from input payload to failure point. Read the specific lines implicated by the stack trace or error output.
3. **Formulate Falsifiable Hypotheses:** List the top 2 to 3 possible root causes and design a read-only check or minimal probe to confirm which hypothesis holds.
4. **Apply Minimal Fix:** Modify only the faulty logic. Do not bundle unrelated refactoring with a bug fix.
5. **Verify Non-Regression:** Re-run the failing reproduction case plus the full verification suite (`allow` and `deny` cases) and record the passing output.
