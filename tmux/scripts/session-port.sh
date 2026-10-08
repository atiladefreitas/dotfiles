#!/usr/bin/env bash
# Usage: session-port.sh
# Sets the @node_port session option to "running on <port>[, <port>...]" for
# every session where a node (or next-server/bun/deno) process in one of its
# panes is listening on a TCP port, and unsets it everywhere else.
# The M-s session picker reads @node_port.
panes=$(tmux list-panes -a -F '#{pane_tty} #{session_name}' 2>/dev/null | sed 's#^/dev/##')
[ -z "$panes" ] && exit 0
ttys=$(awk '{ print $1 }' <<<"$panes" | sort -u | paste -sd, -)

# "<pid> <tty>" for every node-ish process on a tmux pane
procs=$(ps -t "$ttys" -o pid=,tty=,comm= 2>/dev/null | awk '$3 ~ /(^|\/)(node|next-server|bun|deno)$/ { print $1, $2 }')
pids=$(awk '{ print $1 }' <<<"$procs" | paste -sd, -)

# "<session> <port>" for every listening socket
[ -n "$pids" ] && listening=$(lsof -nP -a -iTCP -sTCP:LISTEN -Fpn -p "$pids" 2>/dev/null | PROCS="$procs" PANES="$panes" awk '
  BEGIN {
    n = split(ENVIRON["PROCS"], l, "\n"); for (i = 1; i <= n; i++) { split(l[i], f, " "); tty[f[1]] = f[2] }
    n = split(ENVIRON["PANES"], l, "\n"); for (i = 1; i <= n; i++) { t = l[i]; sub(/ .*/, "", t); s = l[i]; sub(/^[^ ]* /, "", s); sess[t] = s }
  }
  /^p/ { pid = substr($0, 2) }
  /^n/ { m = split($0, a, ":"); print sess[tty[pid]] "\t" a[m] }
' | sort -u)

args=()
while IFS= read -r session; do
  ports=$(awk -F'\t' -v s="$session" '$1 == s { print $2 }' <<<"$listening" | sort -un | paste -sd, - | sed 's/,/, /g')
  if [ -n "$ports" ]; then
    args+=(set -t "=$session:" @node_port "running on $ports" \;)
  else
    args+=(set -u -t "=$session:" @node_port \;)
  fi
done < <(tmux list-sessions -F '#{session_name}')

[ ${#args[@]} -gt 0 ] && tmux "${args[@]}"
