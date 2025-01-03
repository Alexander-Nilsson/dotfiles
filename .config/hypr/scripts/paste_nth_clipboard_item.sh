#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <index>"
  exit 1
fi

# Assign the first argument to the variable 'index'
index=$1

# Define the path to the JSON file
json_file="$HOME/.config/clipse/clipboard_history.json"

# Check if the JSON file exists
if [ ! -f "$json_file" ]; then
  echo "Error: File '$json_file' not found."
  exit 1
fi

# Extract the 'value' field of the nth item using jq
value=$(jq -r --argjson index "$index" '.clipboardHistory[$index].value' "$json_file")

# Check if jq encountered an error (e.g., index out of range)
if [ "$value" == "null" ]; then
  echo "Error: No item found at index $index."
  exit 1
fi

# Copy the extracted value to the system clipboard using wl-copy
echo -n "$value" | wl-copy

# todo paste
#wl-paste | wl-copy

sleep 0.1 # without this the remove step happens before the index is updated
#wl-paste | xdotool key ctrl+shift+v

# Create a temporary file
temp_file=$(mktemp)

# Attempt to remove the first item from the clipboardHistory array and write to the temporary file
if jq 'del(.clipboardHistory[0])' "$json_file" > "$temp_file"; then
  # If successful, move the temporary file to overwrite the original JSON file
  mv "$temp_file" "$json_file"
  #echo "Copied item at index $index to the clipboard and removed index 0 from the history."
else
  # If jq fails, remove the temporary file and print an error message
  rm "$temp_file"
  echo "Error: Failed to update the JSON file."
  exit 1
fi

#paste item

