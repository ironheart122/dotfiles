---
name: dev-server
description: Manage local dev servers — check whether one is already running for the current project (default OR auto-incremented/random port) before ever starting one; start it only if absent. Use when asked to start/run/restart a dev server, check if one is up, or get its URL.
---

# Dev Server Manager

The global rule "don't run dev server commands" stands everywhere else; this skill
is the sanctioned exception path. Even here: **detect first, never blind-start.**

## 1. Detect

```bash
~/.claude/skills/dev-server/scripts/find-dev-server.sh <project-dir>
```

Prints `PID  PORT  COMMAND` per running server (exit 1 = none). Detection is
port-agnostic and framework-agnostic: it lists every listening socket whose
process cwd is inside the project, so it catches Vite on 5173, Vite bumped to
5174+, or any other server/port. Don't grep ports or `ps` by hand — the script
is the method.

In a monorepo, pass the **repo root**, not a workspace subdir: the cwd check
matches downward (subdirs) but never upward, and a server launched from the
root may keep its cwd there.

- **Any match → do NOT start another server.** Report the URL(s)
  (`http://localhost:<PORT>`; use `https://` if the project's dev config
  terminates TLS — e.g. a `server.https` block in the Vite config).
- Multiple lines can be legit (monorepo: gateway + services, or vite + HMR
  sockets). Judge by COMMAND which one is the app entrypoint.
- A *different* project squatting the default port won't match (cwd check) and
  doesn't matter: Vite auto-increments, so just start ours and re-detect.
- `ss -p` only names processes owned by the current user — root/docker
  listeners show up anonymous and are skipped. Fine: dev servers are
  user-owned; DBs in containers aren't what this skill manages.
- **WSL:** works normally *within* a WSL2 distro, but Windows-side servers
  (node.exe, non-Remote-WSL VS Code terminals) are invisible here — "nothing
  running" may mean "running on the Windows side". Keep project + server in
  the distro. Under WSL1, `ss` can return empty even with live servers
  (incomplete netlink) — that distro needs converting to WSL2.

## 2. Start (only when step 1 found nothing)

1. Pick the package manager from lockfiles: `pnpm-lock.yaml` → pnpm,
   `bun.lock`/`bun.lockb` → bun. Never npm/yarn — for an npm/yarn-lockfile
   project, run the script with bun (`bun run dev`); it executes package.json
   scripts fine without touching the lockfile.
2. Read `package.json` `scripts` for the dev entry (`dev`, `start:dev`, …). If
   the project's CLAUDE.md names a specific command or wrapper (env injectors
   like Doppler), that wins.
3. Run it with the Bash tool's `run_in_background: true` — never foreground,
   never `nohup`/`&` by hand.
4. Poll `find-dev-server.sh` (every ~2s, give up after ~30s) until a port
   appears. **Report the detected port, not the framework default** — Vite may
   have auto-incremented.
5. On timeout, read the background task output for the actual error before
   concluding anything.

**Sandbox caveat (verified 2026-07-21):** a server spawned from *sandboxed*
Bash can report alive yet never appear in `ss` — the sandbox virtualizes its
network, so the socket is unreachable from the user's browser too. If the task
is alive but no port ever shows: don't keep polling. Either rerun the start
command with the sandbox disabled (accepting the permission prompt) or ask the
user to start it themselves via `! <command>`. Detection of servers the *user*
started is unaffected — host sockets are fully visible from the sandbox.

## 3. Stop / restart (only when explicitly asked)

`kill <PID>` from the script's output — targeted, never `pkill node`/`pkill vite`.
For restart: kill, wait for the script to report nothing, then step 2.
