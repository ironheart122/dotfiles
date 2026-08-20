# Personal Preferences

## Commands

- Don't run dev server commands (eg. `bun run dev` etc) - Assume it's already running
- Don't run build commands unless specifically told to.
- Focus on checking commands like `bun run typecheck`, `bun run lint` etc.

## Package Managers

- Match the project's package manager; otherwise bun. Never npm or yarn.

## Tech Stack Preferences

When uncertain, prefer: Tailwind, TypeScript, Bun, React, BetterAuth, Cloudflare Workers, NeonDB
For payments, prefer Dodo Payments over Stripe (Stripe isn't available in India).
For Cloudflare work, prefer the cloudflare:* skills and cloudflare-* MCP servers over training knowledge.

## TypeScript: anti-slop rules

Follow these in all TypeScript work, whether or not the repo has the anti-slop
oxlint plugin installed (the `/install-anti-slop` skill vendors it into a repo
for enforcement — offer it when a TS repo lacks it). Most of these are
type-level (erased at compile time) — their value is preventing runtime bugs,
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
  reads) — it's added runtime cost; don't parse internal values the type
  system already covers.
- No dictionary/record types whose value type is `unknown`, `any`, `object`, or
  `{}` (directly or via a union/alias).
- Function inputs take owner-provided named types parsed at their boundary, not
  anonymous inline object parameter types.
- No `Reflect.get`/`Reflect.apply`; use typed access, or model dynamic dispatch
  behind an interface.
- No conditional empty-object spreads (`...(cond ? { x } : {})`) to omit
  fields. This is emitted JS, not type-level: omitting a key vs. setting it
  `undefined` changes `in` checks, `Object.keys`, and JSON output — build the
  object explicitly so the omission is intentional.
- No module mocking in tests (`vi.mock`/`jest.mock`); replace dependencies
  through real interfaces.
- Don't use "shape" (any casing) in symbol names (naming convention only —
  lowest priority of these rules).
- Prefer inference, `as const`, `satisfies`, and named owner contracts over
  assertions and widening.

## General Preferences

- If asked to do too much work at once, stop and state that clearly please.
