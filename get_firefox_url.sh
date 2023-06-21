#!/bin/bash

# Get the ID of the currently active window
active_win_id=$(xdotool getactivewindow)

# Get the window ID of the most recently opened Firefox window
firefox_win_id=$(xdotool search --class "firefox" | tail -1)

# Activate the Firefox window
xdotool windowactivate --sync "$firefox_win_id"

# Send Ctrl+l to focus the URL bar
xdotool key --clearmodifiers --window "$firefox_win_id" "ctrl+l"

# Wait for a short moment to allow the URL bar to be focused
sleep 0.2

# Copy the URL to the clipboard
xdotool key --clearmodifiers --window "$firefox_win_id" "ctrl+c"

# Retrieve the URL from the clipboard
firefox_url=$(xclip -selection clipboard -o)

# Print the URL
echo "$firefox_url"

# Return focus to the original window
xdotool windowactivate --sync "$active_win_id"
