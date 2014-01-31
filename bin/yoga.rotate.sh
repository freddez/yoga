#!/bin/bash
if  [ $(xrandr -q | grep -c "eDP1 connected primary 3200x1800") -ne 0 ]
then
    xrandr --screen 0 -o right
    xinput set-prop 'ELAN Touchscreen' 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
    xinput disable 'SynPS/2 Synaptics TouchPad'
else
    xrandr --screen 0 -o normal
    xinput set-prop 'ELAN Touchscreen' 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1
    # xinput set-prop –type=int –format=8 "ELAN Touchscreen" "Evdev Axes Swap" 0
    # xinput set-prop –type=int –format=8 "ELAN Touchscreen" "Evdev Axis Inversion" 0 0
    xinput enable 'SynPS/2 Synaptics TouchPad'
fi

