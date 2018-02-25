#!/bin/bash

# This script enable auto rotation of the spectre x360 screen

# Get the screen name from xrandr
screen=$(xrandr | grep -w "connected" | awk '{print $1}')
echo "Auto recognize screen : "$screen

# Get ID of touchscreen, pen and touchpad
touchscreenID=$(xinput --list | grep -w "ELAN2514:00 04F3:2593  " | awk '{match($0,"id=[[:digit:]]{,2}",a)}END{print a[0]}')
touchscreenPenID=$(xinput --list | grep Pen | awk '{match($0,"id=[[:digit:]]{,2}",a)}END{print a[0]}')
touchpadID=$(xinput --list | grep Synaptics | awk '{match($0,"id=[[:digit:]]{,2}",a)}END{print a[0]}')
echo $touchscreenID
echo $touchscreenPenID
echo $touchpadID

# Clear sensor.log
>sensor.log

# Lauch monitor-sensor and write value in sensor.log
monitor-sensor >> sensor.log &

# Watch sensor.log for modification
while inotifywait -qq -e modify sensor.log; do

# Parse sensor.log to get screen orientation
orientation=$(tail -n 1 sensor.log | grep "orientation" | awk '{print $4}')

# case statement to rotate screen
case $orientation in
    normal)
	xrandr --output $screen --rotate normal ;;
    bottom-up)
	xrandr --output $screen --rotate inverted ;;
    right-up)
	xrandr --output $screen --rotate right ;;
    left-up)
	xrandr --output $screen --rotate left ;;
esac

# End of while loop
done
