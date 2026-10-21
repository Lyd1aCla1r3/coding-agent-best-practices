# Project Operating Instructions (Universal AGENTS.md)

Read `session_checkpoint.md` at the start of every session before modifying files.

---

# Agency and Execution Discipline

## Core Directives
- **Action Bias:** Execute unambiguous engineering tasks directly. Do not ask for permission before running safe, reversible local commands or editing unscoped project files.
- **No Unsolicited Summaries:** Do not append recap paragraphs after tool execution unless the user requests an explanation. Let the diff and verification output speak for the change.
- **Proactive Clarification:** Pause and ask targeted questions before writing code only when requirements contain genuine architectural ambiguity.
- **Resourcefulness:** Exhaust local search tools (`grep`, file reads, directory listings, test runners) before asking the user where a symbol, configuration file, or script lives.
- **Root-Cause Fixes:** Resolve underlying defects rather than masking symptoms with superficial fallbacks or silent exception handlers.

---

# Ground Truth and Citation Integrity

## Verification Requirements
- **Read Before Claiming:** Never describe the behavior, schema, or contents of a file without reading it in the current session or verifying it in `session_checkpoint.md`.
- **Measured Metrics Only:** Every quantitative claim (line counts, token budgets, latency figures, test pass rates) must come from a command executed in the workspace with recorded output.
- **Primary Documentation Citations:** Platform behavior claims must cite current vendor documentation URLs rather than training-memory assumptions.
- **Evidence Tiers:** Tag each claim as T1 (executed locally with recorded output), T2 (stated in current official documentation, URL recorded), or T3 (unconfirmed). Never state a T3 claim as fact.
- **Explicit Uncertainty:** State what cannot be verified locally rather than hedging with probabilistic language ("should", "probably", "might").

---

# Planning Gate and Approval Protocol

## When to Trigger the Planning Gate
- **Trigger Conditions:** Enter the planning gate before writing application code when a task modifies 3 or more files, alters shared interfaces, touches build pipelines, or introduces new dependencies.
- **Clarify Before Planning:** Ask focused clarifying questions to resolve underspecified requirements before drafting the plan.
- **Approval Boundary:** Present the structured plan (objective, affected files, verification commands, and rollback steps) and wait for explicit user approval (`"approved"` or `"proceed"`) before executing edits.

## Plan Lifecycle Integration (Universal)
- **Durable Plan File:** Run `bash scripts/plan.sh new <slug>` before multi-file edits to create a tracked plan in `plans/`.
- **Lifecycle Commands:** Check active plans with `bash scripts/plan.sh active` and archive completed plans with `bash scripts/plan.sh done <file>`.
- **Doc Reference:** https://agents.md/

---

# Project Writing Conventions

<!-- PLACEHOLDER: replace the example rules below with your team's own conventions. Keep this file short. Mechanical checks belong in .style-denylist.txt and .style-phrases.txt, which scripts/lint_prose.py and the check-style hook enforce. -->

## Example Conventions
- **Consistent Terminology:** Use one term per concept across code, documentation, and commit messages. Record preferred terms in a glossary when the project has one.
- **Active Voice:** Name the actor and the action ("The hook blocks the commit") instead of passive constructions ("The commit is blocked").
- **Define Acronyms:** Spell out every acronym on its first use in each document.
- **Identifiers in Backticks:** Format file paths, commands, configuration keys, and code symbols as inline code.

## Enforcement
- `scripts/lint_prose.py` (run by `.githooks/pre-commit`) and the `check-style` hook flag terms listed in `.style-denylist.txt`, phrases listed in `.style-phrases.txt`, and local home directory paths.
- Judgment-based conventions, such as the examples above, are reviewed by the `style-auditor` subagent.

---

# Frozen Path Protection

## Scope and Restore Points
- **Frozen Directories:** Treat paths listed in `.freeze-paths.txt` (defaulting to `published/` and `archive/`) as immutable reference artifacts during active feature or drafting work.
- **No Unapproved Writes:** Do not edit, overwrite, rename, or delete files inside frozen directories unless the user grants explicit written approval for a specific file in the current prompt.
- **Pre-Integration Restore Point:** Record the current `git rev-parse HEAD` commit SHA in `session_checkpoint.md` before modifying shared build scripts or integration entrypoints.
