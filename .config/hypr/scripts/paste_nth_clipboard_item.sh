#!/usr/bin/env bash

index=$1
history_file="$HOME/.local/share/clipse/clipse_history"

# Simple naive approach: tail down to last $index, then take the first line
# That means index=1 => last line, index=2 => second last line, etc.
contents=$(tail -n "$index" "$history_file" | head -n 1)

# Copy to system clipboard
echo "$contents" | wl-copy
