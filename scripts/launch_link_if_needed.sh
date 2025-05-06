#!/bin/bash
# Script to switch to a workspace and launch an application if it's not already running on that workspace
# Usage: ./launch_if_needed.sh [app_command] [app_class] [workspace]

APP_COMMAND="$1"
FULL_WORKSPACE="$2"
WORKSPACE="$2"

if [[ "$FULL_WORKSPACE" == *"name:"* ]]; then
    WORKSPACE="${FULL_WORKSPACE#name:}"
fi

APP_ON_WORKSPACE=$(hyprctl clients -j | jq -r ".[] | select(.class == \"firefox\" and .workspace.name == \"$WORKSPACE\") | .address")

if [ -z "$APP_ON_WORKSPACE" ]; then
    hyprctl dispatch workspace "$FULL_WORKSPACE" && hyprctl dispatch exec "firefox --new-window $APP_COMMAND"
else
    hyprctl dispatch workspace "$FULL_WORKSPACE"
fi
