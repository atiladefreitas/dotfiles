#!/bin/bash

if pgrep -x "hyprpanel" > /dev/null; then
    echo "Killing hyprpanel"
    pkill -f hyprpanel
    sleep 0.5  
else
    echo "Starting hyprpanel"
    hyprpanel &
    disown
fi
