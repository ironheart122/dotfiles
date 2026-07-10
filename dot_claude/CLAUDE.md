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
| gpt-5.5   | 9    | 8            | 5     |
| opus-4.8  | 7    | 7            | 8     |
| sonnet-5  | 8    | 5            | 7     |
| fable-5   | 1    | 9            | 9     |

_Table last tuned: 2026-07-02. Cost = budget/window efficiency on Max 5x (higher = lighter
footprint), not API list price._

Fable 5 cliff (Max 5x, updated 2026-07-08):
- Burns the 5-hour window ~2x+ faster than Opus (steeper in long agentic runs).
- Capped at 50% of weekly limits; promotion EXTENDED (Anthropic tweet) — included
  access now ends 2026-07-12 23:59:59 PT, then paid usage credits ($10/$50 per
  Mtok). Treat as premium/metered, not a default.
- Weekly usage ~80% spent as of 2026-07-08; the Monday 07:30 reset buys ~36
  hours of included Fable max before promo end. The pre-reveal PR-2/3/4 stack
  audit runs MONDAY Jul 13 post-reset (user-fixed 2026-07-08), fully by Fable.
  Everything else: Opus/Sonnet/GPT — Fable sessions run as ORCHESTRATOR per the
  `codex-first` skill (Codex implements; Claude specs/reviews/verifies).
- After 2026-07-12: confirm actual credit terms on the Claude usage dashboard
  before any Fable invocation (dashboard is truth).

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
- Never use Haiku.

Which tool reaches which model:
- Claude (opus-4.8, sonnet-5, fable-5): Claude Code — main agent and subagents
  via the `model` param.
- GPT (bulk/mechanical, second opinions): the proxenos MCP server
  (`delegate_task`) for repo-targeted delegation from Claude Code; Codex CLI
  (`codex exec` / `codex review`; defaults in ~/.codex/config.toml) for
  scripted/headless one-shots; Opencode (ChatGPT auth) for interactive GPT work.
- GPT runs in its own tool. Routing SSoT for hands-on repo work is the
  `codex-first` skill (~/.claude/skills/codex-first/, added 2026-07-08): raw
  `codex exec --yolo -C <repo>` with temp-file prompts + `resume` follow-ups.
  proxenos remains the tool when isolated-worktree parallel delegation is the
  point: each delegation runs a Codex worker in an isolated git worktree and
  returns a unified diff, orchestrator-run verification exit code, declared
  obstacles, and quota usage. Spec discipline: the worker has no conversation
  context — write the task like a ticket, seed the right files, always set
  `allowedPaths` and a `verification.command`, and review `obstacles` before
  applying the patch. Delegations draw from the same ChatGPT subscription
  window as interactive Codex — parallel dispatch has real cost even at $0.
  The Codex model comes from ~/.codex/config.toml (the SSoT) — never pin
  `model` in proxenos worker profiles. Raw `codex exec` / `codex review` via
  Bash remains for non-repo one-shots (e.g. review second opinions). Neither
  from inside a Claude Code workflow. (proxenos — ~/Work/projects/proxenos —
  is the thin-Codex-wrapper pattern Theo alluded to, now with a reference
  implementation.)
