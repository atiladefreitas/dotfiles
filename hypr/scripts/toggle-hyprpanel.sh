#!/bin/bash
# ~/.config/hypr/scripts/toggle-panel.sh

if hyprctl activewindow | grep -q "workspace: special"; then
    hyprctl keyword layerrule "animation slide top, hyprpanel"
    hyprctl keyword layerrule "noanim, hyprpanel"
else
    hyprctl keyword layerrule "animation slide, hyprpanel"
fi
