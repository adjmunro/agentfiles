# tighten — Agent Instructions

## Versioning

This skill uses semantic versioning in `VERSION.md`.

- **Patch** (`x.x.N`): additions to the rule tables or audit checks
- **Minor** (`x.N.0`): new rule categories, new file-type support, new flags
- **Major** (`N.0.0`): breaking changes to behaviour or output format

Only bump the version when changes are scoped to `skills/tighten/`.

## Conventional Commits

Use conventional commits for all changes to this skill:

```
feat(tighten): short description
fix(tighten): short description
refactor(tighten): short description
docs(tighten): short description
chore(tighten): short description
```

**Never force push.**

## Changelog

Keep `CHANGELOG.md` up to date. Most recent version at the top.
