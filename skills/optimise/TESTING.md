# Testing — Optimise

## Strategy

Run the skill against `skills/british-english/` (the smallest skill directory in the repo) to keep iteration cost low. Each run mode is tested in isolation; auto mode is run last as it modifies files and must be run against a clean copy.

## Environment Setup

1. The target for all scenarios is: `/Users/adjmunro/Developer/agentfiles/skills/british-english/`
2. For auto mode and multi-run scenarios, first copy the target to `/tmp/optimise-test/british-english/` to avoid modifying the live skill during testing.
3. Verify that `/Users/adjmunro/Developer/agentfiles/skills/optimise/commands/phases/` contains the expected phase files (`p1-audit.md`, `p2-baseline.md`, `p3-hypothesize.md`, `p4-experiments.md`, `p5-report.md`) before starting.
4. No prior `research-log.md` entries should reference `british-english` — check before the first run.

## Core Scenarios

| Scenario | Input | Expected Outcome | Status |
|----------|-------|-----------------|--------|
| Single run — 5-phase output | `/optimise skills/british-english/` | All 5 phases complete; composite score produced; at least one hypothesis generated | Untested |
| N runs — 3 iterations | `/optimise 3 /tmp/optimise-test/british-english/` | Exactly 3 experiment iterations run; hypothesis IDs are continuous across runs (H1, H2, H3 rather than restarting) | Untested |
| Auto mode — loop to threshold | `/optimise auto /tmp/optimise-test/british-english/` | Skill loops until composite score exceeds 95% or no further hypotheses remain; stops automatically | Untested |
| Help command — metric list | `/optimise help` | Lists all metrics (M1–M15) and all patterns (P1–P14) with short descriptions; no file writes | Untested |
| Help detail — single metric | `/optimise help M2` | Shows the full definition and scoring criteria for metric M2 only; no file writes | Untested |
| Self-audit — gap fill below 80% | Single run against a target where at least one metric scores below 80% | Phase 3 self-audit generates a hypothesis to fill the gap even if no prior hypothesis covers it | Untested |

## Command Coverage

| Command file | Covered by scenario |
|--------------|---------------------|
| `commands/optimise.md` (orchestrator) | All run scenarios |
| `commands/phases/p1-audit.md` | Single run, N runs, Auto mode |
| `commands/phases/p2-baseline.md` | Single run, N runs, Auto mode |
| `commands/phases/p3-hypothesize.md` | Single run, N runs, Auto mode, Self-audit |
| `commands/phases/p4-experiments.md` | Single run, N runs, Auto mode |
| `commands/phases/p5-report.md` | Single run, N runs, Auto mode |
| `commands/help.md` | Help command, Help detail |

## Known Issues

_(None recorded yet — append as issues are found and fixed.)_

## Refinement Log

_(Empty — append after each test run with what was learned, what changed, and the date.)_
