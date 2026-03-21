---
id: "260321-unified-pipeline/TASK-005"
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
  - "Req 2.3 Step 3 — Interview: questions informed by captured input AND research findings"
  - "Req 2.3 Step 3 — agent gives recommendations and explains tradeoffs between options"
  - "Req 4.1 — AskUserQuestion: max 4 options, (Recommended) label, option order signals Enter-to-confirm"
  - "Req 4.1 — git commit after phase completes"
acceptance_criteria:
  - "[ -f skills/ideation/commands/interview.md ] — file exists"
  - "grep -q 'model:' skills/ideation/commands/interview.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/ideation/commands/interview.md — frontmatter has allowed-tools"
  - "grep -qi 'research' skills/ideation/commands/interview.md — research findings referenced as input"
  - "grep -qi '00-input\\|capture' skills/ideation/commands/interview.md — captured input referenced as input"
  - "grep -qi 'recommend' skills/ideation/commands/interview.md — recommendation requirement present"
  - "grep -qi 'tradeoff\\|trade-off\\|pros and cons' skills/ideation/commands/interview.md — tradeoffs requirement present"
  - "grep -qi 'AskUserQuestion\\|ask.*user\\|question' skills/ideation/commands/interview.md — AskUserQuestion usage documented"
  - "grep -qi 'git' skills/ideation/commands/interview.md — git commit step present"
consecutive_failures: 0
---

## Context

Writes `skills/ideation/commands/interview.md` — Step 3 of the ideation flow. Questions must be informed by both the captured input (`00-input-{subject}.md`) and the research findings (`01-research-{subject}.md`). The agent must give recommendations on suggested choices and explain tradeoffs between options — not just ask open questions. Inspired by the `/interview` command pattern in the existing kanban skill.

Command model: `claude-sonnet-4-6` (standard interactive work).

## Acceptance Criteria

- `skills/ideation/commands/interview.md` exists with valid frontmatter
- References research findings as a required input (not optional)
- References captured input as a required input
- Documents recommendation requirement (agent advises, not just asks)
- Documents tradeoff explanation requirement
- AskUserQuestion usage pattern noted (max 4 options, Recommended label)
- Git commit step present at end of phase

---
<!-- Everything below this line is append-only and chronological -->

## Work Log 2026-03-22T00:00:00Z

- Read ticket, SKILL.md, capture.md (AskUserQuestion reference), and critic.md persona
- Created `skills/ideation/commands/interview.md` with 6 phases: Load Context, Identify Gaps, Interview, Record Answers, Git Commit, Report
- Frontmatter: `model: claude-sonnet-4-6`, `allowed-tools: Read, Grep, Glob, Bash, Write, Edit, AskUserQuestion`
- Personas section references `../../kanban/personas/critic.md` (Arden) as primary; designer and strategist as optional
- DO/DO NOT section enforces read-both-files-first, mandatory recommendations, tradeoff explanations, 5–7 question cap
- Phase 2 (Identify Gaps) defines explicit skip criteria for questions already answered by input or research
- Phase 3 (Interview) documents AskUserQuestion pattern: max 4 options, first = recommended, marked `(Recommended)`
- Phase 4 (Record Answers) appends `## Interview YYYYMMDD-HH:MM` block to `00-input-{subject}.md` (append-only)
- Phase 5 (Git Commit) commits `00-input-{subject}.md` with `kanban(interview): record interview answers for {subject}`
- All 9 acceptance criteria verified PASS
