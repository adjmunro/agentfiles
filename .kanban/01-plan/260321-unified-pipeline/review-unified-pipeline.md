---
title: "Review Checklist: 260321-unified-pipeline"
date: "2026-03-22T00:00:00Z"
threshold: 95%
---

## Review Checklist: 260321-unified-pipeline

This checklist is used during `/kanban-review` to verify that all deliverables from TASK-002 through TASK-015 meet specification. Each item is grep-verifiable.

### Ideation Scaffold Files

- [ ] **AC-001**: `grep -q "^# Agents" skills/ideation/AGENTS.md` — AGENTS.md exists and declares agents for ideation skill
- [ ] **AC-002**: `grep -q "VERSION" skills/ideation/VERSION.md` — VERSION.md exists with version number
- [ ] **AC-003**: `grep -q "CHANGELOG" skills/ideation/CHANGELOG.md` — CHANGELOG.md exists tracking ideation changes
- [ ] **AC-004**: `grep -q "ideation" skills/ideation/SKILL.md` — SKILL.md exists describing ideation skill purpose and structure

### Ideation Commands

- [ ] **AC-005**: `grep -q "step.*1" skills/ideation/commands/capture.md` — capture.md exists for Step 1 (verbatim transcription)
- [ ] **AC-006**: `grep -q "research" skills/ideation/commands/research.md` — research.md exists for Step 2 (web fetch and file scan)
- [ ] **AC-007**: `grep -q "interview" skills/ideation/commands/interview.md` — interview.md exists for Step 3 (research-informed questions)
- [ ] **AC-008**: `grep -q "plan" skills/ideation/commands/plan.md` — plan.md exists for Steps 4-5 (draft and critic audit)
- [ ] **AC-009**: `grep -q "tickets" skills/ideation/commands/tickets.md` — tickets.md exists for Steps 7-8 (draft into 03-refinement)
- [ ] **AC-010**: `grep -q "ideate" skills/ideation/commands/ideate.md` — ideate.md exists as orchestrator for 9-step loop

### Kanban2 Scaffold Files

- [ ] **AC-011**: `grep -q "^# Agents" skills/kanban2/AGENTS.md` — AGENTS.md exists and declares agents for kanban2 skill
- [ ] **AC-012**: `grep -q "VERSION" skills/kanban2/VERSION.md` — VERSION.md exists with version number
- [ ] **AC-013**: `grep -q "CHANGELOG" skills/kanban2/CHANGELOG.md` — CHANGELOG.md exists tracking kanban2 changes (inherited from v1)

### Kanban2 Commands

- [ ] **AC-014**: `grep -q "init" skills/kanban2/commands/init.md` — init.md exists for initializing work sessions
- [ ] **AC-015**: `grep -q "work" skills/kanban2/commands/work.md` — work.md exists for claiming and working on tickets
- [ ] **AC-016**: `grep -q "review" skills/kanban2/commands/review.md` — review.md exists for ticket review phase
- [ ] **AC-017**: `grep -q "pr" skills/kanban2/commands/pr.md` — pr.md exists for pull request creation
- [ ] **AC-018**: `grep -q "cleanup" skills/kanban2/commands/cleanup.md` — cleanup.md exists for cleanup phase
- [ ] **AC-019**: `grep -q "next" skills/kanban2/commands/next.md` — next.md exists as orchestrator for work loop

### Verification Commands

Run this to verify all acceptance criteria:

```bash
# Ideation Scaffold
grep -q "^# Agents" skills/ideation/AGENTS.md && echo "✓ AC-001" || echo "✗ AC-001"
grep -q "VERSION" skills/ideation/VERSION.md && echo "✓ AC-002" || echo "✗ AC-002"
grep -q "CHANGELOG" skills/ideation/CHANGELOG.md && echo "✓ AC-003" || echo "✗ AC-003"
grep -q "ideation" skills/ideation/SKILL.md && echo "✓ AC-004" || echo "✗ AC-004"

# Ideation Commands
grep -q "step.*1" skills/ideation/commands/capture.md && echo "✓ AC-005" || echo "✗ AC-005"
grep -q "research" skills/ideation/commands/research.md && echo "✓ AC-006" || echo "✗ AC-006"
grep -q "interview" skills/ideation/commands/interview.md && echo "✓ AC-007" || echo "✗ AC-007"
grep -q "plan" skills/ideation/commands/plan.md && echo "✓ AC-008" || echo "✗ AC-008"
grep -q "tickets" skills/ideation/commands/tickets.md && echo "✓ AC-009" || echo "✗ AC-009"
grep -q "ideate" skills/ideation/commands/ideate.md && echo "✓ AC-010" || echo "✗ AC-010"

# Kanban2 Scaffold
grep -q "^# Agents" skills/kanban2/AGENTS.md && echo "✓ AC-011" || echo "✗ AC-011"
grep -q "VERSION" skills/kanban2/VERSION.md && echo "✓ AC-012" || echo "✗ AC-012"
grep -q "CHANGELOG" skills/kanban2/CHANGELOG.md && echo "✓ AC-013" || echo "✗ AC-013"

# Kanban2 Commands
grep -q "init" skills/kanban2/commands/init.md && echo "✓ AC-014" || echo "✗ AC-014"
grep -q "work" skills/kanban2/commands/work.md && echo "✓ AC-015" || echo "✗ AC-015"
grep -q "review" skills/kanban2/commands/review.md && echo "✓ AC-016" || echo "✗ AC-016"
grep -q "pr" skills/kanban2/commands/pr.md && echo "✓ AC-017" || echo "✗ AC-017"
grep -q "cleanup" skills/kanban2/commands/cleanup.md && echo "✓ AC-018" || echo "✗ AC-018"
grep -q "next" skills/kanban2/commands/next.md && echo "✓ AC-019" || echo "✗ AC-019"
```

---

**Total Items**: 19 (exceeds minimum of 15)
**Status**: Ready for review during TASK-002 through TASK-015 implementation.
