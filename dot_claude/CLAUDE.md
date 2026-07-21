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
*for me*, on my plan — not API list price).

Context: I'm on Claude Max 5x. Opus 4.8 and Sonnet 5 are included in the plan —
my effectively-free Claude tier. Fable 5 is included but capped (see access note).

| model       | cost | intelligence | taste |
|-------------|------|--------------|-------|
| gpt-5.6 Sol | 5    | 9            | 8     |
| opus-4.8    | 7    | 6            | 6     |
| sonnet-5    | 8    | 7            | 7     |
| fable-5     | 2    | 10           | 9     |

_Table last tuned: 2026-07-21. Cost = budget/window efficiency on Max 5x (higher = lighter
footprint), not API list price. Haiku is excluded deliberately: never use Haiku —
too weak for my work at any price._

Fable 5 access (Max 5x/20x):
- PERMANENT (announced 2026-07-18 - woot!): Fable 5 is included on Max and Team
  Premium plans at 50% of usage limits. The Jul-19 promo cliff and the
  paid-credit fallback ($10/$50 per Mtok) are GONE — no dashboard check
  needed before invoking Fable.
- Burn discipline UNCHANGED: burns the 5-hour window ~2x+ faster than Opus
  (steeper in long agentic runs) and the 50%-of-weekly-limits cap still
  applies. Treat as premium/metered — default only for the review/taste roles
  in "How to apply" below, never for implementation/mechanical work.
- Fable sessions still run as ORCHESTRATOR per the `codex-first` skill
  (Codex implements; Claude specs/reviews/verifies).

How to apply (role split updated 2026-07-21):
- Backend/implementation coding: **Sonnet 5** (subagents/workflows get
  `model: "sonnet"`). This is the volume work — keeping it on Sonnet is what
  funds the Fable meter.
- Reviews of plans/implementations + taste-sensitive work (UI, copy, API
  design): **Fable 5** — standing policy, replaces Opus in these roles; no
  per-use justification needed. Still metered: don't loop Fable on mechanical work. A GPT pass (Codex or
  Opencode) remains the independent second perspective on reviews.
- Opus 4.8: fallback/general driver when neither bucket clearly applies.
- Escalation beyond this split is still DELIBERATE, not standing permission:
  if a cheaper model misses the bar, first rerun or tighten the prompt.
  The main-session model is mine to switch (/model); if it's the bottleneck,
  say so.
- Tie-break when axes conflict for anything that ships: intelligence > taste > cost.
- Anything user-facing (UI, copy, API design): taste >= 7.
- Bulk/mechanical work (clear-spec implementation, migrations, data analysis):
  GPT via Codex — generous limits make it effectively free, off my Claude budget.
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
