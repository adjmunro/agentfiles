# OpenClaw Agent Innovations

Source: https://github.com/openclaw/openclaw + steipete.me blog posts
Researched: 2026-03-22

---

## Memory

### Two-layer memory with security scope
- `MEMORY.md` — curated long-term memory, loaded only in private sessions (never group chats)
- `memory/YYYY-MM-DD.md` — daily append-only log, accessed on-demand via tools (not injected automatically)

**Insight:** not all memory should be in context all the time. On-demand retrieval keeps the base context lean.

### Pre-compaction memory flush
Before context gets compacted, a **silent agentic turn** fires automatically, prompting the model to write anything important to disk. The model replies with `NO_REPLY` — the user never sees it.

**Insight:** compaction destroys context. The model itself is the best judge of what's worth preserving before it happens.

### Session-memory hook on `/new`
When starting a fresh session, a hook extracts the last 15 lines of the old conversation, uses an LLM to generate a descriptive slug, and saves it as `memory/2026-01-16-vendor-pitch.md`. Named by topic, not timestamp.

**Insight:** episodic memory that's navigable by *topic* rather than by date.

---

## Work Loops

### `NO_REPLY` as a first-class token
Any agentic turn that should act but not surface to the user returns `NO_REPLY`. The runtime filters it from outgoing payloads. Used in: compaction flushes, heartbeat acknowledgements, background maintenance turns.

**Insight:** agents need a way to do work silently. Most systems lack this — every turn produces output.

### Heartbeat system
Periodic signals sent to the agent (not from the user). The agent can batch multiple checks (email, calendar, notifications) into one turn, track check state in `memory/heartbeat-state.json`, and decide whether to reach out or stay quiet.

**Insight:** heartbeats vs cron is a deliberate distinction. Heartbeats are for things that need conversational context and can drift in timing. Cron is for exact timing and isolated tasks.

### Steer queue mode
Inbound messages during a running agent are injected *after the current tool call completes*, with remaining tool calls skipped. The user can redirect a running agent mid-execution without aborting it.

**Insight:** rather than kill-and-restart when you want to change direction, you *steer* the current run.

### Compaction as automatic code review
Compaction — where the model re-reads everything to summarise — "acts as an automatic review mechanism where models often identify bugs upon re-reading code." Not a designed feature, an emergent one.

**Insight:** the act of summarising forces re-reading, which triggers error-detection. You can exploit this deliberately.

---

## Output Quality

### SOUL.md — the identity file
A separate file that defines *who the agent is*, not what it knows. Key principles from his template:
- "Be genuinely helpful, not performatively helpful. Skip the 'Great question!' — just help."
- "Have opinions. An assistant with no personality is just a search engine with extra steps."
- "Be resourceful before asking. Try to figure it out. *Then* ask if you're stuck."

**Insight:** persona and operating instructions are separate concerns. SOUL.md shapes tone and judgement; AGENTS.md shapes procedure.

### Trigger phrases for hard problems
Specific phrases that change model behaviour:
- `"take your time"` — signals this needs depth
- `"comprehensive"` — full coverage, not quick answer
- `"read all code that could be related"` — forces broad context gathering before acting
- `"create possible hypothesis"` — shifts from answer-mode to reasoning-mode

**Insight:** models respond to framing signals. A few words can double output quality on hard problems.

### Short prompts + screenshots
Prompts have gotten *shorter* over time — often 1–2 sentences plus a screenshot. Visual context replaces verbal description.

**Insight:** over-specified prompts can constrain the model. Less text + more visual context often produces better results than elaborate instructions.

### "Blast radius" framing
Think in terms of how many files a change will touch and how long it takes to isolate if something goes wrong. Prefer many small atomic changes over large ones.

**Insight:** commit hygiene reframed as risk management. Small, verifiable steps beat ambitious single-pass attempts.

---

## The meta-lesson from steipete

> "Don't waste your time on stuff like RAG, subagents, Agents 2.0 or other things that are mostly just charade. Just talk to it."

Gains come from:
1. Good identity + instruction files (SOUL.md, AGENTS.md)
2. Thoughtful memory architecture (two layers, on-demand access)
3. Steering the model well (short prompts, trigger phrases, screenshots)
4. Keeping infrastructure lean (he removed his last MCP because the model was overusing it)

---

## Applicable to this repo

| OpenClaw pattern | Equivalent here |
|---|---|
| SOUL.md | Persona layer connected to skill invocations (`/personas`) |
| Pre-compaction flush | `NO_REPLY` memory-save step at end of long skill runs |
| Session-memory hook | Named summary when a kanban session closes |
| Trigger phrases | Document in CLAUDE.md as prompting heuristics |
| Two-layer memory | MEMORY.md index exists — daily logs are the missing half |
| `NO_REPLY` | Background/housekeeping steps in skills |
