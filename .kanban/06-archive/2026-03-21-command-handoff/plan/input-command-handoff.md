# 2026-03-21-command-handoff

## What

i want capture to end with y/n to move to planning mode

ask me if i want to enter planning mode, then invoke it inline unless i reply negatively. no reply counts as affirmative (maybe give me a hint 'yes' in my input box that i can press enter on directly?)

[Agent clarified: multi-option prompt, not just y/n; "yes" as recommended/default option]

End-of-capture prompt options (only shown on clean completion — no unresolved Critic gaps):
1. Enter planning mode now (invoke /kanban-plan inline, default/pre-selected so user can just hit Enter)
2. Capture something else (invoke a new /kanban-capture inline, same session — no context clearing possible programmatically)
3. Something else / freeform input — totally free form, could be a command like /clear, more content for the capture, etc.

i'd like similar options after plan - to clear context and/or go back to capture, or exit kanban. realisitically i'm probably running the todo/next flow in an adjacent session, not the capture one. but give me an option to jump straight into the next step too

[Agent clarified: "clear context" not possible programmatically, omitted; end-of-plan options below]

End-of-plan prompt (only shown on clean completion):
1. Start — /kanban-todo + /kanban-next (full work loop)
2. New — /kanban-todo + back to /kanban-capture (create tickets, then capture something new)
3. Quit — /kanban-todo + exit kanban (create tickets, stop there)
4. Something else — freeform input
5. Discard — confirmation dialogue to remove the entire subject: plan, research, input etc.

[Agent clarified: options 1–3 all run kanban-todo first; what differs is what happens after]

wait, don't auto invoke todo, in at the end of planning one of the options should be to do todo if i'm satisfied with the plan

[Agent flagged: options 1–3 cross the capture/plan → work session boundary. User chose to relax the rule at this specific handoff point, but it requires user confirmation before invoking kanban-todo inline]

1 - specifically, it requires user confirmation

forbid removing if tasks have already been created in 02-todo or above. describe the problem to the user. user must manually intervene (or explicitly tell claude to)

## Why

the current kanban workflow ends abruptly — each command stops and the user must manually invoke the next step. the user wants smoother transitions between pipeline stages, reducing friction and making it easier to stay in flow. realistically the todo/next flow often runs in an adjacent session, but having the option to continue inline is valuable.

## Constraints

- end-of-capture prompt only shown on clean completion (no unresolved Critic gaps)
- end-of-plan prompt only shown on clean completion
- session boundary (capture/plan vs. work) is relaxed only at the plan→todo handoff, and only with explicit user confirmation before crossing
- discard is blocked if any tickets exist in 02-todo through 06-archive for the subject; describe the problem to the user and require manual intervention or explicit instruction to Claude before proceeding
- "no reply" / pressing Enter defaults to the first/recommended option — use AskUserQuestion with recommended option listed first and labelled "(Recommended)"
- context cannot be programmatically cleared from within a command; "capture something else" runs a new capture inline without context clearing

## Assets

- existing capture command: `skills/kanban/commands/capture.md`
- existing plan command: `skills/kanban/commands/plan.md`
- session boundary rule documented in kanban overview: "Two sessions. Never mixed."
- AskUserQuestion tool supports "(Recommended)" label suffix and option ordering to signal default
