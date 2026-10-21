---
name: tree-of-thought
description: Evaluate architectural decisions across three or more distinct candidate branches before implementation.
---

# Tree of Thought (ToT) Decision Protocol

## When to Invoke
Invoke this skill when choosing between competing architectures, data schemas, state-management strategies, or tool integrations where a single-path assumption risks a local optimum.

## Execution Steps
1. **Define the Decision Axis:** State the engineering problem and the hard constraints (latency, security, portability, maintenance cost) in two sentences.
2. **Generate Candidate Branches:** Formulate at least 3 genuinely distinct approaches (Branch A, Branch B, Branch C). Do not include strawman options.
3. **Evaluate Against Constraints:** Build a comparison table scoring each branch across:
   - **Primary Strength:** What the branch solves best.
   - **Failure Mode / Risk:** Where the branch breaks under load or edge cases.
   - **Verification Cost:** How the branch can be tested deterministically.
   - **Verdict:** `Reject` or `Selected` with a one-sentence justification.
4. **Record Selection:** Write the chosen branch and its rationale into the active plan file or `session_checkpoint.md` before writing implementation code.
