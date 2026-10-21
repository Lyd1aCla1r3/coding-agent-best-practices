#!/usr/bin/env python3
"""
Verifies that every platform tree matches the shared sources in core/.

Two kinds of checks:
  VERBATIM  skills, pre-commit, scripts, and state files must be byte-identical
            to their core/ copies.
  BODY      rules and subagents carry tool-specific frontmatter (or a handoff
            header), so the text after it must equal the core/ body. The
            planning-mode rule may append exactly one tool-specific section.
            Universal AGENTS.md must contain every core rule body.

Usage: python3 tests/check_core_sync.py
Exit codes: 0 in sync, 1 differences found.
"""

from __future__ import annotations

import sys
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent
CORE = BASE_DIR / "core"
PLATFORMS = BASE_DIR / "platforms"

TOOLS = ["claude-code", "cursor", "antigravity", "posit-assistant", "windsurf", "cline", "universal"]

SKILLS_DIR = {
    "claude-code": ".claude/skills",
    "cursor": ".cursor/skills",
    "antigravity": ".agents/skills",
    "posit-assistant": ".posit/assistant/skills",
    "windsurf": ".devin/skills",
    "cline": ".cline/skills",
    "universal": ".agents/skills",
}

VERBATIM = {
    "githooks/pre-commit": ".githooks/pre-commit",
    "scripts/plan.sh": "scripts/plan.sh",
    "scripts/lint_prose.py": "scripts/lint_prose.py",
    "state/session_checkpoint.md": "session_checkpoint.md",
    "state/.freeze-paths.txt": ".freeze-paths.txt",
    "state/.style-denylist.txt": ".style-denylist.txt",
    "state/.style-phrases.txt": ".style-phrases.txt",
}

RULES = ["agency", "ground-truth", "planning-mode", "writing-style", "freeze-paths"]
AGENTS = ["codebase-explorer", "web-researcher", "style-auditor"]

RULE_PATH = {
    "claude-code": ".claude/rules/{name}.md",
    "cursor": ".cursor/rules/{name}.mdc",
    "antigravity": ".agents/rules/{name}.md",
    "posit-assistant": ".posit/assistant/rules/{name}.md",
    "windsurf": ".devin/rules/{name}.md",
    "cline": ".clinerules/{num:02d}-{name}.md",
}

AGENT_PATH = {
    "claude-code": (".claude/agents/{name}.md", "frontmatter"),
    "cursor": (".cursor/agents/{name}.md", "frontmatter"),
    "antigravity": (".agents/agents/{name}.md", "frontmatter"),
    "windsurf": (".devin/agents/{name}.md", "frontmatter"),
    "posit-assistant": (".posit/assistant/handoffs/{name}-prompt.md", "handoff"),
    "cline": (".clinerules/newtask-prompts/{name}-prompt.md", "handoff"),
    "universal": ("handoffs/{name}-prompt.md", "handoff"),
}


def strip_frontmatter(text: str) -> str:
    if text.startswith("---\n"):
        end = text.index("\n---\n", 4) + len("\n---\n")
        return text[end:].lstrip("\n")
    return text


def main() -> int:
    problems: list[str] = []
    checked = 0

    def check(condition: bool, message: str) -> None:
        nonlocal checked
        checked += 1
        if not condition:
            problems.append(message)

    for tool in TOOLS:
        root = PLATFORMS / tool

        for core_rel, plat_rel in VERBATIM.items():
            target = root / plat_rel
            check(target.is_file() and target.read_bytes() == (CORE / core_rel).read_bytes(),
                  f"VERBATIM {tool}/{plat_rel} != core/{core_rel}")

        for skill in sorted((CORE / "skills").rglob("*")):
            if skill.is_file():
                rel = skill.relative_to(CORE / "skills")
                target = root / SKILLS_DIR[tool] / rel
                check(target.is_file() and target.read_bytes() == skill.read_bytes(),
                      f"VERBATIM {tool}/{SKILLS_DIR[tool]}/{rel} != core/skills/{rel}")

        for num, rule in enumerate(RULES, start=1):
            core_body = (CORE / "rules" / f"{rule}.md").read_text(encoding="utf-8")
            if tool == "universal":
                agents_md = (root / "AGENTS.md").read_text(encoding="utf-8")
                check(core_body in agents_md, f"BODY universal/AGENTS.md is missing core/rules/{rule}.md")
                continue
            rel = RULE_PATH[tool].format(name=rule, num=num)
            body = strip_frontmatter((root / rel).read_text(encoding="utf-8"))
            if rule == "planning-mode":
                rest = body[len(core_body):]
                ok = body.startswith(core_body) and rest.startswith("\n## ") and rest.count("\n## ") == 1
                check(ok, f"BODY {tool}/{rel} must be core body plus one tool-specific section")
            else:
                check(body == core_body, f"BODY {tool}/{rel} != core/rules/{rule}.md")

        for agent in AGENTS:
            pattern, kind = AGENT_PATH[tool]
            rel = pattern.format(name=agent)
            text = (root / rel).read_text(encoding="utf-8")
            core_body = (CORE / "agents" / f"{agent}.md").read_text(encoding="utf-8")
            if kind == "frontmatter":
                body = strip_frontmatter(text)
            else:
                marker = "## Prompt Body\n\n"
                body = text[text.index(marker) + len(marker):] if marker in text else ""
                body = body[:-1] if body.endswith("\n\n") else body
            check(body == core_body, f"BODY {tool}/{rel} != core/agents/{agent}.md")

    for problem in problems:
        print(problem, file=sys.stderr)
    print(f"core/ sync: {checked - len(problems)}/{checked} checks passed, {len(problems)} diffs.")
    return 1 if problems else 0


if __name__ == "__main__":
    raise SystemExit(main())
