#!/usr/bin/env bash

# Nerd Font icons
ICON_VOL_MUTE="󰝟"   # nf-fa-volume_off
ICON_VOL_LOW=""    # nf-fa-volume_down
ICON_VOL_MID=""    # nf-fa-volume_down
ICON_VOL_HIGH=""   # nf-fa-volume_up

ICON_MIC_ON=""     # nf-fa-microphone
ICON_MIC_OFF=""    # nf-fa-microphone_slash

# Get volume
get_volume() {
	volume=$(pamixer --get-volume)
	echo "$volume"
}

# Choose volume icon
get_icon() {
	current=$(get_volume)
	if [[ "$current" -eq 0 ]]; then
		icon="$ICON_VOL_MUTE"
	elif [[ "$current" -le 30 ]]; then
		icon="$ICON_VOL_LOW"
	elif [[ "$current" -le 60 ]]; then
		icon="$ICON_VOL_MID"
	else
		icon="$ICON_VOL_HIGH"
	fi
}

# Notify with volume info
notify_user() {
	get_icon
	volume=$(get_volume)
	notify-send -h string:x-canonical-private-synchronous:sys-notify \
	            -u low \
	            "${icon} Volume: ${volume}%"
}

# Increase Volume
inc_volume() {
	pamixer -i 5 && notify_user
}

# Decrease Volume
dec_volume() {
	pamixer -d 5 && notify_user
}

# Toggle mute
toggle_mute() {
	if [ "$(pamixer --get-mute)" == "false" ]; then
		pamixer -m && notify-send -h string:x-canonical-private-synchronous:sys-notify \
		                          -u low \
		                          "${ICON_VOL_MUTE} Volume muted"
	else
		pamixer -u && notify_user
	fi
}

# Toggle microphone mute
toggle_mic() {
	if [ "$(pamixer --default-source --get-mute)" == "false" ]; then
		pamixer --default-source -m && notify-send -h string:x-canonical-private-synchronous:sys-notify \
		                                      -u low \
		                                      "${ICON_MIC_OFF} Microphone muted"
	else
		pamixer --default-source -u && notify-send -h string:x-canonical-private-synchronous:sys-notify \
		                                      -u low \
		                                      "${ICON_MIC_ON} Microphone unmuted"
	fi
}

# Get microphone icon (currently just one)
get_mic_icon() {
	muted=$(pamixer --default-source --get-mute)
	if [[ "$muted" == "true" ]]; then
		echo "$ICON_MIC_OFF"
	else
		echo "$ICON_MIC_ON"
	fi
}

# Notify mic volume
notify_mic_user() {
	icon=$(get_mic_icon)
	volume=$(pamixer --default-source --get-volume)
	notify-send -h string:x-canonical-private-synchronous:sys-notify \
	            -u low \
	            "${icon} Mic Level: ${volume}%"
}

# Increase MIC Volume
inc_mic_volume() {
	pamixer --default-source -i 5 && notify_mic_user
}

# Decrease MIC Volume
dec_mic_volume() {
	pamixer --default-source -d 5 && notify_mic_user
}

# Execute accordingly
case "$1" in
	--get) get_volume ;;
	--inc) inc_volume ;;
	--dec) dec_volume ;;
	--toggle) toggle_mute ;;
	--toggle-mic) toggle_mic ;;
	--get-icon) get_icon ;;
	--get-mic-icon) get_mic_icon ;;
	--mic-inc) inc_mic_volume ;;
	--mic-dec) dec_mic_volume ;;
	*) get_volume ;;
esac
