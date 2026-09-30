#!/usr/bin/env bash
# Usage: session-port.sh <session_name>
# Prints "running on <port>[, <port>...]" if any node (or next-server/bun/deno) process in the
# session's panes is listening on a TCP port, otherwise nothing.
session="$1"

ttys=$(tmux list-panes -s -t "=$session" -F '#{pane_tty}' 2>/dev/null | sed 's#^/dev/##' | paste -sd, -)
[ -z "$ttys" ] && exit 0

pids=$(ps -t "$ttys" -o pid=,comm= 2>/dev/null | awk '$2 ~ /(^|\/)(node|next-server|bun|deno)$/ { print $1 }' | paste -sd, -)
[ -z "$pids" ] && exit 0

ports=$(lsof -nP -a -iTCP -sTCP:LISTEN -p "$pids" 2>/dev/null \
  | awk 'NR>1 { n = split($9, a, ":"); print a[n] }' | sort -un | paste -sd, - | sed 's/,/, /g')

[ -n "$ports" ] && echo "running on $ports"
