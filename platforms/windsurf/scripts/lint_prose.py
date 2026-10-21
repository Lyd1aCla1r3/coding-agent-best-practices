#!/usr/bin/env python3
"""
Generic, config-driven prose and hygiene linter.

Checks applied to every line of every file (prose and code):
  HOME      local home directory paths such as /Users/<name> or /home/<name>
  SECRET    high-confidence credential prefixes and private key headers
  DENYLIST  terms listed in .style-denylist.txt

Checks applied to prose only (.md, .mdx, .txt), after fenced code blocks and
inline code spans are blanked out with line numbers preserved:
  PHRASE    phrases listed in .style-phrases.txt

Config files are optional. They are looked up in the current directory and
then in each parent directory up to the Git repository root.

Usage: python3 scripts/lint_prose.py <file-or-dir> [more ...]
Exit codes: 0 no findings, 1 findings reported, 2 usage error.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

DENYLIST_FILE = ".style-denylist.txt"
PHRASES_FILE = ".style-phrases.txt"

PROSE_SUFFIXES = {".md", ".mdx", ".txt"}
SCAN_SUFFIXES = PROSE_SUFFIXES | {".mdc", ".sh", ".py", ".json", ".toml", ".yaml", ".yml"}

HOME_PATH_RE = re.compile(r"(?:/Users/[A-Za-z0-9._-]+|/home/[A-Za-z0-9._-]+)")
SECRET_RE = re.compile(
    r"(sk-[A-Za-z0-9]{20,}|ghp_[A-Za-z0-9]{36}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY-----)"
)


def find_config(name: str) -> Path | None:
    """Returns the nearest config file, searching upward to the repository root."""
    current = Path.cwd().resolve()
    for directory in [current, *current.parents]:
        candidate = directory / name
        if candidate.is_file():
            return candidate
        if (directory / ".git").exists():
            break
    return None


def load_terms(name: str) -> list[str]:
    path = find_config(name)
    if path is None:
        return []
    terms = []
    for raw in path.read_text(encoding="utf-8").splitlines():
        cleaned = raw.strip()
        if cleaned and not cleaned.startswith("#"):
            terms.append(cleaned)
    return terms


def term_pattern(term: str) -> re.Pattern[str]:
    """Matches a term or phrase case-insensitively, not as part of a longer word."""
    return re.compile(r"(?<![\w-])" + re.escape(term) + r"(?![\w-])", re.IGNORECASE)


def strip_code_preserve_lines(text: str) -> str:
    """Blanks fenced code blocks and inline code spans while preserving newlines."""

    def blank(match: re.Match[str]) -> str:
        return "".join("\n" if ch == "\n" else " " for ch in match.group(0))

    without_fenced = re.sub(r"```[\s\S]*?```", blank, text)
    return re.sub(r"`[^`\n]+`", blank, without_fenced)


def lint_file(path: Path, denylist: list[str], phrases: list[str]) -> list[str]:
    findings: list[str] = []
    try:
        raw_text = path.read_text(encoding="utf-8")
    except UnicodeDecodeError:
        return findings

    deny_patterns = [(term, term_pattern(term)) for term in denylist]
    for idx, line in enumerate(raw_text.splitlines(), start=1):
        if HOME_PATH_RE.search(line):
            findings.append(f"{path}:{idx}: [HOME] Local home directory path.")
        if SECRET_RE.search(line):
            findings.append(f"{path}:{idx}: [SECRET] Credential or private key header.")
        for term, pattern in deny_patterns:
            if pattern.search(line):
                findings.append(f"{path}:{idx}: [DENYLIST] Restricted term '{term}'.")

    if path.suffix not in PROSE_SUFFIXES or not phrases:
        return findings

    phrase_patterns = [(phrase, term_pattern(phrase)) for phrase in phrases]
    prose_lines = strip_code_preserve_lines(raw_text).splitlines()
    for idx, line in enumerate(prose_lines, start=1):
        for phrase, pattern in phrase_patterns:
            if pattern.search(line):
                findings.append(f"{path}:{idx}: [PHRASE] Banned phrase '{phrase}'.")
    return findings


def iter_targets(args: list[str]) -> list[Path]:
    """Expands directories and skips the config files, which list the banned terms."""
    config_names = {DENYLIST_FILE, PHRASES_FILE}
    targets: list[Path] = []
    for arg in args:
        target = Path(arg)
        if target.is_dir():
            for child in sorted(target.rglob("*")):
                if child.is_file() and child.suffix in SCAN_SUFFIXES and ".git" not in child.parts:
                    targets.append(child)
        elif target.is_file():
            targets.append(target)
    return [t for t in targets if t.name not in config_names]


def main() -> int:
    if len(sys.argv) < 2:
        print("Usage: python3 scripts/lint_prose.py <file-or-dir> [more ...]", file=sys.stderr)
        return 2

    denylist = load_terms(DENYLIST_FILE)
    phrases = load_terms(PHRASES_FILE)
    findings: list[str] = []
    for target in iter_targets(sys.argv[1:]):
        findings.extend(lint_file(target, denylist, phrases))

    if findings:
        for finding in findings:
            print(finding, file=sys.stderr)
        print(f"Total violations: {len(findings)}", file=sys.stderr)
        return 1

    print("ZERO VIOLATIONS")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
