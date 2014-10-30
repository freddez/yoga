#!/bin/sh
# Switch between 3 orientations
state=$(xrandr -q|grep eDP1|cut -d' ' -f5)
case $state in
    inverted)
	xrandr -o normal
	xinput set-prop 'ELAN Touchscreen' 'Coordinate Transformation Matrix' 1 0 0 0 1 0 0 0 1
	#xinput enable 'SynPS/2 Synaptics TouchPad'
	;;
    right)
	xrandr -o inverted
	xinput set-prop 'ELAN Touchscreen' 'Coordinate Transformation Matrix' -1 0 1 0 -1 1 0 0 1
	#xinput disable 'SynPS/2 Synaptics TouchPad'
	;;
    *)
	xrandr --screen 0 -o right
	xinput set-prop 'ELAN Touchscreen' 'Coordinate Transformation Matrix' 0 1 0 -1 0 1 0 0 1
	#xinput disable 'SynPS/2 Synaptics TouchPad'
	;;
esac

