#!/bin/bash
# Disable laptop screen
hyprctl keyword monitor "eDP-1,disable"

# Force external monitor to stay at full refresh rate
hyprctl keyword monitor "HDMI-A-1,2560x1440@144,3840x0,1"

# Disable DPMS for external monitor
hyprctl dispatch dpms on HDMI-A-1

# Reset hypridle
killall -SIGUSR1 hypridle
