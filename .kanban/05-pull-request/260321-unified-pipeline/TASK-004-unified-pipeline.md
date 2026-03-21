---
id: "260321-unified-pipeline/TASK-004"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: medium
status: done
created_at: "2026-03-22T00:00:00Z"
claimed_at: "2026-03-22T00:00:00Z"
completed_at: "2026-03-22T00:00:00Z"
stale_after_hours: 4
depends_on:
  - "TASK-002"
spawned_tickets: []
plan_items:
  - "Req 2.3 Step 2 — Research: webfetch, local file scan, docs lookup before asking user anything"
  - "Req 4.1 — research snapshot format: date, may-go-stale disclaimer, sections"
  - "Req 4.1 — git commit after phase completes"
acceptance_criteria:
  - "[ -f skills/ideation/commands/research.md ] — file exists"
  - "grep -q 'model:' skills/ideation/commands/research.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/ideation/commands/research.md — frontmatter has allowed-tools"
  - "grep -qi '01-research' skills/ideation/commands/research.md — references 01-research-{subject}.md output file"
  - "grep -qi 'webfetch\\|WebFetch\\|web.fetch' skills/ideation/commands/research.md — webfetch usage documented"
  - "grep -qi 'may go stale\\|snapshot' skills/ideation/commands/research.md — stale disclaimer present"
  - "grep -qi 'project structure' skills/ideation/commands/research.md — research section headings present"
  - "grep -qi 'hazard' skills/ideation/commands/research.md — hazards section documented"
  - "grep -qi 'git' skills/ideation/commands/research.md — git commit step present"
consecutive_failures: 0
---

## Context

Writes `skills/ideation/commands/research.md` — Step 2 of the ideation flow. This phase runs before the user is asked anything: it scans relevant local files, fetches relevant documentation, and maps what already exists in the codebase. Findings are written to `01-research-{subject}.md`.

Research snapshot format (carry-forward from §4.1): date, "may go stale" disclaimer, sections: Project Structure / Relevant Patterns / Dependencies / Hazards / Recommended Ticket Sequence.

Command model: `claude-opus-4-6` (needs WebFetch and deep scanning capability).

## Acceptance Criteria

- `skills/ideation/commands/research.md` exists with valid frontmatter
- References `01-research-{subject}.md` as the output file
- Documents WebFetch usage for external docs lookup
- Includes "may go stale" disclaimer language
- Research output sections documented (Project Structure, Relevant Patterns, etc.)
- Hazards section included in output format
- Git commit step present at end of phase

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-22T00:00:00Z

**Status**: Completed

**Work done**:
- Read `skills/kanban/commands/todo.md` for scout/research patterns and snapshot format.
- Read `skills/ideation/SKILL.md` for full flow context and Step 2 requirements.
- Read `skills/ideation/commands/capture.md` for command file structure/style reference.
- Read `skills/kanban/personas/scout.md` (Finn) for persona voice and rules.
- Created `skills/ideation/commands/research.md` with 6 phases: Load Input, Local Scan, External Research, Write Snapshot, Git Commit, Report.

**ACs verified**: All 9 acceptance criteria passed (file existence, frontmatter fields, 01-research reference, WebFetch usage, may-go-stale disclaimer, Project Structure heading, Hazards section, git commit step).
