#!/usr/bin/env bash

killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.5; done

for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
  MONITOR=$m polybar main --config="$HOME/.config/polybar/config.ini" &
done

echo "Polybar launched on all monitors"
