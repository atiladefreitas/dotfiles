#!/usr/bin/env bash
# Outputs JSON for waybar's custom/network module.
# Picks the icon based on the interface backing the active default route:
#   ethernet (en*/eth*) → 󰈀
#   wireless  (wl*/wlan*) →
#   none → 󰤭

dev=$(ip route show default 2>/dev/null | awk '/^default/ {print $5; exit}')

case "$dev" in
    en*|eth*)
        icon="󰈀 "
        tooltip="Ethernet: $dev"
        class="ethernet"
        ;;
    wl*|wlan*)
        icon=""
        ssid=$(iwctl station "$dev" show 2>/dev/null | awk -F'  +' '/Connected network/ {print $3; exit}')
        tooltip="Wi-Fi: ${ssid:-$dev}"
        class="wifi"
        ;;
    *)
        icon="󰤭 "
        tooltip="Disconnected"
        class="disconnected"
        ;;
esac

printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' \
    "$icon" "$tooltip" "$class"
