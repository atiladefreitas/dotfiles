#!/usr/bin/env bash
# Usage: pane-port.sh <pane_tty> <pane_current_command>
# Prints "<cmd> <port>[,<port>...]" if any process on the pane's tty is
# listening on a TCP port, otherwise just "<cmd>".
tty="${1#/dev/}"
cmd="$2"

pids=$(ps -t "$tty" -o pid= 2>/dev/null | tr -s ' \n' ',' | sed 's/^,//;s/,$//')
[ -n "$pids" ] && ports=$(lsof -nP -a -iTCP -sTCP:LISTEN -p "$pids" 2>/dev/null \
  | awk 'NR>1 { n = split($9, a, ":"); print a[n] }' | sort -un | paste -sd, -)

if [ -n "$ports" ]; then
  echo "$cmd $ports"
else
  echo "$cmd"
fi
