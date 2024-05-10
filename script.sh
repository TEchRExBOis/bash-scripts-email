#!/bin/bash


# Resolve tilde expansion for paths if necessary
EMAIL_DIR="${HOME}/Maildir/new"
PROCESSED_LOG="${HOME}/processed.log"

# Function to check if an email has been processed
email_processed() {
    local email_file="$1"
    grep -Fxq "$email_file" "$PROCESSED_LOG"
}

# Function to mark an email as processed
mark_processed() {
    local email_file="$1"
    echo "$email_file" >> "$PROCESSED_LOG"
}

# Check if the email directory is empty
if [ -z "$(ls -A $EMAIL_DIR)" ]; then
    echo "No new emails."
else
    # If not empty, process each email file
    for email_file in "$EMAIL_DIR"/*; do
        if email_processed "$email_file"; then
            echo "Skipping processed file: $email_file"
            continue
        fi
        
        # Process the email
        echo "Processing $email_file"
        
        # Simulate some processing task
        # Here, you might want to replace `cat "$email_file" > /dev/null` with actual processing code
        echo "running post request"
        ./post_command.sh "$email_file"
        # Mark the email as processed
        mark_processed "$email_file"
    done
fi
