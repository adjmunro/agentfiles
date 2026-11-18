#!/bin/sh
# Survey before (or during) a rebase. Changes no refs, index or working tree, and does not fetch.
# Usage: preflight.sh [<target>]
# Prints facts as "key: value" lines plus short listings; interpretation is left to the caller.
# During a rebase, the survey compares the original tip with the rebase's onto commit.

target=${1:-}
say() { printf '%s: %s\n' "$1" "$2"; }
tmp=${TMPDIR:-/tmp}/preflight.$$
trap 'rm -f "$tmp".*' EXIT

git rev-parse --git-dir >/dev/null 2>&1 || { echo "error: not inside a git repository" >&2; exit 2; }
gitdir=$(git rev-parse --git-dir)

say git-version "$(git --version | sed 's/^git version //')"

branch=$(git symbolic-ref --short -q HEAD || true)
tip=HEAD

op=none
rdir=
[ -d "$gitdir/rebase-merge" ] && rdir=$gitdir/rebase-merge
[ -d "$gitdir/rebase-apply" ] && rdir=$gitdir/rebase-apply
[ -n "$rdir" ] && op=rebase
[ -f "$gitdir/MERGE_HEAD" ] && op=merge
[ -f "$gitdir/CHERRY_PICK_HEAD" ] && [ -z "$rdir" ] && op=cherry-pick
[ -f "$gitdir/REVERT_HEAD" ] && op=revert
[ -f "$gitdir/BISECT_LOG" ] && op=bisect
say operation-in-progress "$op"

if [ -n "$rdir" ]; then
  branch=$(sed 's#^refs/heads/##' "$rdir/head-name" 2>/dev/null)
  tip=$(cat "$rdir/orig-head" 2>/dev/null)
  onto=$(cat "$rdir/onto" 2>/dev/null)
  say branch "$branch (rebase in progress)"
  say rebase.orig-head "$tip"
  say rebase.onto "$onto"
  if [ -f "$rdir/done" ]; then
    first=$(awk '$1 ~ /^(pick|p|edit|e|reword|r|squash|s|fixup|f|drop|d)$/ {print $2; exit}' "$rdir/done")
    [ -n "$first" ] && say rebase.old-base-guess "$(git rev-parse "$first^" 2>/dev/null) (parent of the first replayed commit; wrong if the todo was reordered or uses --rebase-merges)"
    edits=$(cat "$rdir/done" "$rdir/git-rebase-todo" 2>/dev/null | grep -vE '^(#|$)' | grep -cvE '^(pick|p) ' || true)
    say rebase.non-pick-todo-lines "$edits (drops, rewords, execs, breaks, merges: the user may have edited the plan)"
    echo "rebase.todo-remaining:"; grep -vE '^(#|$)' "$rdir/git-rebase-todo" 2>/dev/null | sed 's/^/  /'
  fi
  say rebase.stopped-at "$(git log -1 --format='%h %s' REBASE_HEAD 2>/dev/null)"
  echo "conflicted:"; git diff --name-only --diff-filter=U | sed 's/^/  /'
  [ -z "$target" ] && target=$onto
else
  say branch "${branch:-<detached or unborn HEAD>}"
  say uncommitted-tracked-changes "$(git status --porcelain --untracked-files=no | wc -l | tr -d ' ')"
  say untracked-files "$(git status --porcelain | grep -c '^??' || true)"
  say ignored-files-present "$(git status --porcelain --ignored | grep -c '^!!' || true) (note these; leave the tree as you found it)"
fi
say stash-entries "$(git stash list | wc -l | tr -d ' ')"

# Config that changes how a rebase behaves in this repo
for k in rebase.updateRefs rebase.autoStash rebase.autoSquash merge.conflictStyle rerere.enabled \
         commit.gpgSign core.editor sequence.editor core.hooksPath; do
  v=$(git config --get "$k" 2>/dev/null) && say "config.$k" "$v"
done
[ -n "${GIT_EDITOR:-}" ] && say env.GIT_EDITOR "$GIT_EDITOR"

# Stacking tools
if command -v gt >/dev/null 2>&1 && [ -n "$branch" ]; then
  if info=$(gt branch info "$branch" --no-interactive 2>/dev/null); then
    say graphite "tracked parent=$(echo "$info" | sed -n 's/^Parent: *//p' | head -1)"
  else
    say graphite "not tracked"
  fi
fi
if command -v gh >/dev/null 2>&1 && gh extension list 2>/dev/null | grep -q 'gh-stack'; then
  if gh stack view --json >/dev/null 2>&1; then say gh-stack "in a stack"; else say gh-stack "not in a stack"; fi
fi

# Upstream of the branch (push/share state)
if [ -n "$branch" ]; then
  up=$(git rev-parse --abbrev-ref --symbolic-full-name "$branch@{upstream}" 2>/dev/null || true)
  if [ -n "$up" ]; then
    say upstream "$up ($(git rev-list --left-right --count "$up"..."$tip" | awk '{print "behind " $1 ", ahead " $2}'))"
  else
    say upstream none
  fi
fi

[ -z "$target" ] && { say target "<not given>"; say default-branch "$(git symbolic-ref --short -q refs/remotes/origin/HEAD 2>/dev/null || echo unknown)"; exit 0; }

if ! git rev-parse --verify -q "$target^{commit}" >/dev/null; then
  say target "$target (does not resolve)"; exit 1
fi
say target "$target -> $(git rev-parse --short "$target")"

# Is the local target stale relative to its own upstream? (as of the last fetch)
behind=0
tup=$(git rev-parse --abbrev-ref --symbolic-full-name "$target@{upstream}" 2>/dev/null || true)
if [ -n "$tup" ]; then
  counts=$(git rev-list --left-right --count "$tup"..."$target")
  behind=${counts%%[!0-9]*}
  fetched=$(stat -c %y "$gitdir/FETCH_HEAD" 2>/dev/null || stat -f %Sm "$gitdir/FETCH_HEAD" 2>/dev/null || echo never)
  say target-vs-its-upstream "$tup ($(echo "$counts" | awk '{print "behind " $1 ", ahead " $2}'); last fetch: $fetched)"
else
  say target-vs-its-upstream none
fi

mb=$(git merge-base "$tip" "$target" 2>/dev/null || true)
say merge-base "${mb:-<none: unrelated histories>}"
[ -z "$mb" ] && exit 1
say counts "$(git rev-list --left-right --count "$target"..."$tip" | awk '{print "target has " $1 " new, branch has " $2 " to replay"}')"
if git merge-base --is-ancestor "$target" "$tip"; then
  if [ "$behind" -gt 0 ]; then say already-on-target "yes, but $target is behind $tup"; else say already-on-target yes; fi
fi

echo "commits-to-replay (oldest first; = means patch already upstream, git will drop it):"
git log --reverse --cherry-mark --right-only --no-merges --format='  %m %h %aN | %s' "$target"..."$tip"
merges=$(git rev-list --merges --count "$target".."$tip")
[ "$merges" -gt 0 ] && say merge-commits-in-range "$merges (plain rebase flattens them; --rebase-merges keeps them)"

# %aE/%aN honour .mailmap. Only user.email is compared, so other addresses of yours show up here too.
me=$(git config user.email || true)
foreign=$(git log --format='%aE %aN' "$target".."$tip" | awk -v me="$me" '$1 != me {sub(/^[^ ]+ /, ""); print}' | sort | uniq -c | sed 's/^ *//' | paste -sd, - | sed 's/,/, /g')
say commits-not-by-you "${foreign:-none}"

fix=$(git log --format=%s "$target".."$tip" | grep -cE '^(fixup|squash|amend)! ' || true)
[ "$fix" -gt 0 ] && say autosquash-commits-in-range "$fix (rebase.autoSquash=$(git config --get rebase.autoSquash || echo false); true folds them in)"

echo "possibly-already-upstream (a target commit message mentions this subject; check for a squash merge):"
git log --format=%B "$mb".."$target" > "$tmp.m"
git log --reverse --format='%h %s' "$target".."$tip" | while IFS= read -r line; do
  grep -qF -- "${line#* }" "$tmp.m" && echo "  $line"
done

echo "other-local-branches-inside-range (would move with --update-refs; possible stack):"
git for-each-ref --format='%(refname:short)' --merged "$tip" --no-merged "$target" refs/heads \
  | grep -vxF "$branch" | sed 's/^/  /'

echo "files-changed-on-both-sides (likely conflict sites):"
# the target side lists old and new names of renames, so a rename there still matches the branch's path
git diff --name-status -M "$mb" "$target" | awk -F'\t' '{for (i = 2; i <= NF; i++) print $i}' | sort -u > "$tmp.a"
git diff --name-only "$mb" "$tip" | sort > "$tmp.b"
comm -12 "$tmp.a" "$tmp.b" > "$tmp.c"
sed 's/^/  /' "$tmp.c"
echo "target-commits-touching-those-files (read their full messages; they explain the other side):"
[ -s "$tmp.c" ] && tr '\n' '\0' < "$tmp.c" | xargs -0 git log --format='  %h %aN | %s' "$mb".."$target" --

echo "renames-and-deletes-on-target-since-merge-base:"
git diff --name-status -M --diff-filter=RD "$mb" "$target" | sed 's/^/  /'
