## Verification Checklist — pr-trunk-skip

Written before any edits to `pr.md` or `SKILL.md`. Each item is falsifiable by reading the final implementation.

---

### 1. Trunk Detection

- [ ] **1.1** `pr.md` contains a step — before Phase 1 — that reads the current branch name and compares it against a fixed list.
- [ ] **1.2** The fixed list is exactly four names: `main`, `master`, `develop`, `trunk`. No more, no fewer.
- [ ] **1.3** The check runs at the start of `pr.md`, before Phase 1 (draft PR creation) begins.
- [ ] **1.4** The branch list is not described as configurable. It is hardcoded prose.

---

### 2. Remote Protection Check

- [ ] **2.1** When a trunk branch is detected, `pr.md` instructs querying remote branch protection using exactly:
  ```
  gh api repos/{owner}/{repo}/branches/{branch}/protection
  ```
- [ ] **2.2** The `{owner}/{repo}` values are derived from the git remote — not hardcoded.
- [ ] **2.3** The command uses `gh api` only. No other method (curl, REST URL, GraphQL) is described.

---

### 3. Three-Way Outcome

- [ ] **3.1** **Protected branch:** `pr.md` states that if the API confirms the branch is protected, the trunk check is bypassed and the command continues to Phase 1 normally.
- [ ] **3.2** **Unprotected branch:** `pr.md` states that a `404` or explicit "not protected" response means the branch is unprotected — proceed to the skip path (see §4).
- [ ] **3.3** **Non-GitHub remote:** `pr.md` states that if `gh` is unavailable or the remote URL is not `github.com`, treat this equivalently to unprotected — proceed to the skip path.
- [ ] **3.4** **Check failure:** `pr.md` states that any other error (network failure, auth error, unexpected API error) causes the command to STOP and ask the user explicitly whether to skip the PR or raise one, before doing anything further.
- [ ] **3.5** The three outcomes are mutually exclusive and exhaustive — no uncovered case remains.

---

### 4. Skip Path

- [ ] **4.1** When the skip path is taken, `pr.md` instructs making a git commit with this message (or equivalent documented form):
  ```
  kanban(pr): skip PR — trunk branch unprotected for YYMMDD-<subject>
  ```
  The message must include a clear indication that the PR was skipped and the reason.
- [ ] **4.2** After the skip commit, `pr.md` instructs the agent to proceed directly to `/kanban-cleanup` — the same handoff used on the non-GitHub path.
- [ ] **4.3** The skip path does NOT create a draft PR, does NOT enter the polling loop, and does NOT run the Phase 4 pre-flight checklist.
- [ ] **4.4** Tickets in `05-pull-request/` are left for `kanban-cleanup` to handle — the skip path does not move or archive them.

---

### 5. SKILL.md Documentation

- [ ] **5.1** `SKILL.md` state machine note documents **two** PR bypass conditions, not one.
- [ ] **5.2** The first bypass condition is the existing one: non-GitHub repos skip the PR step.
- [ ] **5.3** The second bypass condition is new: trunk branches (main, master, develop, trunk) skip the PR step when confirmed unprotected.
- [ ] **5.4** The protection-check caveat is noted — specifically that a failed check stops and asks the user rather than assuming.
- [ ] **5.5** The two bypass conditions appear in the same section of `SKILL.md` (the state machine note or equivalent).

---

### 6. Scope Constraints

- [ ] **6.1** `kanban-next.md` (or any equivalent orchestrator command) is NOT modified.
- [ ] **6.2** No command file other than `pr.md` and `SKILL.md` is modified.
- [ ] **6.3** No configuration file or per-repo trunk list mechanism is introduced.

---

### Coverage Summary

| Plan Req | Checklist Items |
|----------|----------------|
| 1.1 Detect trunk at start of kanban-pr | 1.1, 1.3 |
| 1.2 Fixed list: main/master/develop/trunk | 1.2, 1.4 |
| 2.1 gh api protection check | 2.1, 2.2, 2.3 |
| 2.2 Unprotected / non-GitHub → skip | 3.2, 3.3 |
| 2.3 Protected → normal PR flow | 3.1 |
| 2.4 Check fails → stop and ask | 3.4 |
| 3.1 Skip mirrors non-GitHub path → cleanup | 4.1, 4.2, 4.3 |
| 3.2 Logic in kanban-pr only | 6.1, 6.2 |
| 4.1 SKILL.md two bypass conditions | 5.1–5.5 |
