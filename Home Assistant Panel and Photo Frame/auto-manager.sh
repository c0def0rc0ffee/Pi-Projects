#!/bin/bash
sleep 5

# Start feh-killer (logs optional)
nohup bash /home/pi/touch-to-kill-feh.sh > /home/pi/logs/feh-killer.log 2>&1 &

sleep 2

# Start feh auto-restart (every 15 min)
nohup bash /home/pi/auto-restart-feh.sh > /home/pi/logs/feh-resurrect.log 2>&1 &

# Start Chromium in kiosk mode
nohup bash /home/pi/start-kiosk.sh > /home/pi/logs/chromium.log 2>&1 &

exit 0
