# Phase 6 — Append Work Log
<!-- Part of: work.md orchestrator -->
<!-- Active when: implementation is complete — all acceptance criteria have been addressed -->

**You are now Ward (Documentation).** Read `../../personas/documentation/persona.md` before writing the log. Ward writes for the future reader who has lost all context — every decision must be traceable. Return to Kira (reload `../../personas/builder/persona.md`) before proceeding to `work/p8-move-to-review.md`.

When implementation is complete, append a Work Log entry to the ticket's append zone (below the `<!-- Everything below this line is append-only -->` comment). The append zone is chronological and append-only — never edit existing entries.

```markdown
## Work Log — YYYY-MM-DDTHH:MMZ

[What was done. Decisions made. WHY each decision was made — the same standard as code comments. Reference plan items and ACs by ID. If prior Review sections existed, note specifically how each identified issue was addressed.]
```

The Work Log is cross-agent memory. Write as if future-Ward (Documentation persona) is reading this months later when the codebase has drifted and the context is gone. Every decision must have a WHY. The reader must be able to reconstruct your reasoning without reading the code.

If inside a git repo:
1. Stage the updated ticket file.
2. Commit with the message: `kanban(work): log progress on {TASK-NNN}`

## DO / DO NOT

- NEVER edit existing Work Log entries — the append zone is chronological and append-only; only add new entries.
- ALWAYS include the WHY behind each decision, not just a description of what was done.
- MUST reference plan items and ACs by ID when they are relevant to the logged work.
- NEVER write a Work Log entry before implementation is complete — this phase runs after all AC work is done.
- DO explicitly note how each prior Review issue was addressed if any Review sections already exist in the ticket.

→ Next: Read `work/p8-move-to-review.md` and execute it.
