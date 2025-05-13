#!/bin/bash
sleep 5

# Start feh-killer (logs optional)
nohup bash /home/rob/touch-to-kill-feh.sh > /home/rob/logs/feh-killer.log 2>&1 &

sleep 2

# Start feh auto-restart (every 15 min)
nohup bash /home/rob/auto-restart-feh.sh > /home/rob/logs/feh-resurrect.log 2>&1 &

# Start Chromium in kiosk mode
nohup bash /home/rob/start-kiosk.sh > /home/rob/logs/chromium.log 2>&1 &

exit 0
