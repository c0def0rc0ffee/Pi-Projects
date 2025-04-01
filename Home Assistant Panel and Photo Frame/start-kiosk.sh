#!/bin/bash

# Define the URL
URL="http://0.0.0.0:8123/remote-control-panel/0"

# kill any existing chromium process
pkill -o -f chromium
sleep 2

chromium-browser --kiosk --disable-pinch --disable-translate --noerrdialogs --disable-infobars --disable-session-crashed-bubble --disble-component-update --app="http://0.0.0.0:8123/remote-control-panel/0"


