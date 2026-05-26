#!/usr/bin/env bash
# Power menu. Tries walker -> rofi -> wofi so it matches whatever
# launcher the rest of the dotfiles use.

options="\
󰌾  Lock
󰗽  Logout
󰒲  Suspend
󰜉  Reboot
󰐥  Shutdown"

if command -v walker >/dev/null 2>&1; then
    choice=$(printf '%s\n' "$options" | walker --dmenu --placeholder "Power")
elif command -v rofi >/dev/null 2>&1; then
    choice=$(printf '%s\n' "$options" | rofi -dmenu -p "Power" -theme-str 'window {width: 240px;}')
elif command -v wofi >/dev/null 2>&1; then
    choice=$(printf '%s\n' "$options" | wofi --dmenu --prompt "Power" --width 240 --height 260 --cache-file /dev/null)
else
    notify-send -u critical "Power menu" "No launcher installed (walker/rofi/wofi)"
    exit 1
fi

case "$choice" in
    *Lock*)     exec hyprlock ;;
    *Logout*)   exec hyprctl dispatch exit ;;
    *Suspend*)  exec systemctl suspend ;;
    *Reboot*)   exec systemctl reboot ;;
    *Shutdown*) exec systemctl poweroff ;;
esac
