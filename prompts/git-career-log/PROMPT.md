---
name: git-career-log
description: Generate a portfolio/career log of engineering work from git history for job search, interview prep, or personal records.
---

# Git Career Log

## Overview

Generates a structured markdown log from git history — PRs, commits, summaries — without including proprietary code. Designed for job search and interview prep. An AI can query the output to answer "what experience do I have with X?"

## When to Use

- Generating a career portfolio from a codebase
- Preparing for job interviews ("tell me about a time you...")
- Documenting a tenure at a company before leaving
- Building a personal record of work done

## Process

### 1. Establish author identity

Get all commit author emails in the repo:

```bash
git log <main-branch> --since="<start-date>" --format="%ae" | sort -u
```

Identify:
- **Primary emails** — the developer's normal git identity
- **Misconfigured periods** — if credentials were ever broken (e.g. CI environment overwriting git config), note the author name/email used during that window and its date range
- **Exclude** — bots (`dependabot[bot]`, `github-actions[bot]`), release automation, teammates

### 2. Assess scope

```bash
# Count merge commits since start date
git log <main-branch> --merges --since="<start-date>" --oneline | wc -l

# Count commits by the author
git log <main-branch> --since="<start-date>" --author="<email>" --oneline | wc -l
```

If there are 100+ PRs, dispatch an agent (step 3 will be slow).

### 3. Extract PRs via agent

Dispatch a background agent to do the heavy extraction. The agent should:

**Filter merge commits** on the main branch:
```bash
git log <main-branch> --merges --since="<start-date>" --format="%H|%as|%s" | grep "Merge pull request"
```

**For each merge commit**, check if it contains the author's commits:
```bash
git log "${hash}^1..${hash}" --format="%ae|%as|%s" 2>/dev/null
```
`${hash}^1..${hash}` = commits specific to the PR branch (not already in main).

**Author filter rules:**
- Always include: primary email(s)
- Conditionally include: misconfigured email, scoped to the affected date range
- Always exclude: bots and automation

**Per PR, derive:**
- Date, PR number, branch name
- **Type** from branch prefix: `feat` → Feature, `fix` → Bug Fix, `refactor` → Refactor, `chore` → Chore, `ci` → CI/CD, `docs` → Documentation. For date-prefixed branches (`MM-DD-type_description`) extract type from after the date.
- **Summary** — 1–2 sentences explaining *purpose*, not mechanics. Infer from branch name + commit messages.
- **Tags** — skill areas (e.g. `Android`, `Kotlin`, `Architecture`, `Testing`, `CI/CD`, `DX`)
- **Key commits** — meaningful commit messages only (skip merge commits, trivial fixups)
- Group dependabot/automated PRs as a single italicised footnote per month

**Also document unmerged branches** that contain the author's commits.

### 4. Output format

```markdown
# <Project> — Engineering Log
**<Name> | <Start> – <End>**

---

## Skills & Themes
[Written last, after processing all PRs. Summarises major areas evidenced by the work.]

---

## Stats

- **Total merged PRs documented:** N
- **Date range:** ...
- **Commits authored:** ~N
- **Unmerged / in-progress branches:** N

**Breakdown by type:**

| Type | Count |
|------|-------|
| Refactor | N |
| Bug Fix | N |
| ...

**Top skill tags:** tag · tag · tag

---

## Unmerged / In-Progress Work

### branch-name
**Type:** ... | **Tags:** `...`
**Summary:** ...
**Commits:**
- `commit message`

---

## 2024-10 — October 2024    ← oldest first

### PR #NNN — Title (YYYY-MM-DD)
**Type:** ... | **Tags:** `...`
**Branch:** `branch-name`
**Summary:** ...
**Commits:**
- `commit message`

---

*Dependency maintenance: #NNN (description), ...*

---
## 2024-11 — November 2024
...
## 2026-03 — March 2026      ← newest last
```

### 5. Post-process with Python

The agent will likely write newest-first. To reverse and inject the stats section:

```python
import re

with open('career-log.md', 'r') as f:
    lines = f.readlines()

# Find key positions
unmerged_idx = next(i for i, l in enumerate(lines) if l.strip() == '## Unmerged / In-Progress Work')
monthly_starts = [i for i, l in enumerate(lines) if re.match(r'^## 20\d\d-', l.strip())]

header = lines[:unmerged_idx]
unmerged = lines[unmerged_idx:monthly_starts[0]]
monthly_sections = []
for idx, start in enumerate(monthly_starts):
    end = monthly_starts[idx+1] if idx+1 < len(monthly_starts) else len(lines)
    monthly_sections.append(lines[start:end])

monthly_sections.reverse()  # oldest first

# Count types for stats
type_counts = {}
for l in lines:
    m = re.match(r'\*\*Type:\*\*\s+([^\|]+)', l.strip())
    if m:
        t = m.group(1).strip()
        type_counts[t] = type_counts.get(t, 0) + 1

# Build and insert stats block, then write
stats = [ ... ]  # build from type_counts
result = header + stats + unmerged
for section in monthly_sections:
    result.extend(section)

with open('career-log.md', 'w') as f:
    f.writelines(result)
```

### 6. Output location

Store outside the repo — the file can be large (100KB+) and is personal:

```
~/Documents/career/<project-name>.md
```

## Key Edge Cases

**Misconfigured git credentials** — If the developer committed under a wrong identity (e.g. CI environment overwriting `user.email`), identify the affected email and date window and include it in the author filter, scoped to that window only.

**Dependabot PRs appearing in author's list** — This can happen if the merge commit itself is authored by the developer (who pressed the merge button). Filter these out by branch name pattern (`dependabot/`) or label them as dependency maintenance rather than substantive work.

**Unmerged branches** — Check `git branch -r --no-merged <main>` and filter to those with the author's commits. Especially valuable for capturing spikes, explorations, and in-progress work.

**Large repos** — Filtering 400+ merge commits one by one takes 2–3 minutes. Always dispatch a background agent for this step.
