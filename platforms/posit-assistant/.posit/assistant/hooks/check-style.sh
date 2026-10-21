#!/usr/bin/env bash
# Config-driven prose hygiene guard for Posit Assistant (blocks via exit code 2).
# Checks Markdown write and edit payloads for local home directory paths, terms
# listed in .style-denylist.txt, and prose phrases listed in .style-phrases.txt.
# Customize the two config files, not this script.

set -euo pipefail

exec 3<&0
python3 - <<'PY'
import json
import os
import re
import sys

with os.fdopen(3, "r", encoding="utf-8") as f:
    data = json.load(f)

def extract(obj):
    file_path = obj.get("tool_input", {}).get("file_path")
    content = obj.get("tool_input", {}).get("content") or obj.get("tool_input", {}).get("new_string")
    return file_path or "", content or ""

file_path, content = extract(data)

def allow():
    pass
    sys.exit(0)

def deny(reason):
    print(reason, file=sys.stderr)
    sys.exit(2)

if not file_path.endswith((".md", ".mdx")) or not content:
    allow()

HOME_RE = r"(?:/Users/[A-Za-z0-9._-]+|/home/[A-Za-z0-9._-]+)"
PROJECT_ENV_KEYS = ("CLAUDE_PROJECT_DIR", "CURSOR_PROJECT_DIR", "PA_PROJECT_DIR", "DEVIN_PROJECT_DIR")

def find_config(name):
    starts = [os.environ[k] for k in PROJECT_ENV_KEYS if os.environ.get(k)] + [os.getcwd()]
    for start in starts:
        directory = os.path.abspath(start)
        while True:
            candidate = os.path.join(directory, name)
            if os.path.isfile(candidate):
                return candidate
            parent = os.path.dirname(directory)
            if os.path.isdir(os.path.join(directory, ".git")) or parent == directory:
                break
            directory = parent
    return None

def load_terms(name):
    path = find_config(name)
    if not path:
        return []
    with open(path, encoding="utf-8") as handle:
        return [ln.strip() for ln in handle if ln.strip() and not ln.strip().startswith("#")]

def has_term(term, text):
    pattern = r"(?<![\w-])" + re.escape(term) + r"(?![\w-])"
    return re.search(pattern, text, re.IGNORECASE) is not None

violations = []
if re.search(HOME_RE, content):
    violations.append("local home directory path")
for term in load_terms(".style-denylist.txt"):
    if has_term(term, content):
        violations.append("restricted term '" + term + "'")

# Strip fenced and inline code before checking prose phrases
prose = re.sub(r"```[\s\S]*?```", " ", content)
prose = re.sub(r"`[^`\n]+`", " ", prose)
for phrase in load_terms(".style-phrases.txt"):
    if has_term(phrase, prose):
        violations.append("banned phrase '" + phrase + "'")

if violations:
    deny("BLOCKED [check-style]: " + ", ".join(violations))

allow()
PY
