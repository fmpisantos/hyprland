#!/bin/bash

# Initialize bar_visible based on whether Waybar is running
if pgrep -x waybar > /dev/null; then
  bar_visible=true
else
  bar_visible=false
fi

while true; do
  read -r X Y < <(hyprctl cursorpos)

  if [ "$Y" -lt 25 ]; then
    if [ "$bar_visible" = false ]; then
      pkill waybar 2>/dev/null
      waybar &
      bar_visible=true
    fi
  else
    if [ "$bar_visible" = true ]; then
      pkill waybar 2>/dev/null
      bar_visible=false
    fi
  fi

  sleep 0.5
done
