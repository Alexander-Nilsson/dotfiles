#!/usr/bin/env bash
WALLPAPER_DIR="${HOME}/Documents/wallpaper"
# --- Ensure awww daemon is running ---
if ! awww query &>/dev/null; then
  pkill -x awww-daemon 2>/dev/null
  rm -f /run/user/$(id -u)/awww*
  awww-daemon &
  for i in $(seq 1 20); do
    awww query &>/dev/null && break
    sleep 0.1
  done
fi
# --- Collect images ---
mapfile -t WALLS < <(find "$WALLPAPER_DIR" -type f \
  \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.gif" \) | shuf)
if [ ${#WALLS[@]} -eq 0 ]; then
  notify-send --app-name="wallpaper" --urgency=low \
    --hint=string:x-dunst-stack-tag:wallpaper \
    "Wallpaper Picker" "No wallpapers found in $WALLPAPER_DIR"
  exit 1
fi
# --- Rofi picker with thumbnails ---
chosen=$(
  for wall in "${WALLS[@]}"; do
    printf "%s\0icon\x1f%s\n" "$(basename "$wall")" "$wall"
  done | rofi -dmenu -i \
    -p " Wallpaper" \
    -theme-str 'window {width: 900px;} listview {columns: 4; lines: 3;} element {orientation: vertical;} element-icon {size: 180px;}' \
    -show-icons
)
[ -z "$chosen" ] && exit 0
# --- Match chosen basename back to full path ---
selected=""
for wall in "${WALLS[@]}"; do
  [[ "$(basename "$wall")" == "$chosen" ]] && selected="$wall" && break
done
[ -z "$selected" ] && {
  notify-send --app-name="wallpaper" --urgency=low \
    --hint=string:x-dunst-stack-tag:wallpaper \
    "Wallpaper Picker" "Could not find: $chosen"
  exit 1
}
# --- Set wallpaper with smooth transition ---
awww img "$selected" \
  --transition-type wipe \
  --transition-angle 30 \
  --transition-duration 1.5 \
  --transition-fps 60
# --- Save for restore on login ---
mkdir -p ~/.cache/matugen
echo "$selected" >~/.cache/matugen/last-wallpaper
# --- Generate and apply Material You colors ---
matugen --config ~/.config/matugen/config.toml --source-color-index 0 image "$selected"
# --- Sync Hyprland border colors from matugen output ---
COLORS_JSON="${HOME}/.config/matugen/colors.json"
if command -v jq &>/dev/null && [ -f "$COLORS_JSON" ]; then
  active=$(jq -r '.colors.light.primary // .colors.dark.primary // empty' "$COLORS_JSON" 2>/dev/null)
  inactive=$(jq -r '.colors.light.outline // .colors.dark.outline // empty' "$COLORS_JSON" 2>/dev/null)
  if [ -n "$active" ] && [ -n "$inactive" ]; then
    active="${active//#/}"
    inactive="${inactive//#/}"
    hyprctl keyword general:col.active_border "rgba(${active}ff)" 2>/dev/null
    hyprctl keyword general:col.inactive_border "rgba(${inactive}88)" 2>/dev/null
  fi
fi
# --- Reload waybar to pick up new colors ---
if pgrep -x waybar &>/dev/null; then
  killall -SIGUSR2 waybar 2>/dev/null
fi
# --- Notify (no action buttons, replaces previous notification) ---
notify-send \
  --app-name="wallpaper" \
  --urgency=low \
  --expire-time=3000 \
  --hint=string:x-dunst-stack-tag:wallpaper \
  "Wallpaper applied" "$(basename "$selected")"
