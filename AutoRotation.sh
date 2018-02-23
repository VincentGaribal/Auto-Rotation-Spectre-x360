#!/bin/bash

# This script enable auto rotation of the spectre x360 screen

# Get the screen name from xrandr
screen=$(xrandr | grep -w "connected" | awk '{print $1}')
echo "Auto recognize screen : "$screen

# Clear sensor.log
>sensor.log

# Lauch monitor-sensor and write value in sensor.log
monitor-sensor >> sensor.log &

# Watch sensor.log for modification
while inotifywait -qq -e modify sensor.log; do

# Parse sensor.log to get screen orientation
orientation=$(tail -n 1 sensor.log | grep "orientation" | awk '{print $4}')
echo $orientation

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
