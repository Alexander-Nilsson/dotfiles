#!/usr/bin/env bash

toggle_waybar() {
  killall -SIGUSR1 waybar
}

toggle_waybar
