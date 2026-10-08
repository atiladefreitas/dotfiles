#!/usr/bin/env bash
# Usage: session-kill-server.sh <target>
# Stops every node (or next-server/bun/deno) process listening on a TCP port
# in the target's session, leaving the panes and their shells alive.
# The foreground job owning the server gets SIGINT (same as pressing C-c);
# anything still listening after a grace period gets SIGTERM.
session=$(tmux display -p -t "$1" '#{session_name}' 2>/dev/null) || exit 0

panes=$(tmux list-panes -s -t "=$session" -F '#{pane_tty} #{pane_pid}' 2>/dev/null | sed 's#^/dev/##')
ttys=$(awk '{ print $1 }' <<<"$panes" | paste -sd, -)
[ -z "$ttys" ] && exit 0

procs=$(ps -t "$ttys" -o pid=,pgid=,tpgid=,comm= 2>/dev/null | awk '$4 ~ /(^|\/)(node|next-server|bun|deno)$/')
pids=$(awk '{ print $1 }' <<<"$procs" | paste -sd, -)
if [ -z "$pids" ]; then
  tmux display-message "No node server running in $session"
  exit 0
fi

listening=$(lsof -nP -a -iTCP -sTCP:LISTEN -p "$pids" 2>/dev/null | awk 'NR>1 { print $2 }' | sort -u)
if [ -z "$listening" ]; then
  tmux display-message "No node server running in $session"
  exit 0
fi
ports=$(lsof -nP -a -iTCP -sTCP:LISTEN -p "$(paste -sd, - <<<"$listening")" 2>/dev/null \
  | awk 'NR>1 { n = split($9, a, ":"); print a[n] }' | sort -un | paste -sd, - | sed 's/,/, /g')

shells=" $(awk '{ print $2 }' <<<"$panes" | paste -sd' ' -) "
for pid in $listening; do
  read -r pgid tpgid < <(awk -v p="$pid" '$1 == p { print $2, $3 }' <<<"$procs")
  # Server is part of the pane's foreground job (e.g. `pnpm dev`): interrupt
  # the whole job like C-c would. Never signal the pane's shell itself.
  if [ "$pgid" = "$tpgid" ] && [[ "$shells" != *" $pgid "* ]]; then
    kill -INT -- "-$pgid" 2>/dev/null
  else
    kill -TERM "$pid" 2>/dev/null
  fi
done

for _ in 1 2 3 4 5 6 7 8 9 10; do
  alive=""
  for pid in $listening; do kill -0 "$pid" 2>/dev/null && alive="$alive $pid"; done
  [ -z "$alive" ] && break
  sleep 0.3
done
[ -n "$alive" ] && kill -TERM $alive 2>/dev/null

~/dotfiles/tmux/scripts/session-port.sh
tmux display-message "Stopped server on $ports in $session"
