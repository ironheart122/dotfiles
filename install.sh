#!/usr/bin/env bash
# Symlink repo-managed dotfiles into place. Idempotent; safe to rerun.
#
#   dot_zshrc                -> ~/.zshrc
#   dot_config/<entry>        -> ~/.config/<entry>          (whole dirs/files)
#   dot_codex/config.toml     -> ~/.codex/config.toml
#   dot_claude/skills/<skill> -> ~/.claude/skills/<skill>   (per-skill, so
#       unmanaged skills and symlinks into ~/.agents keep working alongside)
#   dot_claude/<entry>        -> ~/.claude/<entry>          (CLAUDE.md, agents, ...)
#
# Anything already at a destination (that isn't the correct link) is moved
# to ~/dotfiles-backup-<timestamp>/ rather than deleted.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

link() {
  local src=$1 dst=$2
  if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
    return 0 # already linked correctly
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    mkdir -p "$BACKUP/$(dirname "${dst#"$HOME"/}")"
    mv "$dst" "$BACKUP/${dst#"$HOME"/}"
    echo "backed up: $dst"
  fi
  ln -s "$src" "$dst"
  echo "linked:    $dst -> $src"
}

mkdir -p "$HOME/.config" "$HOME/.claude/skills" "$HOME/.codex"

link "$REPO/dot_zshrc" "$HOME/.zshrc"
link "$REPO/dot_codex/config.toml" "$HOME/.codex/config.toml"

for entry in "$REPO"/dot_config/*; do
  link "$entry" "$HOME/.config/$(basename "$entry")"
done

for skill in "$REPO"/dot_claude/skills/*/; do
  link "${skill%/}" "$HOME/.claude/skills/$(basename "$skill")"
done

for entry in "$REPO"/dot_claude/*; do
  name="$(basename "$entry")"
  [ "$name" = "skills" ] && continue
  link "$entry" "$HOME/.claude/$name"
done

echo "done. backups (if any): $BACKUP"
