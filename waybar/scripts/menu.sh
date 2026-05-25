#!/usr/bin/env bash
# Opens the user's preferred launcher as a system menu. Falls back through
# walker -> rofi -> wofi so it works regardless of which is installed.

if command -v walker >/dev/null 2>&1; then
  exec walker
elif command -v rofi >/dev/null 2>&1; then
  exec rofi -show drun -l 10
elif command -v wofi >/dev/null 2>&1; then
  exec wofi --show drun
else
  notify-send -u critical "Menu" "No launcher installed (walker/rofi/wofi)"
fi
