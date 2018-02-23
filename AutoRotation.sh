#!/bin/bash

# This script enable auto rotation of the spectre x360 screen

# Get the screen name from xrandr
screen=$(xrandr | grep -w "connected" | awk '{print $1;}')
echo "Auto recognize screen : "$screen
