#!/bin/bash

# --- Configuration ---
# Set your preferred swww options.
# See "man swww" for all options.
# Example: grow, center, any, random, left, right, top, bottom
TRANSITION_TYPE="center"
TRANSITION_STEP=90
TRANSITION_FPS=60
# ---------------------

# Check if an image path is provided
if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/image.jpg"
  exit 1
fi

IMAGE_PATH="$1"

# Set the wallpaper using swww
echo " Setting wallpaper: $IMAGE_PATH"
swww img "$IMAGE_PATH" --transition-type "$TRANSITION_TYPE" --transition-step "$TRANSITION_STEP" --transition-fps "$TRANSITION_FPS"

# Generate and apply the color scheme using cwal
echo "🎨 Generating color theme with cwal..."
# CORRECTED LINE: Using --img instead of -i
cwal --img "$IMAGE_PATH"

echo "🔄 Restarting Waybar to apply new colors..."
killall -q waybar && (waybar &> /dev/null &)

echo "✅ Done."