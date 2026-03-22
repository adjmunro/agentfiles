# Optimise Skill

## Git Commits

Use **conventional commits** for all changes:

```
feat(scope): short description
fix(scope): short description
refactor(scope): short description
docs(scope): short description
chore(scope): short description
```

The commit body should be generated — describe what changed, why, and any non-obvious
side effects. Keep the subject line under 72 characters.

Common scopes: `optimise`, `commands`, `skills`

Examples:
- `feat(optimise): add M13 metric for dependency graph coverage`
- `fix(optimise): correct HTC normalisation cap in scoring reference`
- `refactor(optimise): split experiment loop into per-hypothesis phases`

**Never force push.** This is a hard rule with no exceptions.

---

## Versioning

**Only bump the version when changes are scoped to `skills/optimise/`.** If a commit
touches other parts of the repo but not this skill, do not bump the optimise version.

Before committing any optimise changes, bump the version in `VERSION.md`:

```
1.X.Y
```

Use semver:
- Patch (1.0.0 → 1.0.1): Bug fixes, typos, minor corrections
- Minor (1.0.0 → 1.1.0): New features, new metrics, behaviour changes
- Major (1.0.0 → 2.0.0): Breaking changes to the loop structure or scoring model

When in doubt, bump the patch version.

**Immediately after bumping the version, update `CHANGELOG.md`.**

---

## Changelog

Add a new entry at the top of the file (below the header):

```markdown
## X.Y.Z — YYYY-MM-DD

### Added / Changed / Fixed
- bullet points
```

Rules:
- **Newest on top.** File reads newest-to-oldest.
- **Date every entry.** Format: `YYYY-MM-DD`.
- **Every version gets an entry.** No skipping.
