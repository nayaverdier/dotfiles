#!/bin/sh

# Terminate already running bar instances & wait until shut down
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

primary=$(xrandr | grep primary | cut -d " " -f1)

while read monitor_line; do
    monitor=$(echo $monitor_line | cut -d":" -f1)
    width=$(echo $monitor_line | cut -d" " -f2 | cut -d"x" -f1)
    width=$(( width - {{ (window_gap + screen_gap) * dpi_scale }} ))

    if [ "$monitor" = "$primary" ]; then
        TRAY="center"
    else
        TRAY="none"
    fi

    MONITOR=$monitor WIDTH=$width TRAY=$TRAY polybar main &
done <<<$(polybar --list-monitors)
