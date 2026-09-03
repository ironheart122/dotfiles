# dotfiles

Personal [Omarchy](https://omarchy.org) (Arch Linux + Hyprland) desktop and
tooling configuration. The repo is the source of truth; `install.sh` symlinks
each managed entry into `$HOME`, so editing a live config file edits the repo.
(One exception — see the note on `settings.json` below.)

## Layout

| Path | Links to | What |
|------|----------|------|
| `dot_zshrc` | `~/.zshrc` | Public shell configuration; optionally sources private `~/.zshrc.local` |
| `dot_config/hypr/` | `~/.config/hypr` | Hyprland — monitors, keybindings, input, look & feel (Lua) |
| `dot_config/omarchy/` | `~/.config/omarchy` | Quickshell config, forked bar plugins, branding, hooks |
| `dot_config/ghostty/` | `~/.config/ghostty` | Terminal emulator |
| `dot_config/{btop,fastfetch}/` | `~/.config/…` | System monitor / fetch |
| `dot_config/lazygit/` | `~/.config/lazygit` | Git TUI |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Shell prompt |
| `dot_config/chrome-flags.conf` | `~/.config/chrome-flags.conf` | Chrome launch flags (Omarchy defaults plus in-RAM disk cache) |
| `dot_codex/config.toml` | `~/.codex/config.toml` | Sanitized Codex CLI preferences |
| `dot_claude/skills/` | `~/.claude/skills/<skill>` | Homemade Claude Code skills (linked per-skill) |
| `dot_claude/agents/` | `~/.claude/agents` | Custom subagent definitions |
| `dot_claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Global Claude Code instructions |
| `dot_claude/settings.json` | — | Claude Code settings — **not a live symlink**, see below |

> **`settings.json` drifts.** `install.sh` does symlink it, but the live
> `~/.claude/settings.json` is a regular file and its contents have diverged
> from the repo copy — most likely because Claude Code rewrites settings by
> atomic replace, which swaps a symlink for a real file. Either way the live
> file is the real config and the repo copy is a stale snapshot. Edit
> `~/.claude/settings.json` directly, and diff it against the repo before
> committing anything here.

Dual-monitor layout: workspaces **1–7** (coding/deep work) on the right display,
**8–14** (docs/browsing) on the left, all persistent.

## Omarchy 4.x (quattro)

Quattro replaced the separate desktop components with a single Quickshell
process, so configs for waybar, walker, mako, swayosd, hyprlock, and hypridle
are gone from this repo — the shell owns the bar, launcher, notifications,
OSDs, and lock screen now, configured via `dot_config/omarchy/shell.toml` and
`shell.json`. Hyprland's own config also moved from `.conf` to Lua;
`dot_config/hypr/` is Lua-only, apart from `hyprsunset.conf` and `xdph.conf`,
which are read by hyprsunset and xdg-desktop-portal-hyprland rather than by
Hyprland itself.

`dot_config/omarchy/plugins/` holds forked bar widgets. Forking via
`omarchy plugin clone` keeps local changes safe from package updates —
currently `ironheart122.workspaces`, which shows per-monitor workspaces with
occupancy and focus indicators.

Themes are no longer tracked here. The custom `aether` theme was dropped: it
predated quattro (old per-app layout, no `colors.toml`), had gone unused, and
its palette was byte-identical to upstream `tokyo-night`, which is the active
theme. Omarchy's own themes live in `/usr/share/omarchy/themes/`.

## Usage

```sh
git clone <this-repo> ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` is idempotent. Anything already at a destination is moved to
`~/dotfiles-backup-<timestamp>/`, never deleted.

**Adding something new to manage:** move the real dir/file into `dot_config/`
(or `dot_claude/`) and rerun `install.sh` — it symlinks whatever is there.
Keep machine-, credential-, and work-specific shell configuration in
`~/.zshrc.local`; `dot_zshrc` sources it when present but does not track it.
Skills under `dot_claude/skills/` are linked one by one, so downloaded skill
collections (e.g. symlinks into `~/.agents`) coexist untouched.

## Excluded on purpose

Secrets, browser profiles, application state, logs, editor backups, and
wallpapers are intentionally **not** tracked — see [`.gitignore`](.gitignore).
Only hand-edited configuration is committed. `~/.claude/skills/` entries that
are symlinks into other collections (`~/.agents`, the Omarchy install) are
left unmanaged here.

Note that the active wallpaper is one of the untracked files, so
`~/.local/state/omarchy/current/background` points into `dot_config/omarchy/`
at a path a fresh clone won't have. Pick a background again after installing.
