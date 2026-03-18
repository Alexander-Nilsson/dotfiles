#!/usr/bin/env bash

WALLPAPER_DIR="${HOME}/Documents/wallpaper"

# Ensure swww daemon is running
swww query &>/dev/null || {
  swww-daemon &
  sleep 0.5
}

# Collect images
mapfile -t WALLS < <(find "$WALLPAPER_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | sort)

if [ ${#WALLS[@]} -eq 0 ]; then
  notify-send "Wallpaper Picker" "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi

# Feed into rofi with thumbnail icons (fixed with printf)
chosen=$(
  for wall in "${WALLS[@]}"; do
    printf "%s\0icon\x1f%s\n" "$(basename "$wall")" "$wall"
  done | rofi -dmenu -i \
    -p " Wallpaper" \
    -theme-str 'window {width: 900px;} listview {columns: 4; lines: 3;} element {orientation: vertical;} element-icon {size: 180px;}' \
    -show-icons
)

[ -z "$chosen" ] && exit 0

# Match chosen basename back to full path
selected=""
for wall in "${WALLS[@]}"; do
  [[ "$(basename "$wall")" == "$chosen" ]] && selected="$wall" && break
done

[ -z "$selected" ] && {
  notify-send "Wallpaper Picker" "Could not find: $chosen"
  exit 1
}
# Set wallpaper with smooth transition
swww img "$selected" \
  --transition-type wipe \
  --transition-angle 30 \
  --transition-duration 1.5 \
  --transition-fps 60

# Save for restore on login
mkdir -p ~/.cache/matugen
echo "$selected" >~/.cache/matugen/last-wallpaper

# Generate and apply Material You colors
matugen --config ~/.config/matugen/config.toml --source-color-index 0 image "$selected"

notify-send "Wallpaper applied" "$(basename "$selected")"
