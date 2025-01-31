#!/usr/bin/env bash

hidden_on_workspace=$1

hide() {
  killall -SIGUSR1 waybar && touch /tmp/waybar_is_hidden
}

show() {
  if [ -f /tmp/waybar_is_hidden ]; then
    killall -SIGUSR1 waybar && rm /tmp/waybar_is_hidden
  fi
}

sleep 1

current_workspace=$(hyprctl activeworkspace | awk 'match($0, /ID ([0-9]+)/, id){print id[1]}')
[ $hidden_on_workspace -eq $current_workspace ] && hide

#socket_path="/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"
socket_path="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

if [ -z "$socket_path" ]; then
  echo "Error: Hyprland socket not found. Is Hyprland running?"
  exit 1
fi

socat -u "UNIX-CONNECT:$socket_path" STDOUT | while read -r event; do
  case "$event" in
  "workspace>>$hidden_on_workspace") hide ;;
  "workspace>>"*) show ;;
  esac
done

show
