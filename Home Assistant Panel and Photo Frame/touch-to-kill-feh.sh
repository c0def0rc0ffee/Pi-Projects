#!/bin/bash
EVENT_PATH=$(grep -1 "10-005d Goodix Capacitive TouchScreen" /sys/class/input/event*/device/name | awk -F: '{print $1}' | sed -E 's:.*/(event[0-9]+)/device/name$:/dev/input/\1:')
EVENT_PATH=$(echo "$EVENT_PATH" | cut -d' ' -f1)
echo "$EVENT_PATH"
#evtest /dev/input/event6 - Looks like this
sudo evtest "$EVENT_PATH" | while read line; do
	#xdotool click 1
	pkill feh
done
