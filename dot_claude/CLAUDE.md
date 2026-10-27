# Personal Preferences

## Commands

- Don't run dev server commands (eg. `bun run dev` etc) - Assume it's already running
- Don't run build commands unless specifically told to.
- Focus on checking commands like `bun run typecheck`, `bun run lint` etc.

## Specs before work

- Before you start any work, write a spec and publish it as an HTML artifact with the Artifact tool. Wait for my approval before you change anything.
- Skip the spec for small tasks: a commit or push, a question, a lookup, or a small change whose plan is obvious.
- You can read files and run read-only commands to write the spec.
- The spec covers the goal, the planned changes (files and behavior), what is out of scope, open questions, and how you will verify the result.
- After I approve, follow the spec. If the plan has to change, update the artifact and tell me before you continue.

## Package Managers

- Match the project's package manager, even npm or yarn.
- For new projects and one-off scripts, use bun (`bunx`, not `npx`).

## Tech Stack Preferences

When uncertain, prefer: Tailwind, TypeScript, Bun, React, BetterAuth, Cloudflare Workers, NeonDB
For payments, prefer Dodo Payments over Stripe (Stripe isn't available in India ¯\_(ツ)_/¯).
For Cloudflare work, prefer the cloudflare:* skills and cloudflare-* MCP servers over training knowledge.

## General Preferences

- If asked to do too much work at once, say so clearly and propose a split before starting.
- No em dashes in any output (prose, code comments, commit messages). Use commas, parentheses, or separate sentences instead.
- No extra comments that are unnecessary or inconsistent with local style.
- Keep the summary at the end of finished work concise (1-3 sentences). Reviews and investigations can be longer.

## Human-facing documentation

Use Simplified Technical English (STE). Write short, direct sentences in active voice. Use consistent terms and give one instruction per step. Avoid jargon, idioms, and unnecessary words. Define necessary technical terms on first use. Preserve exact code identifiers, commands, API names, and UI labels.

This applies to READMEs, guides, specs, and other docs written for people to read. It does not apply to code comments, commit messages, or chat replies.

## Commit messages

Write commit messages for AI agents that read the history later.

- Match the repo's existing subject format.
- Say why the change was made. The diff already shows what changed.
- Name the behavior, files, or commands the change affects, so a search finds it.
- Record anything a later reader could get wrong: a workaround, a deliberate choice, a known limitation.
- Skip filler and don't restate the diff.

## TypeScript: anti-slop rules

Follow these in all TypeScript work, whether or not the repo has the anti-slop
oxlint plugin installed (the `/install-anti-slop` skill vendors it into a repo
for enforcement; offer it when a TS repo lacks it). Most of these are
type-level (erased at compile time), so their value is preventing runtime bugs,
not changing runtime behavior. Only the `typeof`/boundary-parsing and
conditional-spread rules touch emitted JS. The assertion rules
(chained assertions, widen-then-assert) are the highest correctness value:

- No chained type assertions (`x as A as B`). No widen-then-assert (widening a
  known value so it can be asserted narrower). Don't let known values flow into
  broad or anonymous types that discard what's already proven about them.
- Every type assertion except `as const` needs an adjacent `SAFETY:` comment
  justifying why it holds.
- `unknown` lives only at I/O boundaries: no `unknown` parameters (except
  `cause`), no `unknown`/`Promise<unknown>` return types, no type aliases that
  resolve to `unknown`. Decode external input into a domain type at the
  boundary instead of scattering runtime `typeof` checks. Full schema parsing
  is for genuine trust boundaries only (API responses, user input, env, file
  reads). It adds runtime cost, so don't parse internal values the type
  system already covers.
- No dictionary/record types whose value type is `unknown`, `any`, `object`, or
  `{}` (directly or via a union/alias).
- Function inputs take owner-provided named types parsed at their boundary, not
  anonymous inline object parameter types.
- No `Reflect.get`/`Reflect.apply`; use typed access, or model dynamic dispatch
  behind an interface.
- No conditional empty-object spreads (`...(cond ? { x } : {})`) to omit
  fields. This is emitted JS, not type-level: omitting a key vs. setting it
  `undefined` changes `in` checks, `Object.keys`, and JSON output. Build the
  object explicitly so the omission is intentional.
- No module mocking in tests (`vi.mock`/`jest.mock`); replace dependencies
  through real interfaces.
- Don't use "shape" (any casing) in symbol names (naming convention only,
  lowest priority of these rules).
- Prefer inference, `as const`, `satisfies`, and named owner contracts over
  assertions and widening.
