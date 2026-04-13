# Bump Dependencies Skill

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

Common scopes: `bump-deps`, `commands`, `skills`

Examples:
- `feat(bump-deps): add licence-change detection to Phase 2`
- `fix(bump-deps): correct version-range parsing for pre-release tags`
- `chore(bump-deps): add p0-bump phase for proactive discovery`

Bump commits made by this skill against the target repo follow the pattern:

```
chore(deps): bump <alias> from <old> to <new>
```

Remediation commits made by this skill against the target repo follow the pattern:

```
fix(deps): replace deprecated <api> with <replacement> after <package> bump
```

**Never force push.** This is a hard rule with no exceptions.

---

## Versioning

**Only bump the version when changes are scoped to `skills/bump-dependencies/`.**
If a commit touches other parts of the repo but not this skill, do not bump the version.

Before committing any changes to this skill, bump the version in `VERSION.md`:

```
1.X.Y
```

Use semver:
- Patch (1.0.0 → 1.0.1): Bug fixes, typos, minor corrections
- Minor (1.0.0 → 1.1.0): New features, new detection types, behaviour changes
- Major (1.0.0 → 2.0.0): Breaking changes to the pipeline structure or verdict format

When in doubt, bump the patch version.

**Immediately after bumping the version, update `CHANGELOG.md`.**

---

## Changelog

Add a new entry at the top of the file (below the header):

```markdown
## X.Y.Z — The [Fun Name] (YYYY-MM-DD)

[1–2 sentences describing what changed and why]

- Bullet point 1
- Bullet point 2
```

Rules:
- **Newest on top.** File reads newest-to-oldest.
- **Give every version a name.** Two-word fun names (e.g., "Security Lens").
- **Date every entry.** Format: `YYYY-MM-DD`.
- **Every version gets an entry.** No skipping.
- **Brief.** One paragraph + bullets; if >5 bullets, consolidate.
