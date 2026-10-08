#!/usr/bin/env bash
# Usage: picker-stop-server.sh <client_name>
# Called after the cmd+k (User0) binding has opened choose-tree's ":" prompt: types the
# stop command into it so "%%" expands to the highlighted session. Runs in the
# foreground so the picker redraws with the updated @node_port once it's done.
tmux send-keys -K -c "$1" -l 'run-shell "~/dotfiles/tmux/scripts/session-kill-server.sh %%"'
tmux send-keys -K -c "$1" Enter
