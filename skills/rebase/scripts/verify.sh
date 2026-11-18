#!/bin/sh
# Compare a rebased branch against its pre-rebase backup. Changes no refs, index or working tree.
# Usage: verify.sh <backup> <onto> [<old-base>] [<new>]
#   backup    ref taken before the rebase (e.g. a backup tag)
#   onto      what the branch was rebased onto
#   old-base  the commit the replayed range started after; defaults to merge-base(backup, onto).
#             Pass it explicitly after `git rebase --onto <onto> <old-base>`.
#   new       rebased ref (default HEAD)
#
# Model: the rebase should produce the same tree as a three-way merge of <onto> and <backup>
# over <old-base>. Files git can merge cleanly must come out identical; only files that the
# model merge reports as conflicted may legitimately differ, plus any deliberate fixes.
#
# Exit: 0 identical to the clean model merge (nothing to review)
#       1 differs only in files the model merge could not resolve (review those resolutions)
#       2 differs in files the model merge resolved cleanly (each needs a stated reason)
#       3 hard failure (rebase in progress, markers left, onto not an ancestor, bad refs)

backup=${1:?usage: verify.sh <backup> <onto> [<old-base>] [<new>]}
onto=${2:?usage: verify.sh <backup> <onto> [<old-base>] [<new>]}
new=${4:-HEAD}
gitdir=$(git rev-parse --git-dir) || exit 3

for r in "$backup" "$onto" "$new"; do
  git rev-parse --verify -q "$r^{commit}" >/dev/null || { echo "FAIL: cannot resolve $r"; exit 3; }
done
base=${3:-$(git merge-base "$backup" "$onto")}
git rev-parse --verify -q "$base^{commit}" >/dev/null || { echo "FAIL: cannot resolve old-base $base"; exit 3; }

fail=0
if [ -d "$gitdir/rebase-merge" ] || [ -d "$gitdir/rebase-apply" ]; then
  echo "FAIL: a rebase is still in progress"; fail=1
fi
if ! git merge-base --is-ancestor "$onto" "$new"; then
  echo "FAIL: $onto is not an ancestor of $new"; fail=1
fi
markers=$(git diff "$onto" "$new" | grep -nE '^\+(<{7}|>{7}|\|{7})( |$)|^\+={7}$' || true)
if [ -n "$markers" ]; then
  echo "FAIL: conflict markers added relative to $onto:"; echo "$markers" | head -20; fail=1
fi
[ "$fail" -ne 0 ] && exit 3

mb=$(git merge-base "$backup" "$onto")
if [ "$(git rev-parse "$base")" != "$mb" ]; then
  echo "== commits excluded by old-base (the model trusts this boundary; justify it separately):"
  git log --oneline "$mb".."$base" | sed 's/^/  /'
fi
echo "== commits (backup: $(git rev-list --count "$base".."$backup"), rebased: $(git rev-list --count "$onto".."$new"))"
# Pairing is heuristic: '=' same patch, '!' changed, '<' only in backup (dropped), '>' only in rebased.
git range-diff --no-color --creation-factor=100 "$base".."$backup" "$onto".."$new" | grep -E '^ *[-0-9]+: '
git log --format=%s "$base".."$backup" | sort > "${TMPDIR:-/tmp}/vf.$$.a"
git log --format=%s "$onto".."$new" | sort > "${TMPDIR:-/tmp}/vf.$$.b"
dropped=$(comm -23 "${TMPDIR:-/tmp}/vf.$$.a" "${TMPDIR:-/tmp}/vf.$$.b")
added=$(comm -13 "${TMPDIR:-/tmp}/vf.$$.a" "${TMPDIR:-/tmp}/vf.$$.b")
rm -f "${TMPDIR:-/tmp}/vf.$$.a" "${TMPDIR:-/tmp}/vf.$$.b"
[ -n "$dropped" ] && { echo "subjects missing after rebase (dropped or reworded):"; echo "$dropped" | sed 's/^/  /'; }
[ -n "$added" ] && { echo "subjects new after rebase:"; echo "$added" | sed 's/^/  /'; }

echo "== tree vs model merge of $onto + $backup over $(git rev-parse --short "$base")"
out=$(git merge-tree --write-tree --name-only --no-messages --merge-base="$base" "$onto" "$backup")
rc=$?
[ "$rc" -gt 1 ] && { echo "FAIL: git merge-tree failed (needs git >= 2.40)"; exit 3; }
model=$(echo "$out" | head -1)
conflicted=$(echo "$out" | tail -n +2)
changed=$(git diff --name-only "$model" "$new")

if [ -z "$changed" ]; then
  echo "IDENTICAL to the model merge."; exit 0
fi

status=1
[ -n "$conflicted" ] && { echo "model-conflicted files (differences expected; review each resolution):"; echo "$conflicted" | sed 's/^/  /'; }
unexpected=$(echo "$changed" | grep -vxF "$conflicted" || true)
[ -z "$conflicted" ] && unexpected=$changed
if [ -n "$unexpected" ]; then
  status=2
  echo "DIFFERS where the model merge was clean (each needs a stated reason, e.g. a semantic-conflict fix):"
  git diff --name-status "$model" "$new" | while IFS= read -r line; do
    p=${line#*	}; echo "$unexpected" | grep -qxF "$p" && echo "  $line"
  done
fi
echo "inspect: git diff $model $new -- <path>"
exit $status
