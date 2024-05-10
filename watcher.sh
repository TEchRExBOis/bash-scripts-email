#!/bin/bash

# Directory to monitor
directory="/home/admin/Maildir/new/"

# Bash script to execute when a new file is added
script_to_run="./script.sh"

# Lock file path
lock_file="/tmp/my_script.lock"

# Check if lock file exists
if [ -e "$lock_file" ]; then
    echo "Another instance is already running. Exiting."
    exit 1
fi

# Create lock file
touch "$lock_file"

# Monitor the directory indefinitely
while true; do
    # Wait for events in the directory
    event=$(inotifywait -q -e create,moved_to --format "%e %w%f" "$directory")

    # Extract event type and filename
    event_type=$(echo "$event" | awk '{print $1}')
    file=$(echo "$event" | awk '{print $2}')

    # Execute the script when a new file is added
    if [ "$event_type" = "CREATE" ] || [ "$event_type" = "MOVED_TO" ]; then
        echo "New file added: $file"
        # Run your Bash script
        bash "$script_to_run" "$file"
    fi
done

# Remove lock file
rm "$lock_file"
