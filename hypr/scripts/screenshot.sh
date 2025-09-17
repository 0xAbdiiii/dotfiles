#!/usr/bin/env bash

# Create secure temporary file
temp_screenshot=$(mktemp -t screenshot_XXXXXX.png)

# Configuration - User Variables
XDG_PICTURES_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"
save_dir="${save_dir:-$XDG_PICTURES_DIR/Screenshots}"
mkdir -p "$save_dir"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')

# Annotation Tool Selection - Only use satty if available
annotation_tool=""
if command -v satty &> /dev/null; then
    annotation_tool="satty"
else
    echo "Warning: satty not found. Screenshots will be saved directly."
fi
echo "DEBUG: Selected annotation tool is: '$annotation_tool'"

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to take a screenshot using grim and slurp directly
take_screenshot() {
    local mode=$1
    local freeze=$2 # Not used with grim directly, but kept for compatibility

    case "$mode" in
        "screen")
            # Capture entire screen
            grim "$temp_screenshot"
            ;;
        "output")
            # Capture focused monitor (simplified)
            # This gets the name of the focused monitor from Hyprland
            focused_monitor=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')
            if [ -n "$focused_monitor" ]; then
                grim -o "$focused_monitor" "$temp_screenshot"
            else
                grim "$temp_screenshot" # Fallback to full screen
            fi
            ;;
        "area")
            # Capture selected area - use slurp to get geometry first
            geometry=$(slurp -b 00000080 -c 8aadf4)
            # Wait a moment for the slurp selection to disappear
            sleep 0.1
            # Now capture the area
            grim -g "$geometry" "$temp_screenshot"
            ;;
        *)
            echo "Invalid mode: $mode"
            return 1
            ;;
    esac
}

# Function to handle OCR
ocr_screenshot() {
    take_screenshot "area"
    if ! command_exists tesseract; then
        notify-send -a "Screenshot" "OCR Error" "Tesseract is not installed." -u critical
        return 1
    fi
    if command_exists magick; then
        magick "${temp_screenshot}" \
            -colorspace gray \
            -contrast-stretch 0 \
            -level 15%,85% \
            -resize 400% \
            -sharpen 0x1 \
            -auto-threshold triangle \
            -morphology close diamond:1 \
            -deskew 40% \
            "${temp_screenshot}"
    else
        notify-send -a "Screenshot" "OCR" "ImageMagick not found, processing with default image." -u low
    fi

    tesseract "${temp_screenshot}" - | wl-copy
    recognized_text=$(wl-paste)
    notify-send -a "Screenshot OCR" "Text Copied to Clipboard" "Recognized ${#recognized_text} characters." -i "$temp_screenshot"
}

# Main execution logic
case "${1}" in
    "p") # Print all outputs (full screen)
        take_screenshot "screen"
        ;;
    "s") # Select area or window
        take_screenshot "area"
        ;;
    "sf") # Select area on frozen screen (same as 's' for this simple version)
        take_screenshot "area"
        ;;
    "m") # Print focused monitor
        take_screenshot "output"
        ;;
    "sc") # OCR
        ocr_screenshot
        exit 0 # Exit early as OCR handles its own flow
        ;;
    *)
        echo "Usage: $0 {p|s|sf|m|sc}"
        echo "  p  - Print screen"
        echo "  s  - Select area"
        echo "  sf - Select area (frozen)"
        echo "  m  - Capture monitor"
        echo "  sc - OCR (text recognition)"
        exit 1
        ;;
esac

# Annotate or save the screenshot
if [ -f "$temp_screenshot" ]; then
    if [[ -n "$annotation_tool" ]]; then
        # Open the screenshot in the annotation tool
        if "$annotation_tool" --disable-notifications --filename "$temp_screenshot" --output-filename "${save_dir}/${save_file}"; then
            # Satty saved the file directly
            if [ -f "${save_dir}/${save_file}" ]; then
                notify-send -a "Screenshot" "Screenshot Saved" "${save_dir}/${save_file}" -i "${save_dir}/${save_file}"
            fi
        else
            notify-send -a "Screenshot" "Annotation Error" "Failed to open annotation tool. Saving directly." -u normal
            cp "$temp_screenshot" "${save_dir}/${save_file}"
            notify-send -a "Screenshot" "Screenshot Saved" "${save_dir}/${save_file}" -i "${save_dir}/${save_file}"
        fi
    else
        # No annotation tool, just save the file
        cp "$temp_screenshot" "${save_dir}/${save_file}"
        notify-send -a "Screenshot" "Screenshot Saved" "${save_dir}/${save_file}" -i "${save_dir}/${save_file}"
    fi
fi

# Cleanup
rm -f "${temp_screenshot}"
