## 1.0.0 — First Release (2026-04-08)

Migrated from `skills/git-career-log/` to `prompts/git-career-log/` — this is a one-shot workflow that reads local git history and writes an output file, making it a better fit for the prompt type than a recurring slash command skill.

- Full career log generation workflow: author identity, PR extraction, type tagging, monthly grouping
- Python post-processing script for chronological ordering and stats injection
- Edge case handling for misconfigured credentials, dependabot PRs, and unmerged branches
