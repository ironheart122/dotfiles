#!/usr/bin/env bash
# find-dev-server.sh [project-dir]
#
# Finds dev servers already running for a project, regardless of port.
# Method: list every listening TCP socket owned by this user, and keep the
# ones whose process cwd is inside project-dir. Port-agnostic, so it catches
# Vite on 5173, Vite auto-incremented to 5174+, or anything else.
#
# Output: one line per match:  PID<TAB>PORT<TAB>COMMAND
# Exit:   0 if at least one server found, 1 if none.
set -uo pipefail

proj=$(realpath "${1:-$PWD}") || exit 2
found=1
declare -A seen

while IFS= read -r line; do
  # ss -tlnpH line: LISTEN 0 511 *:5173 *:* users:(("node",pid=1234,fd=25))
  addr=$(awk '{print $4}' <<<"$line")
  port=${addr##*:}
  [[ "$port" =~ ^[0-9]+$ ]] || continue

  for pid in $(grep -oP 'pid=\K[0-9]+' <<<"$line" | sort -u); do
    cwd=$(readlink "/proc/$pid/cwd" 2>/dev/null) || continue
    case "$cwd" in
      "$proj" | "$proj"/*) ;;
      *) continue ;;
    esac
    # a process usually binds the same port on IPv4 and IPv6 — report it once
    [[ -n "${seen[$pid:$port]:-}" ]] && continue
    seen[$pid:$port]=1
    cmd=$(tr '\0' ' ' < "/proc/$pid/cmdline" 2>/dev/null | cut -c1-120)
    printf '%s\t%s\t%s\n' "$pid" "$port" "$cmd"
    found=0
  done
done < <(ss -tlnpH 2>/dev/null)

exit "$found"
