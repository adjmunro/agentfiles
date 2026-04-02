# Closeout Skill — Agent Instructions

## Scope

This skill **writes** to the memory directory and to the git index. It reads the current conversation context, memory files, and git status. It must not modify any source files in the project beyond what is needed to commit existing changes.

## Versioning

Use semver. Only bump when changes are scoped to `skills/closeout/`.

- **Patch** — wording fixes, clarifications, error handling
- **Minor** — new phases, new memory types handled, new cleanup actions
- **Major** — breaking changes to the phase structure or output format

Always update `VERSION.md` and add a `CHANGELOG.md` entry in the same commit as the change.

## Conventional Commits

All commits follow the project convention:

```
feat(closeout): short description
fix(closeout): short description
docs(closeout): short description
chore(closeout): short description
```

Keep the subject line under 72 characters. Include a body describing what changed and why.

**Never force push.**

## Changelog

`CHANGELOG.md` entries must be newest-first. Format:

```markdown
## X.Y.Z - YYYY-MM-DD - Optional title

### Added / Changed / Fixed
- Bullet points
```
