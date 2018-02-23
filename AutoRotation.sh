#!/bin/bash

# This script enable auto rotation of the spectre x360 screen

# Get the screen name from xrandr
screen=$(xrandr | grep 'connected' |grep -v 'disconnected' | grep -oE '[a-zA-Z]+[\-]+[^ ]') #this seems also to work and print the VGA-1 / eDP-1
echo 'Auto Recognize screen {alt}:' $screen
