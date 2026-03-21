## Intent

`YYMMDD` date prefixes are ambiguous and require mental parsing. Replacing them with ISO 8601 `YYYY-MM-DD` throughout the kanban system makes directories self-documenting, sortable, and consistent with standard tooling. This is a full rename — existing directories, file content, command templates, and documentation all change. No exceptions, including the `date-format` subject itself.

## Requirements

### 1. Directory renames

1.1 All `.kanban/` stage subdirectories with `YYMMDD-<subject>` prefixes are renamed to `YYYY-MM-DD-<subject>` (e.g. `260321-capture-flow` → `2026-03-21-capture-flow`).

1.2 The `date-format` subject directory is included in the rename: `260321-date-format` → `2026-03-21-date-format`.

### 2. Ticket file frontmatter

2.1 The `id:` field in all ticket files updated from `"YYMMDD-<subject>/TASK-NNN"` to `"YYYY-MM-DD-<subject>/TASK-NNN"`.

2.2 The `subject:` field in all ticket files updated from `"YYMMDD-<subject>"` to `"YYYY-MM-DD-<subject>"`.

2.3 The `plan:` relative path in all ticket files updated to reflect the renamed directory paths.

### 3. Internal file content

3.1 `# YYMMDD-<subject>` title lines in all input files updated to `# YYYY-MM-DD-<subject>`.

3.2 `## Research: YYMMDD-<subject>` header lines in all research files updated to `## Research: YYYY-MM-DD-<subject>`.

3.3 All other internal cross-references in plan, research, and input files updated to use new directory paths.

### 4. Command files

4.1 All occurrences of `YYMMDD` in all 9 command files (`capture.md`, `plan.md`, `todo.md`, `work.md`, `review.md`, `pr.md`, `cleanup.md`, `next.md`, `init.md`) replaced with `YYYY-MM-DD`.

4.2 The `date +%y%m%d` bash command template replaced with `date +%Y-%m-%d` in every command file where it appears.

4.3 All example subject slugs and subject patterns in command files updated to use the new format.

### 5. Documentation

5.1 `SKILL.md` directory structure diagram updated to show `YYYY-MM-DD-<subject>/` instead of `YYMMDD-<subject>/`.

5.2 All other occurrences of `YYMMDD` in `SKILL.md` or any other documentation files updated.

### 6. Going-forward conventions

6.1 Commit message templates in command files updated to reference `YYYY-MM-DD-<subject>` format (e.g. `kanban(capture): capture raw input for YYYY-MM-DD-<subject>`).

## Constraints

- Use `mv` to rename directories — never delete and recreate (ticket files are audit trails).
- Historical git commit messages are immutable — do not attempt to rewrite them.
- All renames must be staged and committed atomically per logical unit (directories + content together).

## Out of Scope

- `TASK-NNN` ticket naming convention — not date-prefixed, unchanged.
- Historical git commit messages.
- Changes to any non-kanban files.
