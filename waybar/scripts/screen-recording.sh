#!/usr/bin/env bash
# Streams JSON for waybar's custom/screenrecording-indicator.
# Reports "recording" whenever a known Wayland screen-recorder is running.

emit() {
  if pgrep -x -f 'wf-recorder|wl-screenrec|gpu-screen-recorder|obs|kooha' >/dev/null 2>&1; then
    printf '{"text":"","tooltip":"Screen recording in progress","class":"active","alt":"recording"}\n'
  else
    printf '{"text":"","tooltip":"","class":"","alt":"idle"}\n'
  fi
}

# Initial emit, then refresh every 2s. waybar treats each line as a new update.
while true; do
  emit
  sleep 2
done
