#!/usr/bin/env bash
# Outputs JSON for waybar's custom/notification module.
# Reflects dunst state: paused (do-not-disturb) vs active, plus waiting count.

if ! command -v dunstctl >/dev/null 2>&1; then
    printf '{"text":"","tooltip":"dunstctl not installed","class":"missing"}\n'
    exit 0
fi

paused=$(dunstctl is-paused 2>/dev/null)
waiting=$(dunstctl count waiting 2>/dev/null)
waiting=${waiting:-0}

if [ "$paused" = "true" ]; then
    icon="󰂛"
    class="dnd"
    tooltip="Notifications paused"
elif [ "$waiting" -gt 0 ]; then
    icon="󱅫"
    class="waiting"
    tooltip="${waiting} waiting notification(s)"
else
    icon="󰂚"
    class="active"
    tooltip="Notifications on"
fi

printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' \
    "$icon" "$tooltip" "$class"
