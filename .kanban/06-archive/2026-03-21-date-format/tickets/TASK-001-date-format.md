---
id: "2026-03-21-date-format/TASK-001"
subject: "2026-03-21-date-format"
plan: "../../01-plan/2026-03-21-date-format/plan-date-format.md"
effort: low
status: done
created_at: "2026-03-21T00:00:00Z"
claimed_at: "2026-03-21T22:30:00Z"
completed_at: "2026-03-21T22:40:00Z"
stale_after_hours: 4
spawned_tickets: []
plan_items:
  - "Req 1.1 — Rename all .kanban/ YYYY-MM-DD- dirs to YYYY-MM-DD-"
  - "Req 1.2 — Include date-format subject itself"
  - "Req 2.1 — Update id: frontmatter"
  - "Req 2.2 — Update subject: frontmatter"
  - "Req 2.3 — Update plan: relative paths"
  - "Req 3.1 — Update # YYYY-MM-DD-<subject> titles"
  - "Req 3.2 — Update ## Research: YYYY-MM-DD-<subject> headers"
  - "Req 3.3 — Update all other internal cross-references"
  - "Req 4.1 — Replace YYYY-MM-DD in all 9 command files"
  - "Req 4.2 — Replace date +%y%m%d with date +%Y-%m-%d"
  - "Req 4.3 — Update example slugs in command files"
  - "Req 5.1 — Update SKILL.md directory diagram"
  - "Req 5.2 — Update any other YYYY-MM-DD in docs"
  - "Req 6.1 — Update commit message templates in command files"
acceptance_criteria:
  - "A checklist exists enumerating every file and field that must change, written before any edits are made"
  - "Checklist covers: 11 directories to rename (with before/after names), 9 command files, SKILL.md, all ticket/plan/research files with YYYY-MM-DD content"
  - "Each checklist item is falsifiable: can be confirmed by reading the final file or running grep"
  - "No files are modified at the end of this ticket — grep -r 'YYYY-MM-DD' . returns the same count as the pre-change baseline"
consecutive_failures: 0
---

## Context

Before touching any file, document exactly what must change and where. This is the red phase: establish a complete, falsifiable inventory of every rename target so the implementation tickets can verify against it.

Traced to: all plan requirements (1.1–6.1).

## Acceptance Criteria

- Checklist of all targets written before any edits
- Covers: 11 dirs, 9 command files, SKILL.md, all .kanban/ content files
- Every item falsifiable by grep or file read
- No files modified at end of this ticket

---
<!-- Everything below this line is append-only and chronological -->

## Work Log

**2026-03-21T22:30:00Z — Claimed**
Ticket moved to in-progress.

**2026-03-21T22:30:00Z–22:40:00Z — Research**
- Read plan-date-format.md and research-date-format.md to understand requirements (Req 1.1–6.1).
- Read skills/kanban/SKILL.md to locate YYYY-MM-DD occurrence (line 55, directory diagram).
- Ran grep scans across skills/kanban/ and .kanban/ to establish live baseline.
- Listed all .kanban/ subject directories from filesystem (authoritative — not from research doc).

**Findings (baseline counts):**
- 11 subject directories to rename under .kanban/ stages
- 40 .kanban/ files with YYYY-MM-DD|260321 matches — 202 total occurrences
- 9 command files with YYYY-MM-DD — 116 total occurrences
- 1 SKILL.md occurrence (line 55)
- 3 command files with `date +%y%m%d` to fix: capture.md, plan.md, init.md
- Grand total: 319 occurrences across 50 files

**Note**: Live filesystem shows 11 dirs (matches research doc count). `01-plan/2026-03-21-unified-pipeline/` is included — the research doc did not list it but it follows the YYYY-MM-DD- prefix pattern and has YYYY-MM-DD/260321 content in its input file.

**2026-03-21T22:40:00Z — Checklist written**
Output: `.kanban/01-plan/2026-03-21-date-format/verify-date-format.md`
Covers: §1 directory renames, §2a active ticket frontmatter, §2b archive ticket frontmatter, §2c plan/input/research headers and prose, §3 command files with type breakdown and date-command table, §4 SKILL.md, §5 summary counts, §6 final verification suite.

No implementation files were modified during this ticket.

## Review — 2026-03-21T22:45:00Z — PASS 100%

Reviewers: Echo (Examiner) + Arden (Critic)

| Criterion | Result | Evidence |
|-----------|--------|----------|
| Checklist exists, written before any edits | PASS | `verify-date-format.md` exists; frontmatter reads `Status: Pre-implementation. All items unchecked.`; work log shows it was written at 22:40Z after research only |
| Covers 11 dirs (before/after), 9 command files, SKILL.md, all .kanban/ content files | PASS | §1: 11-row directory table with explicit old→new paths; §2a–2c: 24 .kanban/ content files enumerated (5 active tickets, 19 archive tickets, 17 plan/input/research files); §3: 9 command files with per-file occurrence counts and `date +%y%m%d` sub-table; §4: SKILL.md line 55 |
| Every item falsifiable by grep or file read | PASS | §1 ends with `ls`/`grep` commands; §3 and §4 each have explicit grep verification; §6 provides 5-command final verification suite |
| No files modified — YYYY-MM-DD still returns matches | PASS | Live grep: 9 command files, 116 occurrences (matches §5 baseline exactly); SKILL.md line 55 still reads `YYYY-MM-DD-<subject>/` |

Score: 4/4 = **100%**
