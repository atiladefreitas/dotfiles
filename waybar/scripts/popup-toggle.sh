#!/usr/bin/env bash
# Usage: popup-toggle.sh <name> <command> [args...]
# Opens a kitty terminal with class "waybar-popup-<name>" running <command>.
# If a window with that class already exists, closes it instead (toggle).
# Switching from one popup to another closes the previous one in the same click.

set -uo pipefail

name="$1"; shift
class="waybar-popup-${name}"

clients_json="$(hyprctl clients -j)"

mapfile -t same_pids < <(printf '%s' "$clients_json" \
    | jq -r --arg c "$class" '.[] | select(.class == $c) | .pid')

if [ "${#same_pids[@]}" -gt 0 ]; then
    for p in "${same_pids[@]}"; do
        [ -n "$p" ] && kill "$p" 2>/dev/null || true
    done
    exit 0
fi

mapfile -t other_pids < <(printf '%s' "$clients_json" \
    | jq -r '.[] | select(.class | startswith("waybar-popup-")) | .pid')
for p in "${other_pids[@]}"; do
    [ -n "$p" ] && kill "$p" 2>/dev/null || true
done

exec kitty --class "$class" -e "$@"
