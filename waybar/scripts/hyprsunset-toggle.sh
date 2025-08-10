#!/bin/bash

# Nerd Font Icons
ICON_DAY="  Daytime"   # nf-fa-sun_o
ICON_NIGHT="  Nighttime" # nf-fa-moon_o

# --- CONFIGURATION ---
# IMPORTANT: Make these times match your ~/.config/hypr/hyprsunset.conf
SUNRISE_TIME="6:00"
SUNSET_TIME="17:00"

# --- TOGGLE LOGIC (No changes needed here) ---
if [[ "$1" == "--toggle" ]]; then
    if pgrep -x "hyprsunset" > /dev/null; then
        killall hyprsunset
    else
        hyprsunset &
    fi
    exit 0
fi

# --- DISPLAY LOGIC (This is the corrected part) ---

# Get current time in HHMM format (e.g., 1749)
CURRENT_TIME=$(date +%H%M)
# Convert config times to HHMM format
SUNRISE_HHMM=$(date -d "$SUNRISE_TIME" +%H%M)
SUNSET_HHMM=$(date -d "$SUNSET_TIME" +%H%M)

# Check if the current time is between sunset and sunrise
# By adding "10#" we force bash to treat the values as base-10 numbers
if [[ "10#$CURRENT_TIME" -ge "10#$SUNSET_HHMM" || "10#$CURRENT_TIME" -lt "10#$SUNRISE_HHMM" ]]; then
    # It's nighttime
    printf '{"text":"%s", "tooltip":"Night Light: Active", "class":"on"}\n' "$ICON_NIGHT"
else
    # It's daytime
    printf '{"text":"%s", "tooltip":"Night Light: Inactive", "class":"off"}\n' "$ICON_DAY"
fi