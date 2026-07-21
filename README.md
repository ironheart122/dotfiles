# dotfiles

Personal [Omarchy](https://omarchy.org) (Arch Linux + Hyprland) desktop and
tooling configuration. The repo is the source of truth; `install.sh` symlinks
each managed entry into `$HOME`, so editing a live config file edits the repo.

## Layout

| Path | Links to | What |
|------|----------|------|
| `dot_zshrc` | `~/.zshrc` | Public shell configuration; optionally sources private `~/.zshrc.local` |
| `dot_config/hypr/` | `~/.config/hypr` | Hyprland — window rules, keybindings, monitors, look & feel, idle/lock |
| `dot_config/waybar/` | `~/.config/waybar` | Status bar layout + styling |
| `dot_config/walker/` | `~/.config/walker` | Application launcher |
| `dot_config/{alacritty,ghostty,kitty}/` | `~/.config/…` | Terminal emulators |
| `dot_config/mako/` | `~/.config/mako` | Notification daemon |
| `dot_config/{btop,fastfetch}/` | `~/.config/…` | System monitor / fetch |
| `dot_config/lazygit/` | `~/.config/lazygit` | Git TUI |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Shell prompt |
| `dot_config/omarchy/` | `~/.config/omarchy` | Custom theme, branding, hooks |
| `dot_codex/config.toml` | `~/.codex/config.toml` | Sanitized Codex CLI preferences |
| `dot_claude/skills/` | `~/.claude/skills/<skill>` | Homemade Claude Code skills (linked per-skill) |
| `dot_claude/agents/` | `~/.claude/agents` | Custom subagent definitions |
| `dot_claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Global Claude Code instructions |
| `dot_claude/settings.json` | `~/.claude/settings.json` | Claude Code settings |

Dual-monitor layout: workspaces **1–7** (coding/deep work) on the right display,
**8–14** (docs/browsing) on the left, all persistent.

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
