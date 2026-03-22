# Install Skill

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

Common scopes: `install`, `commands`

Examples:
- `feat(install): add gradle-idea component with worktrees integration`
- `fix(install): correct symlinks idempotency check for AGENTS.md merge`
- `refactor(install): extract shared target-resolution logic into install.md`

**Never force push.** This is a hard rule with no exceptions.

---

## Versioning

**Only bump the version when changes are scoped to `skills/install/`.** If a commit
touches other parts of the repo but not this skill, do not bump the install version.

Before committing any install changes, bump the version in `VERSION.md`:

```
X.Y.Z
```

Use semver:
- Patch (1.0.0 → 1.0.1): Bug fixes, typos, minor corrections to existing components
- Minor (1.0.0 → 1.1.0): New components, new sub-operations, behaviour changes
- Major (1.0.0 → 2.0.0): Breaking changes to the component interface or target layout

When in doubt, bump the patch version.

**Immediately after bumping the version, update `CHANGELOG.md`.**

---

## Changelog

Add a new entry at the top of the file (below the header):

```markdown
## X.Y.Z — The Fun Name (YYYY-MM-DD)

[1–2 sentences. What changed and why it matters.]

- [Bullet points for specifics]
```

Rules:
- **Newest on top.** File reads newest-to-oldest.
- **Give every version a name.** Short, fun — two or three words max.
- **Date every entry.** Format: `(YYYY-MM-DD)`.
- **Lead with the value.** What does the user get?
- **Keep it brief.** One short paragraph + a few bullets max.
- **Every version gets an entry.** No skipping.
