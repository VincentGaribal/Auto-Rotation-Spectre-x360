#!/bin/bash

# This script enable auto rotation of the spectre x360 screen

# Get the screen name from xrandr
screen=$(xrandr | grep -w "connected" | awk '{print $1}')
echo "Auto recognize screen : "$screen

# Names of touchscreen, pen and touchpad
touchscreen="ELAN2514:00 04F3:2593"
touchscreenPen="ELAN2514:00 04F3:2593 Pen"
touchpad="SynPS/2 Synaptics TouchPad"

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
	xrandr --output $screen --rotate normal
	xinput set-prop "$touchscreen" 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1
	xinput set-prop "$touchscreenPen" 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1;;
    bottom-up)
	xrandr --output $screen --rotate inverted
	xinput set-prop "$touchscreen" 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1
	xinput set-prop "$touchscreenPen" 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1;;
    right-up)
	xrandr --output $screen --rotate right
	xinput set-prop "$touchscreen" 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
	xinput set-prop "$touchscreenPen" 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1;;
    left-up)
	xrandr --output $screen --rotate left
	xinput set-prop "$touchscreen" 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1
	xinput set-prop "$touchscreenPen" 'Coordinate Transformation Matrix' 0 -1 1 1 0 0 0 0 1;;
esac

# End of while loop
done
