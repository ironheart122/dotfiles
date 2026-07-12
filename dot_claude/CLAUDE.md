# Personal Preferences

## TypeScript

- Never use `any` unless absolutely necessary or specifically instructed.

## Commands

- Don't run dev server commands (eg. `bun run dev` etc) - Assume it's already running
- Don't run build commands unless specifically told to.
- Focus on checking commands like `bun run typecheck`, `bun run lint` etc.

## Package Managers

- Use pnpm if the project already uses it, otherwise use bun.
- Never use npm or yarn

## Tech Stack Preferences

When uncertain, prefer: Tailwind, TypeScript, Bun, React, BetterAuth, Cloudflare Workers, NeonDB
For Cloudflare work, prefer the cloudflare:* skills and cloudflare-* MCP servers over training knowledge.

## Coding Style

- Always strive for concise, simple solution.
- If a problem can be solved in a simpler way, propose it.

## General Preferences

- If asked to do too much work at once, stop and state that clearly please.

## Picking the right model for the task

Scores: higher = better on every axis, INCLUDING cost (high cost score = cheap
*for me*, on my plan — not API list price). Intelligence/taste are inherited
from Theo's (t3.gg) Twitter table, not yet my own calibration; adjust as I form
opinions. He's on Max 20x, so his cost numbers don't transfer — Cost is mine
and current.

Context: I'm on Claude Max 5x. Opus 4.8 and Sonnet 5 are included in the plan —
my effectively-free Claude tier. Fable 5 is premium and metered (see cliff note).

| model     | cost | intelligence | taste |
|-----------|------|--------------|-------|
| gpt-5.6   | 9    | 9            | 7     |
| opus-4.8  | 7    | 7            | 8     |
| sonnet-5  | 8    | 5            | 7     |
| fable-5   | 1    | 10           | 9     |

_Table last tuned: 2026-07-11. Cost = budget/window efficiency on Max 5x (higher = lighter
footprint), not API list price. Haiku is excluded deliberately: never use Haiku —
too weak for my work at any price._

Fable 5 cliff (Max 5x):
- Burns the 5-hour window ~2x+ faster than Opus (steeper in long agentic runs);
  capped at 50% of weekly limits. Treat as premium/metered, never a default.
- Included promo access ends 2026-07-12 23:59:59 PT (= 2026-07-13 ~12:30 IST),
  then paid usage credits ($10/$50 per Mtok).
- The pre-reveal PR-2/3/4 stack audit runs in the final included window:
  Monday 2026-07-13, from the 07:30 reset until promo end ~12:30 IST (~5 hours),
  fully by Fable. Everything else: Opus/Sonnet/GPT — Fable sessions run as
  ORCHESTRATOR per the `codex-first` skill (Codex implements; Claude
  specs/reviews/verifies).
- After promo end: the Claude usage dashboard is truth — confirm actual credit
  terms there before any Fable invocation, and the main-session default model
  should be back on Opus 4.8.

How to apply:
- Default Claude driver: Opus 4.8. It's included and strong across the board.
- Escalation is DELIBERATE, not standing permission. If a cheaper model misses
  the bar, first try rerunning or tightening the prompt; escalate to Fable only
  for work that genuinely needs its ceiling and is worth burning window/credits.
  (On Max 5x, unlike a 20x plan, careless escalation kills the window fast.)
  Who acts: Claude applies this to subagents/workflows via the `model` param —
  Fable-tier subagents need a stated justification in chat or my OK. The
  main-session model is mine to switch (/model); if it's the bottleneck, say so.
- Tie-break when axes conflict for anything that ships: intelligence > taste > cost.
- Anything user-facing (UI, copy, API design): taste >= 7.
- Bulk/mechanical work (clear-spec implementation, migrations, data analysis):
  GPT via Codex — generous limits make it effectively free, off my Claude budget.
- Reviews of plans/implementations: Opus 4.8 by default; a GPT pass (Codex or
  Opencode) as an independent second perspective; reserve Fable for high-stakes
  reviews only.
- If computer use is helpful for completing or verifying work, shell out to
  GPT-5.6 with Codex for it.

Which tool reaches which model:
- Claude (opus-4.8, sonnet-5, fable-5): Claude Code — main agent and subagents
  via the `model` param.
- GPT hands-on repo work: the `codex-first` skill (~/.claude/skills/codex-first/)
  is the routing SSoT — read it, don't improvise. Quick decision rule: raw
  `codex exec` (or the skill's flow) for sequential repo work and non-repo
  one-shots (e.g. review second opinions); the proxenos MCP server
  (`delegate_task`) when isolated-worktree PARALLEL delegation is the point.
  Details (spec discipline, allowedPaths, verification, model config) live in
  the skill and proxenos docs (~/Work/projects/proxenos) — the Codex model
  comes from ~/.codex/config.toml, never pinned elsewhere. Delegations draw
  from the same ChatGPT subscription window as interactive Codex. Neither from
  inside a Claude Code workflow.
- Opencode (ChatGPT auth) for interactive GPT work.
