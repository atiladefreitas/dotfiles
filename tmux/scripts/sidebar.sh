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
bg='#1d2021'   # sidebar background (gruvbox bg0_h, a shade darker than the panes)

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
  # Sidebar title for the status line (status-left in gruvbox.conf shows it in
  # windows that have a sidebar): exactly as wide as the sidebar, then the
  # border, so the tabs start over the main pane. Styles stay outside the
  # padded parts, padding counts them as text. The border piece is yellow when
  # tmux colours the top of the sidebar's border: the sidebar is active, or
  # (with more than two panes; with two only half the border is coloured) the
  # pane at the top right of it is.
  tmux set -g @sidebar-header "#[bg=$bg]#{?#{@sidebar},#[fg=#fabd2f],#[fg=#ebdbb2]}#[bold]#{p$((width - 4)):#{l:   Sessions}}#[nobold]#[fg=#928374]#{p-3:#{server_sessions}} #[bg=default]#{?#{||:#{@sidebar},#{&&:#{>:#{window_panes},2},#{&&:#{pane_at_top},#{==:#{pane_left},$((width + 1))}}}},#[fg=#fabd2f],#[fg=#3c3836]}│"
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
          pane=$(tmux split-window -hbfd -l "$width" -t "$target" -c '#{pane_current_path}' -P -F '#{pane_id}' "exec $ui") &&
            tmux set -p -t "$pane" @sidebar 1 \; set -p -t "$pane" remain-on-exit on \; \
              set -p -t "$pane" window-style "bg=$bg" \; set -p -t "$pane" window-active-style "bg=$bg"
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
