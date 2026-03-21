# 260321-pr-trunk-skip

## What

the kanban pull request stage should also be skipped if the current branch is the trunk.

main/master/develop if it's any of those, it's fine to not do a PR (unless they are protected branches on remote) - check remote if in doubt.

## Why

If you're already on the trunk branch, raising a PR against it doesn't make sense — you'd be opening a PR from main into main (or equivalent). The PR stage should be bypassed the same way it is for non-GitHub repos.

## Constraints

- Trunk branch names that trigger skip: `main`, `master`, `develop`
- Exception: if any of those branches are protected on the remote, do NOT skip — raise a PR as normal
- Check remote branch protection if in doubt (i.e. if the branch name matches but protection status is uncertain)
- Behaviour should mirror the existing non-GitHub skip path: once all tickets are in `05-pull-request/`, go straight to `/kanban-cleanup`

## Assets

- `skills/kanban/SKILL.md` — state machine docs; non-GitHub skip path is documented here
- `skills/kanban/commands/pr.md` — the PR command where the skip logic lands
- `skills/kanban/commands/cleanup.md` — the target when PR is skipped
