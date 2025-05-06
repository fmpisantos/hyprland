#!/bin/bash
# Script to switch to a workspace and launch an application if it's not already running on that workspace
# Usage: ./launch_if_needed.sh [app_command] [app_class] [workspace]

APP_PREFIX="$1"
APP_COMMAND="$2"
FULL_WORKSPACE="$3"
WORKSPACE="$3"

if [[ "$FULL_WORKSPACE" == *"name:"* ]]; then
    WORKSPACE="${FULL_WORKSPACE#name:}"
fi

APP_ON_WORKSPACE=$(hyprctl clients -j | jq -r \
  ".[] | select(.class == \"Chromium\" and .workspace.name == \"$WORKSPACE\" and (.initialTitle // \"\" | test(\"$APP_PREFIX\"))) | .address")

if [ -z "$APP_ON_WORKSPACE" ]; then
    hyprctl dispatch workspace "$FULL_WORKSPACE" && hyprctl dispatch exec "chromium --app=$APP_COMMAND"
else
    hyprctl dispatch workspace "$FULL_WORKSPACE"
fi
