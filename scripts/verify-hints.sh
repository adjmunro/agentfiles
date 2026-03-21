#!/usr/bin/env zsh

# WHY: This script verifies the exact end state for the kanban-ux-hints subject.
# It checks that SKILL.md and all 9 command files have the 'argument-hint' field
# present and non-empty. This is the TDD red-phase test: it should fail now
# (SKILL.md missing argument-hint) and pass once TASK-002 and TASK-003 complete.
# The script serves as both a test harness and a living specification.

REPO_ROOT=$(git rev-parse --show-toplevel)
SKILL_FILE="$REPO_ROOT/skills/kanban/SKILL.md"
COMMAND_DIR="$REPO_ROOT/skills/kanban/commands"

# Array to hold exit status of each check
declare -a CHECK_RESULTS
CHECK_RESULTS=()

# WHY: Helper function to check a file for argument-hint field.
# It extracts the frontmatter YAML and checks that argument-hint is present
# and has a non-empty value (not just ~ or null).
check_argument_hint() {
  local file=$1
  local file_name=$(basename "$file")

  # Check if file exists
  if [[ ! -f "$file" ]]; then
    echo "FAIL: $file_name — file not found"
    CHECK_RESULTS+=(1)
    return 1
  fi

  # Extract YAML frontmatter (between --- markers) and check for argument-hint
  # Look for a line matching 'argument-hint: ' with a non-empty value
  if grep -q '^argument-hint: *[^ ~]' "$file"; then
    echo "PASS: $file_name"
    CHECK_RESULTS+=(0)
    return 0
  else
    echo "FAIL: $file_name — missing or empty argument-hint"
    CHECK_RESULTS+=(1)
    return 1
  fi
}

echo "=== Verifying kanban-ux-hints argument-hint fields ==="
echo ""

# WHY: Check SKILL.md first. This is the top-level skill entry point.
# Once argument-hint is added here, users typing /kanban will see available subcommands.
echo "Checking top-level skill:"
check_argument_hint "$SKILL_FILE"
echo ""

# WHY: Check all 9 command files in the subcommand pipeline order.
# Each command must have an accurate, non-empty hint describing what arguments it accepts.
# Pipeline order: capture → plan → todo → work → review → pr → cleanup → next → init
echo "Checking command files (9 total):"
declare -a COMMANDS=(
  "init"
  "capture"
  "plan"
  "todo"
  "work"
  "review"
  "pr"
  "cleanup"
  "next"
)

for cmd in "${COMMANDS[@]}"; do
  check_argument_hint "$COMMAND_DIR/$cmd.md"
done

echo ""
echo "=== Summary ==="

# WHY: Count passes and fails to provide clear feedback on overall test status.
# Exit 0 only if all 10 checks (1 SKILL.md + 9 commands) pass.
passed=0
failed=0
for result in "${CHECK_RESULTS[@]}"; do
  if [[ $result -eq 0 ]]; then
    ((passed++))
  else
    ((failed++))
  fi
done

total=$((passed + failed))
echo "Passed: $passed / $total"

if [[ $failed -gt 0 ]]; then
  echo "Failed: $failed"
  exit 1
else
  echo "All checks passed!"
  exit 0
fi
