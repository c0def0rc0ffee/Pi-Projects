#!/bin/bash
sleep 5

unclutter &
# Start feh-killer script in the background (kills feh on touch)
bash touch-to-kill-feh.sh &
#sleep 2
# Start feh-resurrect script in the background (restarts feh every 15 mins)
bash auto-restart-feh.sh &
sleep 2
# Start chromium
bash start-kiosk.sh &

# Keep script running to prevent termination
wait
