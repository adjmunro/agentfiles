# Date Format Migration Checklist
**Written at**: 2026-03-21T22:30:00Z
**Status**: Pre-implementation. All items unchecked.

---

## 1. Directory Renames (.kanban/)

All subject directories to rename from `260321-` to `2026-03-21-` prefix using `mv`.

**Live directory count**: 11 (verified from filesystem, not research doc)

| Old path | New path |
|----------|----------|
| `.kanban/01-plan/260321-date-format/` | `.kanban/01-plan/2026-03-21-date-format/` |
| `.kanban/02-todo/260321-date-format/` | `.kanban/02-todo/2026-03-21-date-format/` |
| `.kanban/03-in-progress/260321-date-format/` | `.kanban/03-in-progress/2026-03-21-date-format/` |
| `.kanban/02-todo/260321-kanban-ux-hints/` | `.kanban/02-todo/2026-03-21-kanban-ux-hints/` |
| `.kanban/03-in-progress/260321-kanban-ux-hints/` | `.kanban/03-in-progress/2026-03-21-kanban-ux-hints/` |
| `.kanban/04-in-review/260321-kanban-ux-hints/` | `.kanban/04-in-review/2026-03-21-kanban-ux-hints/` |
| `.kanban/06-archive/260321-capture-flow/` | `.kanban/06-archive/2026-03-21-capture-flow/` |
| `.kanban/06-archive/260321-command-handoff/` | `.kanban/06-archive/2026-03-21-command-handoff/` |
| `.kanban/06-archive/260321-kanban-ux-hints/` | `.kanban/06-archive/2026-03-21-kanban-ux-hints/` |
| `.kanban/06-archive/260321-pr-trunk-skip/` | `.kanban/06-archive/2026-03-21-pr-trunk-skip/` |
| `.kanban/01-plan/260321-unified-pipeline/` | `.kanban/01-plan/2026-03-21-unified-pipeline/` |

**Note**: `260321-unified-pipeline` has no active tickets and is not a date-format migration subject, but it follows the same `YYMMDD-` prefix convention and must be renamed. Its input file also contains `260321` references (line 1 title and line 103 cross-reference).

**Hazard**: After TASK-002 renames `260321-date-format`, the working subject directory for TASK-003+ becomes `2026-03-21-date-format`. All subsequent tasks must reference the new path.

Verification: `grep -r '260321' .kanban/ --include='*.md' -l | xargs grep -l '^id:\|^subject:'` shows no files with old-format `id:` or `subject:` fields.

More direct: after TASK-002, `ls .kanban/*/260321-*` returns empty.

---

## 2. File Content Updates (.kanban/ files)

Total files with `YYMMDD|260321` matches: **40 files, 202 occurrences** (baseline at time of writing).

### 2a. Active ticket frontmatter (02-todo, 03-in-progress)

These 5 tickets each have `id:`, `subject:`, and `plan:` fields referencing the old format. All three fields must change.

| File | id: old | id: new | subject: old | subject: new | plan: old | plan: new |
|------|---------|---------|-------------|-------------|---------|---------|
| `.kanban/02-todo/260321-date-format/TASK-002-date-format.md` | `"260321-date-format/TASK-002"` | `"2026-03-21-date-format/TASK-002"` | `"260321-date-format"` | `"2026-03-21-date-format"` | `"../../01-plan/260321-date-format/plan-date-format.md"` | `"../../01-plan/2026-03-21-date-format/plan-date-format.md"` |
| `.kanban/02-todo/260321-date-format/TASK-003-date-format.md` | `"260321-date-format/TASK-003"` | `"2026-03-21-date-format/TASK-003"` | `"260321-date-format"` | `"2026-03-21-date-format"` | same as above | same as above |
| `.kanban/02-todo/260321-date-format/TASK-004-date-format.md` | `"260321-date-format/TASK-004"` | `"2026-03-21-date-format/TASK-004"` | `"260321-date-format"` | `"2026-03-21-date-format"` | same as above | same as above |
| `.kanban/02-todo/260321-date-format/TASK-005-date-format.md` | `"260321-date-format/TASK-005"` | `"2026-03-21-date-format/TASK-005"` | `"260321-date-format"` | `"2026-03-21-date-format"` | same as above | same as above |
| `.kanban/03-in-progress/260321-date-format/TASK-001-date-format.md` | `"260321-date-format/TASK-001"` | `"2026-03-21-date-format/TASK-001"` | `"260321-date-format"` | `"2026-03-21-date-format"` | same as above | same as above |

**Note**: TASK-002 through TASK-005 also contain `260321` in their plan_items, acceptance_criteria, and body prose. All occurrences must change.

### 2b. Archive ticket frontmatter (06-archive)

19 archive ticket files. Each has `id:`, `subject:`, and `plan:` fields.

**capture-flow (6 tickets):**

| File | id: | subject: | plan: |
|------|-----|---------|-------|
| `06-archive/260321-capture-flow/tickets/TASK-001-capture-flow.md` | `"260321-capture-flow/TASK-001"` → `"2026-03-21-capture-flow/TASK-001"` | `"260321-capture-flow"` → `"2026-03-21-capture-flow"` | `"../../01-plan/260321-capture-flow/plan-capture-flow.md"` → `"../../01-plan/2026-03-21-capture-flow/plan-capture-flow.md"` |
| `06-archive/260321-capture-flow/tickets/TASK-002-capture-flow.md` | same pattern | same | same |
| `06-archive/260321-capture-flow/tickets/TASK-003-capture-flow.md` | same pattern | same | same |
| `06-archive/260321-capture-flow/tickets/TASK-004-capture-flow.md` | same pattern | same | same |
| `06-archive/260321-capture-flow/tickets/TASK-005-capture-flow.md` | same pattern | same | same |
| `06-archive/260321-capture-flow/tickets/TASK-006-capture-flow.md` | same pattern | same | same |

**command-handoff (6 tickets):**

| File | id: | subject: | plan: |
|------|-----|---------|-------|
| `06-archive/260321-command-handoff/tickets/TASK-001-command-handoff.md` | `"260321-command-handoff/TASK-001"` → `"2026-03-21-command-handoff/TASK-001"` | `"260321-command-handoff"` → `"2026-03-21-command-handoff"` | `"../../01-plan/260321-command-handoff/plan-command-handoff.md"` → `"../../01-plan/2026-03-21-command-handoff/plan-command-handoff.md"` |
| `06-archive/260321-command-handoff/tickets/TASK-002-command-handoff.md` | same pattern | same | same |
| `06-archive/260321-command-handoff/tickets/TASK-003-command-handoff.md` | same pattern | same | same |
| `06-archive/260321-command-handoff/tickets/TASK-004-command-handoff.md` | same pattern | same | same |
| `06-archive/260321-command-handoff/tickets/TASK-005-command-handoff.md` | same pattern | same | same |
| `06-archive/260321-command-handoff/tickets/TASK-006-command-handoff.md` | same pattern | same | same |

**kanban-ux-hints (3 tickets):**

| File | id: | subject: | plan: |
|------|-----|---------|-------|
| `06-archive/260321-kanban-ux-hints/tickets/TASK-001-kanban-ux-hints.md` | `"260321-kanban-ux-hints/TASK-001"` → `"2026-03-21-kanban-ux-hints/TASK-001"` | `"260321-kanban-ux-hints"` → `"2026-03-21-kanban-ux-hints"` | `"../../01-plan/260321-kanban-ux-hints/plan-kanban-ux-hints.md"` → `"../../01-plan/2026-03-21-kanban-ux-hints/plan-kanban-ux-hints.md"` |
| `06-archive/260321-kanban-ux-hints/tickets/TASK-002-kanban-ux-hints.md` | same pattern | same | same |
| `06-archive/260321-kanban-ux-hints/tickets/TASK-003-kanban-ux-hints.md` | same pattern | same | same |

**pr-trunk-skip (4 tickets):**

| File | id: | subject: | plan: |
|------|-----|---------|-------|
| `06-archive/260321-pr-trunk-skip/tickets/TASK-001-pr-trunk-skip.md` | `"260321-pr-trunk-skip/TASK-001"` → `"2026-03-21-pr-trunk-skip/TASK-001"` | `"260321-pr-trunk-skip"` → `"2026-03-21-pr-trunk-skip"` | `"../../01-plan/260321-pr-trunk-skip/plan-pr-trunk-skip.md"` → `"../../01-plan/2026-03-21-pr-trunk-skip/plan-pr-trunk-skip.md"` |
| `06-archive/260321-pr-trunk-skip/tickets/TASK-002-pr-trunk-skip.md` | same pattern | same | same |
| `06-archive/260321-pr-trunk-skip/tickets/TASK-003-pr-trunk-skip.md` | same pattern | same | same |
| `06-archive/260321-pr-trunk-skip/tickets/TASK-004-pr-trunk-skip.md` | same pattern | same | same |

### 2c. Plan/input/research file headers and titles

These non-ticket markdown files have `# YYMMDD-<subject>`, `## Research: YYMMDD-<subject>`, or `# Plan: YYMMDD-<subject>` headers, plus internal `260321` cross-references.

| File | Old header (line 1) | New header | Internal 260321 refs? |
|------|--------------------|-----------|-----------------------|
| `.kanban/01-plan/260321-date-format/input-date-format.md` | `# 260321-date-format` | `# 2026-03-21-date-format` | Yes — body text (7 total occurrences) |
| `.kanban/01-plan/260321-date-format/research-date-format.md` | `## Research: 260321-date-format` | `## Research: 2026-03-21-date-format` | Yes — table, body, cross-refs (22 total occurrences) |
| `.kanban/01-plan/260321-date-format/plan-date-format.md` | (no 260321 header — starts with `## Intent`) | n/a header | Yes — body refs to 260321 dirs/subjects (13 occurrences) |
| `.kanban/01-plan/260321-unified-pipeline/input-unified-pipeline.md` | `# 260321-unified-pipeline` | `# 2026-03-21-unified-pipeline` | Yes — line 103 cross-ref to `260321-command-handoff` (2 total occurrences) |
| `.kanban/06-archive/260321-capture-flow/plan/input-capture-flow.md` | `# 260321-capture-flow` | `# 2026-03-21-capture-flow` | No (1 occurrence = header only) |
| `.kanban/06-archive/260321-capture-flow/plan/research-capture-flow.md` | `## Research: 260321-capture-flow` | `## Research: 2026-03-21-capture-flow` | No (1 occurrence = header only) |
| `.kanban/06-archive/260321-capture-flow/plan/plan-capture-flow.md` | (no 260321 header) | n/a | No — 0 occurrences (file not in match list) |
| `.kanban/06-archive/260321-command-handoff/plan/input-command-handoff.md` | `# 260321-command-handoff` | `# 2026-03-21-command-handoff` | No (1 occurrence = header only) |
| `.kanban/06-archive/260321-command-handoff/plan/research-command-handoff.md` | `## Research: 260321-command-handoff` | `## Research: 2026-03-21-command-handoff` | Yes — 4 total occurrences |
| `.kanban/06-archive/260321-command-handoff/plan/plan-command-handoff.md` | (no 260321 header) | n/a | Yes — body prose example `260321-command-handoff` (3 occurrences) |
| `.kanban/06-archive/260321-command-handoff/plan/review-command-handoff.md` | (no 260321 header — review file) | n/a | Yes — 1 occurrence |
| `.kanban/06-archive/260321-kanban-ux-hints/plan/input-kanban-ux-hints.md` | `# 260321-kanban-ux-hints` | `# 2026-03-21-kanban-ux-hints` | No (1 occurrence = header only) |
| `.kanban/06-archive/260321-kanban-ux-hints/plan/research-kanban-ux-hints.md` | `## Research: 260321-kanban-ux-hints` | `## Research: 2026-03-21-kanban-ux-hints` | Yes — 10 total occurrences |
| `.kanban/06-archive/260321-kanban-ux-hints/plan/plan-kanban-ux-hints.md` | `# Plan: 260321-kanban-ux-hints` | `# Plan: 2026-03-21-kanban-ux-hints` | No (1 occurrence = header only) |
| `.kanban/06-archive/260321-pr-trunk-skip/plan/input-pr-trunk-skip.md` | `# 260321-pr-trunk-skip` | `# 2026-03-21-pr-trunk-skip` | No (1 occurrence = header only) |
| `.kanban/06-archive/260321-pr-trunk-skip/plan/research-pr-trunk-skip.md` | `## Research: 260321-pr-trunk-skip` | `## Research: 2026-03-21-pr-trunk-skip` | Yes — 3 total occurrences |
| `.kanban/06-archive/260321-pr-trunk-skip/plan/verify-pr-trunk-skip.md` | (no 260321 header — verify file) | n/a | Yes — 1 occurrence |

Verification: `grep -r 'YYMMDD\|260321' .kanban/` returns empty after all content updates.

---

## 3. Command Files (skills/kanban/commands/)

**Total**: 9 files, **116 occurrences** of `YYMMDD` (baseline).

| File | YYMMDD occurrences | Types present |
|------|-------------------|---------------|
| `commands/capture.md` | 9 | argument-hint, argument-match pattern, date format string + `date +%y%m%d` shell template, directory path templates, file content template (`# YYMMDD-<subject>`, `## Session YYMMDD-HH:MM`), commit message template |
| `commands/plan.md` | 13 | argument-hint, argument-match pattern, date format string + `date +%y%m%d` shell template, directory path templates, subject slug derivation, commit message template |
| `commands/todo.md` | 16 | argument-hint, argument-match pattern, directory path templates, subject derivation steps, commit message templates |
| `commands/work.md` | 12 | argument-hint, argument-match pattern, directory path templates, subject derivation steps, commit message templates |
| `commands/review.md` | 5 | argument-hint, directory path templates, commit message templates |
| `commands/pr.md` | 15 | argument-hint, argument-match pattern, directory path templates, subject derivation steps, commit message templates |
| `commands/cleanup.md` | 23 | argument-hint, argument-match pattern, directory path templates, archive path templates, commit message template, summary output template |
| `commands/next.md` | 13 | argument-hint, argument-match pattern, directory path templates, subject derivation steps, commit message templates |
| `commands/init.md` | 10 | argument-hint, argument-match pattern, date format string + `date +%y%m%d` shell template, directory path templates, file content stub template (`# YYMMDD-<subject>`), commit message template |

### `date +%y%m%d` → `date +%Y-%m-%d` (3 files)

| File | Line content (current) |
|------|----------------------|
| `commands/capture.md` | `Bash` tool with `date +%y%m%d`. The final subject name MUST follow the pattern `YYMMDD-subject-slug`. |
| `commands/plan.md` | `Bash` with `date +%y%m%d`. |
| `commands/init.md` | `Bash` tool with `date +%y%m%d`. |

Verification: `grep -r 'YYMMDD' skills/kanban/commands/` returns empty after all updates.

---

## 4. SKILL.md and Other Non-Command Docs

| File | Line | Current content | Change |
|------|------|----------------|--------|
| `skills/kanban/SKILL.md` | 55 | `│   └── YYMMDD-<subject>/` | `│   └── YYYY-MM-DD-<subject>/` |

**Total YYMMDD occurrences in SKILL.md**: 1

No other non-command doc files under `skills/kanban/` contain `YYMMDD`. The personas directory was checked — no matches.

Verification: `grep -r 'YYMMDD' skills/kanban/ --include='*.md' --exclude-dir=commands` returns empty after update.

---

## 5. Summary Counts (baseline, pre-implementation)

| Area | Directories | Files with matches | Total occurrences |
|------|-----------|--------------------|-------------------|
| `.kanban/` subject dirs to rename | 11 | — | — |
| `.kanban/` file content | — | 40 | 202 |
| `skills/kanban/commands/` | — | 9 | 116 |
| `skills/kanban/SKILL.md` | — | 1 | 1 |
| **Total** | **11 dirs** | **50 files** | **319 occurrences** |

---

## 6. Final Verification Suite

Run these commands after all implementation tickets complete. Every command must return empty/zero.

```
# Section 1 — no YYMMDD-prefixed directories remain
ls .kanban/*/260321-* 2>&1 | grep -v "No such file"

# Section 2 — no 260321 or YYMMDD in .kanban/ content
grep -r 'YYMMDD\|260321' .kanban/

# Section 3 — no YYMMDD in command files
grep -r 'YYMMDD' skills/kanban/commands/

# Section 3 — no date +%y%m%d shell templates
grep -r 'date +%y%m%d' skills/kanban/commands/

# Section 4 — no YYMMDD in SKILL.md or other docs
grep -r 'YYMMDD' skills/kanban/ --include='*.md' --exclude-dir=commands
```
