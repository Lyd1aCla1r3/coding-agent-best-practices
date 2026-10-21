---
trigger: always_on
description: "Ground-truth verification and primary-source citation rules"
---

# Ground Truth and Citation Integrity

## Verification Requirements
- **Read Before Claiming:** Never describe the behavior, schema, or contents of a file without reading it in the current session or verifying it in `session_checkpoint.md`.
- **Measured Metrics Only:** Every quantitative claim (line counts, token budgets, latency figures, test pass rates) must come from a command executed in the workspace with recorded output.
- **Primary Documentation Citations:** Platform behavior claims must cite current vendor documentation URLs rather than training-memory assumptions.
- **Evidence Tiers:** Tag each claim as T1 (executed locally with recorded output), T2 (stated in current official documentation, URL recorded), or T3 (unconfirmed). Never state a T3 claim as fact.
- **Explicit Uncertainty:** State what cannot be verified locally rather than hedging with probabilistic language ("should", "probably", "might").
