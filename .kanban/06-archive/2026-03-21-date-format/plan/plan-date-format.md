## Intent

`YYYY-MM-DD` date prefixes are ambiguous and require mental parsing. Replacing them with ISO 8601 `YYYY-MM-DD` throughout the kanban system makes directories self-documenting, sortable, and consistent with standard tooling. This is a full rename — existing directories, file content, command templates, and documentation all change. No exceptions, including the `date-format` subject itself.

## Requirements

### 1. Directory renames

1.1 All `.kanban/` stage subdirectories with `YYYY-MM-DD-<subject>` prefixes are renamed to `YYYY-MM-DD-<subject>` (e.g. `2026-03-21-capture-flow` → `2026-03-21-capture-flow`).

1.2 The `date-format` subject directory is included in the rename: `2026-03-21-date-format` → `2026-03-21-date-format`.

### 2. Ticket file frontmatter

2.1 The `id:` field in all ticket files updated from `"YYYY-MM-DD-<subject>/TASK-NNN"` to `"YYYY-MM-DD-<subject>/TASK-NNN"`.

2.2 The `subject:` field in all ticket files updated from `"YYYY-MM-DD-<subject>"` to `"YYYY-MM-DD-<subject>"`.

2.3 The `plan:` relative path in all ticket files updated to reflect the renamed directory paths.

### 3. Internal file content

3.1 `# YYYY-MM-DD-<subject>` title lines in all input files updated to `# YYYY-MM-DD-<subject>`.

3.2 `## Research: YYYY-MM-DD-<subject>` header lines in all research files updated to `## Research: YYYY-MM-DD-<subject>`.

3.3 All other internal cross-references in plan, research, and input files updated to use new directory paths.

### 4. Command files

4.1 All occurrences of `YYYY-MM-DD` in all 9 command files (`capture.md`, `plan.md`, `todo.md`, `work.md`, `review.md`, `pr.md`, `cleanup.md`, `next.md`, `init.md`) replaced with `YYYY-MM-DD`.

4.2 The `date +%y%m%d` bash command template replaced with `date +%Y-%m-%d` in every command file where it appears.

4.3 All example subject slugs and subject patterns in command files updated to use the new format.

### 5. Documentation

5.1 `SKILL.md` directory structure diagram updated to show `YYYY-MM-DD-<subject>/` instead of `YYYY-MM-DD-<subject>/`.

5.2 All other occurrences of `YYYY-MM-DD` in `SKILL.md` or any other documentation files updated.

### 6. Going-forward conventions

6.1 Commit message templates in command files updated to reference `YYYY-MM-DD-<subject>` format (e.g. `kanban(capture): capture raw input for YYYY-MM-DD-<subject>`).

## Constraints

- Use `mv` to rename directories — never delete and recreate (ticket files are audit trails).
- Historical git commit messages are immutable — do not attempt to rewrite them.
- All renames must be staged and committed atomically per logical unit (directories + content together).

## Out of Scope

- `TASK-NNN` ticket naming convention — not date-prefixed, unchanged.
- Historical git commit messages.
- Changes to any non-kanban files.

## Audit: input → plan — PASS
**Date**: 2026-03-21T00:00:00Z  **Threshold**: 95%

| # | Item | Status | Notes |
|---|------|--------|-------|
| 1 | YYYY-MM-DD → YYYY-MM-DD everywhere | Full | §1–6 |
| 2 | Rename existing .kanban/ dirs | Full | §1.1 |
| 3 | Include date-format itself | Full | §1.2 |
| 4 | Ticket frontmatter (id, subject, plan) | Full | §2.1–2.3 |
| 5 | Internal file content (titles, headers, cross-refs) | Full | §3.1–3.3 |
| 6 | All 9 command files | Full | §4.1, §4.3 |
| 7 | date +%y%m%d → date +%Y-%m-%d | Full | §4.2 |
| 8 | SKILL.md and docs | Full | §5.1–5.2 |
| 9 | Commit message templates | Full | §6.1 |
| 10 | Use mv not delete/recreate | Full | Constraints |
| 11 | Historical commits immutable | Full | Out of Scope |

- Full: 11, Partial: 0, Missing: 0 — Total: 11
- Score: (11 + 0.5×0) / 11 × 100 = **100%**

### Fixes Applied
- None.

## Audit: plan → todo — PASS
**Date**: 2026-03-21T00:00:00Z  **Threshold**: 95%

| # | Requirement | Ticket(s) | Status | Notes |
|---|------------|-----------|--------|-------|
| 1 | 1.1 Rename all .kanban/ dirs | TASK-001, TASK-002 | Full | |
| 2 | 1.2 Include date-format itself | TASK-001, TASK-002 | Full | |
| 3 | 2.1 Update id: frontmatter | TASK-001, TASK-003 | Full | |
| 4 | 2.2 Update subject: frontmatter | TASK-001, TASK-003 | Full | |
| 5 | 2.3 Update plan: relative paths | TASK-001, TASK-003 | Full | |
| 6 | 3.1 Update # YYYY-MM-DD- titles | TASK-001, TASK-003 | Full | |
| 7 | 3.2 Update ## Research: headers | TASK-001, TASK-003 | Full | |
| 8 | 3.3 Update all cross-references | TASK-001, TASK-003 | Full | |
| 9 | 4.1 Replace YYYY-MM-DD in 9 command files | TASK-001, TASK-004 | Full | |
| 10 | 4.2 Fix date +%y%m%d template | TASK-001, TASK-004 | Full | |
| 11 | 4.3 Update example slugs | TASK-001, TASK-004 | Full | |
| 12 | 5.1 Update SKILL.md diagram | TASK-001, TASK-005 | Full | |
| 13 | 5.2 Update other docs | TASK-001, TASK-005 | Full | |
| 14 | 6.1 Update commit message templates | TASK-001, TASK-004 | Full | |

- Full: 14, Partial: 0, Missing: 0 — Total: 14
- Score: (14 + 0.5×0) / 14 × 100 = **100%**

### Fixes Applied
- None.

## Audit: tickets → archive — PASS
**Date**: 2026-03-22T00:00:00Z  **Threshold**: 95%  **Auditors**: Arden (Critic) + Pulse (Analytics)

| # | Requirement | Ticket(s) | Review Score | Status |
|---|-------------|-----------|-------------|--------|
| 1 | 1.1 Rename all .kanban/ YYYY-MM-DD- dirs | TASK-002 | 100% | Full |
| 2 | 1.2 Include date-format itself | TASK-002 | 100% | Full |
| 3 | 2.1 Update id: frontmatter | TASK-003 | 100% | Full |
| 4 | 2.2 Update subject: frontmatter | TASK-003 | 100% | Full |
| 5 | 2.3 Update plan: relative paths | TASK-003 | 100% | Full |
| 6 | 3.1 Update # title lines | TASK-003 | 100% | Full |
| 7 | 3.2 Update ## Research: headers | TASK-003 | 100% | Full |
| 8 | 3.3 Update all cross-references | TASK-003 | 100% | Full |
| 9 | 4.1 Replace YYYY-MM-DD in 9 command files | TASK-004 | 100% | Full |
| 10 | 4.2 Fix date +%y%m%d → date +%Y-%m-%d | TASK-004 | 100% | Full |
| 11 | 4.3 Update example slugs in command files | TASK-004 | 100% | Full |
| 12 | 5.1 Update SKILL.md directory diagram | TASK-005 | 100% | Full |
| 13 | 5.2 Update other docs | TASK-005 | 100% | Full |
| 14 | 6.1 Update commit message templates | TASK-004 | 100% | Full |

- Full: 14, Partial: 0, Missing: 0 — Total: 14
- Score: (14 + 0.5×0) / 14 × 100 = **100%**

### Fixes Applied
- None. All requirements delivered at 100% by their respective tickets.
