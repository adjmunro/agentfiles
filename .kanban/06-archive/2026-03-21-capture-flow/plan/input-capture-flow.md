# 2026-03-21-capture-flow

## What

i don't like how capture immediately asks me multi-choice questions before i even get my first input in. i think the initial state should let me free-write and then we interview based on that

it should let me type free-form first and then do the multi-choice questionaire to clarify non-obvious things similar to the /interview command that first reads a file and then asks poinient questions. also, during the interview stage, i'd be great if you can output a little summary of your thoughts, your recommendation, and why.

just let me write something first. then read that, then ask me questions.

yes, based on your own advice & research

## Why

The current capture flow jumps straight to a structured multi-choice question before the user has had a chance to describe what they're working on. This feels premature — the user hasn't established context yet, so the questions can't be well-targeted.

## Constraints

- Minimal framing before the free-write prompt (a short line like "What are you working on?" — just enough to orient, not a form)
- No hard cap on follow-up questions — run until the picture is complete
- Each follow-up question must be preceded by: agent's interpretation of what was written, its recommendation, and the reasoning behind it — sourced from the agent's own analysis and research
- Flow similarity to `/interview`: read what the user wrote first, then ask pointed questions based on it
- The free-write input replaces the current opening multi-choice question entirely

## Assets

- `skills/kanban/commands/capture.md` — current capture command (Phase 4 is where the change lands)
- `/interview` command — referenced as the model for read-first, ask-second flow
