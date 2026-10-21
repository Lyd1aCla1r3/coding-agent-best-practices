---
name: deep-research
description: Conduct primary-source verification and evidence-tiered synthesis for technical claims and platform capabilities.
---

# Deep Research and Primary-Source Synthesis

## Purpose
Verify technical specifications, API schemas, and platform capabilities against official primary documentation, tagging every finding with an explicit evidence tier.

## Evidence Tiers
- **T1 (Executed):** Behavior observed and recorded by running a command or script in the local environment.
- **T2 (Documented):** Behavior stated in current official vendor documentation, recorded with the direct URL and section heading.
- **T3 (Unconfirmed):** Community posts, stale training memory, or inferred behavior not backed by T1 or T2. Never publish T3 claims as fact.

## Execution Steps
1. **Enumerate Claims:** List every schema field, file path, CLI flag, or lifecycle event that requires verification.
2. **Fetch Primary Sources:** Retrieve the official documentation pages or inspect the installed binary/schema directly.
3. **Build Verification Matrix:** Record each item with its tier (`T1`, `T2`, or `T3`), canonical source URL, and verbatim schema details.
4. **Prune Unconfirmed Items:** Replace any `T3` item with a documented bridge (such as a Git hook or standalone script) and state the limitation directly.
