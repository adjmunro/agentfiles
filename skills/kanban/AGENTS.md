# Kanban Skill

## Git Commits

Use **conventional commits** for all changes:

```
feat(scope): short description
fix(scope): short description
refactor(scope): short description
docs(scope): short description
chore(scope): short description
```

The commit body should be generated automatically — list what changed, why it matters, and any non-obvious implications. Keep the subject line under 72 characters.

Examples:
- `feat(kanban): add review command with pass/fail routing`
- `fix(kanban): correct status field in next.md dependency check`
- `refactor(kanban): consolidate capture and plan session guards`

**Never force push.** There are no exceptions.

---

## Moving Tickets

Always use `mv` to move ticket files between stage directories. Never `rm` + recreate.

```bash
mv .kanban/02-todo/<subject>/TASK-NNN-<subject>.md .kanban/03-in-progress/<subject>/
```

The ticket file is the audit trail — deleting and recreating it loses history.

---

## Versioning

**Version bumps and changelog updates are NEVER kanban tickets.** Do not create TASK-NNN entries for version bumps or changelog entries — the correct version number is unknowable at ticket-creation time and will be wrong by implementation. Version and changelog updates happen automatically as part of implementation commits, not as planned work items.

**Only bump the version when changes are scoped to `skills/kanban/`.** If a commit touches other parts of the repo but not this skill, do not bump the kanban version.

Before committing any kanban changes, bump the version in `VERSION.md`:

```
**Current version**: X.Y.Z
```

Use semver:
- Patch (1.0.0 → 1.0.1): Bug fixes, typos, minor corrections
- Minor (1.0.0 → 1.1.0): New features, behaviour changes
- Major (1.0.0 → 2.0.0): Breaking changes

When in doubt, bump the patch version.

**Immediately after bumping the version, update `CHANGELOG.md`.**

---

## Changelog

Add a new entry at the top of the file (below the header):

```markdown
## X.Y.Z — The [Fun Two-Word Name] (YYYY-MM-DD)

[1-2 sentences. Casual, clear, and concise. What changed and why it matters.]

- [Bullet points for specifics — what was added, changed, or fixed]
```

Rules:
- **Newest on top.** File reads newest-to-oldest.
- **Give every version a name.** Short, fun — two or three words max.
- **Date every entry.** Format: `(YYYY-MM-DD)`, today's date.
- **Lead with the value.** What does the user get? Not which files changed.
- **Keep it brief.** One short paragraph + a few bullets. Over 5 bullets means you're over-explaining.
- **Match the voice.** Conversational, not corporate. No jargon walls.
- **Every version gets an entry.** No skipping. Even a patch fix deserves a line.
