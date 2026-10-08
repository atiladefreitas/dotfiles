#!/usr/bin/env bash
# Usage: sidebar.sh sync | toggle | refresh | drag-end <window>
# Manages the session sidebar: a pane running sidebar-ui.zsh on the left of
# every window, marked with the @sidebar pane option.
#   sync      adds the sidebar where it's missing (while @sidebar-enabled is 1),
#             snaps it back to @sidebar-width and closes windows where only
#             the sidebar is left. Run from hooks after layout changes.
#   toggle    shows/hides the sidebar in every window (prefix b).
#   refresh   wakes the sidebars on screen so they redraw right away.
#   drag-end  after a border drag, makes the dragged sidebar's width the
#             width of every sidebar.
ui=~/dotfiles/tmux/scripts/sidebar-ui.zsh

opt() { tmux show -gqv "$1"; }

# The UI blocks on reading keys (signals don't interrupt zsh's read), so it is
# woken with a key it treats as "reload": F12.
refresh() {
  for pane in $(tmux list-panes -a -f '#{&&:#{@sidebar},#{&&:#{window_active},#{session_attached}}}' -F '#{pane_id}' 2>/dev/null); do
    tmux send-keys -t "$pane" F12
  done
}

sync_all() {
  # Hooks fire in bursts (new-window also triggers the split that adds the
  # sidebar); one sync at a time so two never add a sidebar to the same window.
  # The lock sits next to the server socket; one older than 10s is left over
  # from a sync that died.
  lock="${TMUX%%,*}.sidebar-lock"
  until mkdir "$lock" 2>/dev/null; do
    [ $(( $(date +%s) - $(stat -f %m "$lock" 2>/dev/null || date +%s) )) -gt 10 ] && rmdir "$lock" 2>/dev/null
    sleep 0.1
  done
  trap 'rmdir "$lock"' EXIT
  width=$(opt @sidebar-width)
  width=${width:-34}
  tmux list-panes -a -F '#{window_id} #{?#{@sidebar},1,0} #{pane_id} #{pane_width} #{window_width} #{window_zoomed_flag}' 2>/dev/null |
    awk -v w="$width" -v on="$(opt @sidebar-enabled)" '
      !($1 in seen) { seen[$1]; order[++n] = $1 }
      $2 == 1 {
        if ($1 in sb) print "kill-pane", $3
        else { sb[$1] = $3; if ($4 != w && !$6) fix[$1] }
        next
      }
      { main[$1]++; ww[$1] = $5 }
      END {
        for (i = 1; i <= n; i++) {
          win = order[i]
          if (!main[win]) print "kill-window", win
          else if (!(win in sb)) { if (on == 1 && ww[win] >= 2 * w) print "add", win }
          else if (win in fix) print "resize", sb[win]
        }
      }' |
    while read -r action target; do
      case $action in
        add)
          bg=$(opt @sidebar-bg)
          pane=$(tmux split-window -hbfd -l "$width" -t "$target" -c '#{pane_current_path}' -P -F '#{pane_id}' "exec $ui") &&
            tmux set -p -t "$pane" @sidebar 1 \; set -p -t "$pane" remain-on-exit on \; \
              set -p -t "$pane" window-style "bg=${bg:-default}" \; set -p -t "$pane" window-active-style "bg=${bg:-default}"
          ;;
        resize) tmux resize-pane -t "$target" -x "$width" ;;
        *) tmux "$action" -t "$target" ;;
      esac
    done
  refresh
}

toggle() {
  if [ "$(opt @sidebar-enabled)" = 1 ]; then
    tmux set -g @sidebar-enabled 0
    for pane in $(tmux list-panes -a -f '#{@sidebar}' -F '#{pane_id}'); do
      tmux kill-pane -t "$pane"
    done
  else
    tmux set -g @sidebar-enabled 1
    sync_all
  fi
}

drag_end() {
  width=$(tmux list-panes -t "$1" -f '#{@sidebar}' -F '#{pane_width}' 2>/dev/null | head -1)
  [ -n "$width" ] && [ "$width" != "$(opt @sidebar-width)" ] || return 0
  tmux set -g @sidebar-width "$width"
  sync_all
}

case $1 in
  sync) sync_all ;;
  toggle) toggle ;;
  refresh) refresh ;;
  drag-end) drag_end "$2" ;;
  *) echo "usage: sidebar.sh sync | toggle | refresh | drag-end <window>" >&2; exit 1 ;;
esac
