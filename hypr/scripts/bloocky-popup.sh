#!/usr/bin/env bash
# Toggle a floating kitty running Bloocky (nvim timeblocking calendar).
# The calendar is widened to fill the popup: bloocky's float width defaults to
# 0.6 of the editor for the week view, which leaves the popup mostly empty.
# 0.98 rather than 1.0 because the rounded border adds 2 columns on top of the
# width, and the day view asks for the full width it is given.

set -euo pipefail

CLASS="bloocky-popup"

PID=$(hyprctl clients -j | jq -r ".[] | select(.class == \"$CLASS\") | .pid")
if [ -n "$PID" ]; then
	kill "$PID"
	exit 0
fi

exec kitty --class "$CLASS" -e nvim \
	-c "lua require('bloocky').setup({ window = { width = 0.98 } })" \
	-c Bloocky
