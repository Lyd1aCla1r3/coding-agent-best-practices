---
trigger: glob
description: "Project writing conventions for Markdown files (placeholder to customize)"
globs: "*.md"
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
