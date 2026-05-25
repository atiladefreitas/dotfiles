#!/usr/bin/env bash
# Prints the update icon when there are pacman/AUR updates available.
# Output is one line; the module hides itself when output is empty.

if command -v checkupdates >/dev/null 2>&1; then
  count=$(checkupdates 2>/dev/null | wc -l)
elif command -v yay >/dev/null 2>&1; then
  count=$(yay -Qu 2>/dev/null | wc -l)
elif command -v paru >/dev/null 2>&1; then
  count=$(paru -Qu 2>/dev/null | wc -l)
else
  count=$(pacman -Qu 2>/dev/null | wc -l)
fi

if [ "${count:-0}" -gt 0 ]; then
  printf '{"text":"","tooltip":"%s update(s) available","class":"has-updates"}\n' "$count"
else
  printf '{"text":"","tooltip":"","class":""}\n'
fi
