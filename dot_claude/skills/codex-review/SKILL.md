---
name: codex-review
description: "Ask Codex CLI (gpt-5.6 - Sol) for an independent code review of uncommitted changes, branch diff, a commit or a specific implementation. This is how gpt-5.6 - Sol is invoked for review work."
---

# Codex Review

Claude Code sessions only. Codex/other harnesses: skip; never self-delegate.

Purpose: independent GPT second opinion per CLAUDE.md review policy — complements Claude review (`/code-review`, `$autoreview`), never replaces it. Disagreement between the two reviews is signal: look closer, don't average.

Caveat: if Codex implemented the diff (via `$codex-first`), Codex reviewing it is author-reviews-author — Claude review is primary there; a Codex pass is still fine as a cheap extra sweep.

## Invoke

Run from the repo dir (`review` has no `-C`). Result prints to stdout (no `-o`, unlike `exec`); stderr suppressed as usual. Review is read-only — no `--yolo` needed.

**A scope flag and a custom prompt are mutually exclusive** (codex-cli 0.145.0). `--base`, `--uncommitted`, and `--commit` each fail with `error: the argument '--X' cannot be used with '[PROMPT]'`. Pick one of the three forms below; you cannot have both in a single call.

### Generic review, explicit scope

```bash
(cd <repo> && command codex review --uncommitted 2>/dev/null)     # staged + unstaged + untracked
(cd <repo> && command codex review --base main 2>/dev/null)       # branch diff vs base
(cd <repo> && command codex review --commit <sha> 2>/dev/null)    # a single commit
```

### Focused review — custom instructions, default scope

Instructions via temp file on stdin, never inline quoting. **No scope flag:**

```bash
P=$(mktemp); cat >"$P" <<'EOF'
Focus: <what to scrutinize — e.g. correctness of X, concurrency in Y, error paths>.
Ignore: style, naming, formatting.
For each finding: file:line, severity, why it's wrong, suggested fix.
EOF
(cd <repo> && command codex review - <"$P" 2>/dev/null)
```

Default scope is `git diff` + `git diff --cached` — **tracked changes only**. An untracked file is silently absent from the review rather than erroring, so a new file gets no scrutiny at all and nothing says so. `git add` it first (`-N` is enough).

### Focused review of a branch diff

Needs both halves, so present the branch diff as working-tree changes in a throwaway worktree:

```bash
WT=$(mktemp -d)/wt; P=<instructions file>
git worktree add --detach "$WT" <base>
git diff <base>...<branch> | git -C "$WT" apply
ln -s "$PWD/node_modules" "$WT/node_modules"   # so the reviewer can actually run tests
EX="$(git rev-parse --git-common-dir)/info/exclude"
printf 'node_modules\n' >> "$EX"               # gitignore's `node_modules/` won't match a symlink
git -C "$WT" add -A                            # else new files fall out of scope, see above
(cd "$WT" && command codex review - <"$P" 2>/dev/null)
git worktree remove --force "$WT"              # then drop the exclude line again
```

Give the reviewer a runnable tree when the findings are numerical — "prove it with arithmetic" is worth far more than an assertion, and it can't if the deps aren't there.

- `command codex` bypasses the interactive zsh wrapper; if not on PATH: `fnm exec --using default -- codex`
- effort bump for high-stakes reviews: `-c model_reasoning_effort="high"`
- model comes from ~/.codex/config.toml (SSoT) — never pin `model` here
- long diffs take a while: Bash run_in_background, collect stdout on exit

## Triage (Claude, always)

Codex findings are advisory, not verdicts:

- verify each finding against the actual diff before acting — false positives happen; never apply a fix on Codex's word alone
- merge with Claude's own review into one findings list for the user; dedupe, attribute nothing ("Codex said" is noise — a finding stands or falls on the code)
- findings that survive verification: fix per normal flow (Claude directly, or `$codex-first` if it's a work order)
- burns the ChatGPT subscription window like any Codex run — one review pass per ship point, don't loop it
