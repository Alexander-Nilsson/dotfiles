#!/usr/bin/env bash

LAST="${HOME}/.cache/matugen/last-wallpaper"

# Wait for swww daemon to be ready
sleep 1

if [ -f "$LAST" ] && [ -f "$(cat "$LAST")" ]; then
  swww img "$(cat "$LAST")" --transition-type fade --transition-duration 1
  matugen --source-color-index 0 image "$(cat "$LAST")"
fi
