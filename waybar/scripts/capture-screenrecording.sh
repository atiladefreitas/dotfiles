#!/usr/bin/env bash
# Toggles a screen recording. Starts wf-recorder on click; stops a running
# recording if one is active. Saves to ~/Videos with a timestamp.

set -e

if pgrep -x wf-recorder >/dev/null 2>&1; then
  pkill -INT -x wf-recorder
  notify-send -u low "Screen recording" "Stopped"
  exit 0
fi

if ! command -v wf-recorder >/dev/null 2>&1; then
  notify-send -u critical "Screen recording" "wf-recorder is not installed"
  exit 1
fi

mkdir -p "$HOME/Videos"
out="$HOME/Videos/screen-$(date +%Y%m%d-%H%M%S).mp4"

if command -v slurp >/dev/null 2>&1; then
  region=$(slurp 2>/dev/null || true)
  if [ -n "$region" ]; then
    wf-recorder -g "$region" -f "$out" >/dev/null 2>&1 &
  else
    wf-recorder -f "$out" >/dev/null 2>&1 &
  fi
else
  wf-recorder -f "$out" >/dev/null 2>&1 &
fi

notify-send -u low "Screen recording" "Started: $(basename "$out")"
