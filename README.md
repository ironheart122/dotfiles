# dotfiles

Personal [Omarchy](https://omarchy.org) (Arch Linux + Hyprland) desktop configuration.

## What's here

| Path | What |
|------|------|
| `hypr/` | Hyprland — window rules, keybindings, monitors, look & feel, idle/lock |
| `waybar/` | Status bar layout + styling |
| `walker/` | Application launcher |
| `alacritty/`, `ghostty/`, `kitty/` | Terminal emulators |
| `mako/` | Notification daemon |
| `btop/`, `fastfetch/` | System monitor / fetch |
| `lazygit/` | Git TUI |
| `starship.toml` | Shell prompt |
| `omarchy/` | Custom theme, branding, hooks |

Dual-monitor layout: workspaces **1–7** (coding/deep work) on the right display,
**8–14** (docs/browsing) on the left, all persistent.

## Usage

These files live in `~/.config` on the source machine. To reuse a piece, copy the
relevant directory into your own `~/.config` (e.g. `cp -r hypr ~/.config/`) and
reload the app — for Hyprland, `hyprctl reload`.

## Excluded on purpose

Secrets, browser profiles, application state, logs, editor backups, and wallpapers
are intentionally **not** tracked — see [`.gitignore`](.gitignore). Only hand-edited
desktop configuration is committed.
