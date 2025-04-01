#!/bin/bash

#time (in seconds) before checking f feh is running

CHECK_INTERVAL=120

check_feh() {
	if ! pgrep -x "feh" > /dev/null; then
		#echo "$(date) - Feh not running, restarting..." >> /tmp/feh.log
		feh --zoom fill --slideshow-delay 25 --fullscreen --hide-pointer --randomize ./Pictures/Holiday ./Pictures/Others &
	fi
}

while true; do
	check_feh
	sleep $CHECK_INTERVAL
done
