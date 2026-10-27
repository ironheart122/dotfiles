# dotfiles

This repository contains the configuration for an [Omarchy](https://omarchy.org)
desktop (Arch Linux and Hyprland). It also contains the configuration for some
command-line tools.

The repository is the source of truth. The `install.sh` script links each
managed entry into `$HOME`. Thus, when you edit a live configuration file, you
edit the repository. The file `dot_claude/settings.json` is the only exception.

## Layout

| Path | Link in `$HOME` | Contents |
|------|-----------------|----------|
| `dot_zshrc` | `~/.zshrc` | Public shell configuration. It reads `~/.zshrc.local` if that file is available. |
| `dot_config/hypr/` | `~/.config/hypr` | Hyprland monitors, keybindings, input, and appearance (Lua) |
| `dot_config/omarchy/` | `~/.config/omarchy` | Quickshell configuration, bar plugins, branding, and hooks |
| `dot_config/ghostty/` | `~/.config/ghostty` | Terminal emulator |
| `dot_config/btop/` | `~/.config/btop` | System monitor |
| `dot_config/pnpm/` | `~/.config/pnpm` | Global pnpm configuration. It sets a one-day release cooldown (`minimumReleaseAge`). Git tracks only `config.yaml`. |
| `dot_config/starship.toml` | `~/.config/starship.toml` | Shell prompt |
| `dot_config/chrome-flags.conf` | `~/.config/chrome-flags.conf` | Chrome launch flags. These are the Omarchy defaults, with the disk cache in RAM. |
| `dot_codex/config.toml` | `~/.codex/config.toml` | Codex CLI preferences, with private paths removed |
| `dot_claude/skills/` | `~/.claude/skills/<skill>` | Claude Code skills. The script links each skill separately. |
| `dot_claude/agents/` | `~/.claude/agents` | Subagent definitions |
| `dot_claude/CLAUDE.md` | `~/.claude/CLAUDE.md` | Global Claude Code instructions |
| `dot_claude/settings.json` | None | Claude Code settings. Refer to the caution below. |

> **CAUTION:** Do not use the repository copy of `settings.json` as the live
> configuration. Claude Code replaces the symlink with a regular file when it
> writes its settings. Thus, the live `~/.claude/settings.json` is the real
> configuration, and the repository copy is an old snapshot. The `install.sh`
> script does not link this file. Edit `~/.claude/settings.json` directly.
> Compare it with the repository copy before you commit it.

### Monitors and workspaces

The desktop uses two monitors. All workspaces are persistent.

- The right monitor (DELL, `DP-1`) shows workspaces 1 to 7. Use these
  workspaces for code and deep work.
- The left monitor (LG, `DP-2`) shows workspaces 8 to 14. Use these
  workspaces for documents and the browser.
- `SUPER + F1` to `SUPER + F4` go to workspaces 11 to 14. The Omarchy
  defaults bind only workspaces 1 to 10.

## Omarchy 4.x (quattro)

Quattro uses one Quickshell process for the bar, launcher, notifications,
on-screen displays, and lock screen. Thus, this repository has no
configuration for waybar, walker, mako, swayosd, hyprlock, or hypridle. The
files `dot_config/omarchy/shell.toml` and `shell.json` configure the shell.

The Hyprland configuration is in Lua. The directory `dot_config/hypr/`
contains only Lua files, with two exceptions:

- hyprsunset reads `hyprsunset.conf`.
- xdg-desktop-portal-hyprland reads `xdph.conf`.

### Bar plugins

The directory `dot_config/omarchy/plugins/` contains the bar plugins.

- **Forked plugins.** The command `omarchy plugin clone` makes a local copy of
  a plugin. Package updates do not change this copy. The forked plugin
  `ironheart122.workspaces` shows the workspaces of each monitor. It also
  shows which workspaces have windows and which workspace has focus.
- **Third-party plugins.** Each third-party plugin is a git submodule at a
  fixed commit. The plugin `omaplug`
  ([fross100/omaplug](https://github.com/fross100/omaplug)) is a plugin
  manager.

To update a third-party plugin, do these steps:

1. Pull the new commits:
   `git -C dot_config/omarchy/plugins/omaplug pull`
2. Commit the new submodule pointer.

### Themes

This repository does not contain themes. The active theme is the Omarchy
theme `tokyo-night`. The Omarchy themes are in `/usr/share/omarchy/themes/`.

The old custom theme `aether` is removed for these reasons:

- It used the old per-application layout and had no `colors.toml`.
- It was not in use.
- Its palette was the same as the `tokyo-night` palette.

## Installation

Do these steps:

1. Clone the repository:
   `git clone https://github.com/ironheart122/dotfiles.git ~/dotfiles`
2. Run the script: `~/dotfiles/install.sh`
3. Select a background again. Refer to the note in
   [Files that are not tracked](#files-that-are-not-tracked).

The script also initializes the plugin submodules. You can run the script
again at any time. It does not change a link that is already correct. If a
different file is at a destination, the script moves that file to
`~/dotfiles-backup-<timestamp>/`. The script does not delete files.

### Add a configuration to the repository

Do these steps:

1. Move the real directory or file into `dot_config/` or `dot_claude/`.
2. Run `install.sh` again. The script links all entries in these directories.

### Private shell configuration

Put shell configuration that is specific to the machine, to credentials, or to
work in `~/.zshrc.local`. The repository does not track this file.
`dot_zshrc` reads it last, so it can override all other settings.

### Skills from other sources

The script links each skill in `dot_claude/skills/` separately. Thus, skill
collections from other sources can stay in `~/.claude/skills/` (for example,
symlinks into `~/.agents` or into the Omarchy installation). The repository
does not manage these skills.

## Files that are not tracked

The repository contains only configuration that you edit manually. It does not
track these items:

- Secrets
- Browser profiles
- Application state
- Logs
- Editor backups
- Wallpapers

Refer to [`.gitignore`](.gitignore) for the full list.

> **NOTE:** The active wallpaper is not tracked. The link
> `~/.local/state/omarchy/current/background` points to a file in
> `dot_config/omarchy/backgrounds/`. A new clone does not have this file.
> Select a background again after the installation.
