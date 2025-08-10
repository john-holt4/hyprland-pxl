#!/usr/bin/env bash

# Nerd Font icons for brightness levels
ICON_20="󰃞"  # nf-mdi-brightness_1
ICON_40="󰃞"  # nf-mdi-brightness_2
ICON_60="󰃟"  # nf-mdi-brightness_3
ICON_80="󰃠"  # nf-mdi-brightness_4
ICON_100="󰃠" # nf-mdi-brightness_5

# Get current brightness as percentage
get_backlight() {
    current=$(brightnessctl g)
    max=$(brightnessctl m)
    percent=$(awk "BEGIN { printf(\"%d\", ($current / $max) * 100) }")
    echo "$percent"
}

# Choose appropriate icon
get_icon() {
    current_percent=$(get_backlight)
    if [[ "$current_percent" -le 20 ]]; then
        icon="$ICON_20"
    elif [[ "$current_percent" -le 40 ]]; then
        icon="$ICON_40"
    elif [[ "$current_percent" -le 60 ]]; then
        icon="$ICON_60"
    elif [[ "$current_percent" -le 80 ]]; then
        icon="$ICON_80"
    else
        icon="$ICON_100"
    fi
}

# Send notification with icon and percentage
notify_user() {
    get_icon
    percent=$(get_backlight)
    notify-send -h string:x-canonical-private-synchronous:sys-notify \
                -u low \
                "${icon} Brightness: ${percent}%"
}

# Increase brightness
inc_backlight() {
    brightnessctl s +5% && notify_user
}

# Decrease brightness
dec_backlight() {
    brightnessctl s 5%- && notify_user
}

# Execute command
case "$1" in
    --get) get_backlight ;;
    --inc) inc_backlight ;;
    --dec) dec_backlight ;;
    *) get_backlight ;;
esac
