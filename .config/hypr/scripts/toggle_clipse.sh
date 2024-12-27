#!/bin/bash
if pgrep -x "clipse" > /dev/null; then
    pkill -x "clipse"
else
    kitty --class clipse -e 'clipse' &
fi
