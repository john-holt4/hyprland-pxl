#!/bin/bash

# Wofi Command
wofi_command="wofi --show dmenu \
--prompt=Power Menu \
--width=210 --height=220 \
-b \
-j \
-y 755 \
-x 5 \
--style=$HOME/.config/wofi/style.css \
--conf=$HOME/.config/wofi/config"

# Options
options="Shutdown\nReboot\nLogout\nUpdate"

# Execute wofi
chosen=$(echo -e "$options" | $wofi_command)

# Execute Command
case ${chosen} in
    "Shutdown")
        systemctl poweroff
        ;;
    "Reboot")
        systemctl reboot
        ;;
    "Logout")
        hyprctl dispatch exit
        ;;
    "Update")
        kitty -e paru
        ;;
esac
