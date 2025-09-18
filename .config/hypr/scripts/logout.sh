#!/usr/bin/env bash

#// Check if wlogout is already running
if pgrep -x "wlogout" >/dev/null; then
    pkill -x "wlogout"
    exit 0
fi

#// set file variables
scrDir=$(dirname "$(realpath "$0")")
confDir="${HOME}/.config"
wLayout="${confDir}/wlogout/layout"
wlTmplt="${confDir}/wlogout/style.css"

#// Check if config files exist
if [ ! -f "${wLayout}" ] || [ ! -f "${wlTmplt}" ] || [ ! -f "${confDir}/wlogout/colors.css" ]; then
    echo "ERROR: Config files not found..."
    exit 1
fi

#// detect monitor res - with error handling
monitor_info=$(timeout 2s hyprctl -j monitors 2>/dev/null || echo "")
if [ -z "$monitor_info" ]; then
    # Fallback values if hyprctl fails
    x_mon=1920
    y_mon=1080
    hypr_scale=100
else
    x_mon=$(echo "$monitor_info" | jq -r '.[] | select(.focused==true) | .width')
    y_mon=$(echo "$monitor_info" | jq -r '.[] | select(.focused==true) | .height')
    scale_raw=$(echo "$monitor_info" | jq -r '.[] | select(.focused==true) | .scale')

    # Handle scale value - convert to integer (1.0 becomes 100, 1.5 becomes 150, etc.)
    if [ -n "$scale_raw" ] && [ "$scale_raw" != "null" ]; then
        hypr_scale=$(echo "$scale_raw * 100" | bc | cut -d. -f1)
    else
        hypr_scale=100
    fi
fi

# Ensure we have valid values
: ${x_mon:=1920}
: ${y_mon:=1080}
: ${hypr_scale:=100}

# Prevent division by zero
if [ "$hypr_scale" -eq 0 ]; then
    hypr_scale=100
fi

#// Use style 1 layout (6 columns)
wlColms=6
export mgn=$((y_mon * 28 / hypr_scale))
export hvr=$((y_mon * 23 / hypr_scale))

# Ensure minimum values
if [ "${mgn:-0}" -lt 10 ]; then mgn=10; fi
if [ "${hvr:-0}" -lt 10 ]; then hvr=10; fi

#// scale font size
export fntSize=$((y_mon * 2 / 100))
if [ "$fntSize" -lt 12 ]; then fntSize=12; fi

#// Set default button color
export BtnCol="white"

#// eval hypr border radius
hypr_border=10
export active_rad=$((hypr_border * 5))
export button_rad=$((hypr_border * 8))

#// Change to wlogout directory to ensure CSS import works
cd "${confDir}/wlogout"

#// eval config files
wlStyle="$(envsubst <"${wlTmplt}")"

#// launch wlogout
echo "Launching wlogout with columns: $wlColms"
wlogout -b "${wlColms}" -c 0 -r 0 -m 0 --layout "${wLayout}" --css <(echo "${wlStyle}") --protocol layer-shell
