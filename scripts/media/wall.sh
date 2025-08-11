#!/bin/bash

# 1. Add a delay to prevent race conditions
sleep 3

# 2. Use $HOME instead of ~ for robustness
WALLPAPER_CACHE_FILE="$HOME/.cache/cwal/cwal"

# Check if the cache file even exists before trying to use it
if [ ! -f "$WALLPAPER_CACHE_FILE" ]; then
    # Exit gracefully if the file isn't there
    exit 1
fi

WALLPAPER="$(cat "$WALLPAPER_CACHE_FILE")"

# 3. Use absolute paths for all commands
HYPRCTL="/usr/bin/hyprctl"
NOTIFY_SEND="/usr/bin/notify-send"

$HYPRCTL hyprpaper preload "$WALLPAPER"
$HYPRCTL hyprpaper wallpaper ",$WALLPAPER"
$NOTIFY_SEND "Wallpaper Script" "Wallpaper has been set."