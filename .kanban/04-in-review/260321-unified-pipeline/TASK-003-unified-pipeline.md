---
id: "260321-unified-pipeline/TASK-003"
subject: "260321-unified-pipeline"
plan: "../../01-plan/260321-unified-pipeline/plan-unified-pipeline.md"
effort: medium
status: in_review
created_at: "2026-03-22T00:00:00Z"
claimed_at: "2026-03-22T00:00:00Z"
completed_at: ~
stale_after_hours: 4
depends_on:
  - "TASK-002"
spawned_tickets: []
plan_items:
  - "Req 2.3 Step 1 — Capture: transcribe user input verbatim into 00-input-{subject}.md; assets go in 00-assets/"
  - "Req 2.6 — loop-back appends a new session block; prior content immutable"
  - "Req 4.1 — verbatim transcription: zero paraphrasing, zero summarising"
  - "Req 4.1 — git commit after phase completes"
acceptance_criteria:
  - "[ -f skills/ideation/commands/capture.md ] — file exists"
  - "grep -q 'model:' skills/ideation/commands/capture.md — frontmatter has model field"
  - "grep -q 'allowed-tools:' skills/ideation/commands/capture.md — frontmatter has allowed-tools"
  - "grep -q 'argument-hint:' skills/ideation/commands/capture.md — frontmatter has argument-hint"
  - "grep -qi '00-input' skills/ideation/commands/capture.md — references 00-input-{subject}.md output file"
  - "grep -qi '00-assets' skills/ideation/commands/capture.md — references 00-assets/ for asset storage"
  - "grep -qi 'verbatim' skills/ideation/commands/capture.md — verbatim rule documented"
  - "grep -qi 'append' skills/ideation/commands/capture.md — loop-back append rule present (never overwrite)"
  - "grep -qi 'session' skills/ideation/commands/capture.md — session block structure referenced"
  - "grep -qi 'git' skills/ideation/commands/capture.md — git commit step present"
consecutive_failures: 0
---

## Context

Writes `skills/ideation/commands/capture.md` — Step 1 of the ideation flow. This phase receives raw user input and transcribes it verbatim into `00-input-{subject}.md` inside the subject directory. Assets (screenshots, links, docs) are placed in `00-assets/`. On loop-back, a new session block is appended — prior session content is immutable.

Command model: `claude-opus-4-6` (heavy transcription and user interaction). Follows all carry-forward patterns from plan §4.1.

## Acceptance Criteria

- `skills/ideation/commands/capture.md` exists with valid frontmatter (`model`, `allowed-tools`, `argument-hint`)
- References `00-input-{subject}.md` as the output file
- References `00-assets/` for asset placement
- Documents verbatim transcription rule (no paraphrasing, no summarising)
- Loop-back behaviour documented: append new session block, never overwrite
- Git commit step present at end of phase

---
<!-- Everything below this line is append-only and chronological -->

## Work Log — 2026-03-22T00:00:00Z

Implemented `skills/ideation/commands/capture.md` — Step 1 of the ideation flow.

**What was built**: A 7-phase command file (Session Check → Capture → Assets → Session Block → Critic Pass → Git Commit → Report) following the kanban `capture.md` structure. Key differences from kanban v1's capture: subject directory uses the new `YYYY-MM-DD-{subject}/` layout, output file is `00-input-{subject}.md`, assets go in `00-assets/`, and there is no interview phase — capture is pure verbatim transcription followed immediately by a Critic gap scan.

**All 10 ACs verified**: file exists, frontmatter fields (`model`, `allowed-tools`, `argument-hint`) present, `00-input` and `00-assets` referenced, verbatim rule documented, append/loop-back rule present, session block structure documented, git commit step present.
