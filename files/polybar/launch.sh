#!/bin/sh

# Terminate already running bar instances & wait until shut down
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

primary=$(xrandr | grep primary | cut -d " " -f1)

for m in $(polybar --list-monitors | cut -d":" -f1); do
    if [ "$m" = "$primary" ]; then
        TRAY="right"
    else
        TRAY="none"
    fi

    MONITOR=$m TRAY=$TRAY polybar main &
done
