#!/bin/bash

directory="$1"
# directory="new" # Uncomment this line if you want to use a hardcoded directory
png=true
body=true
pdf=true

NAME="$2"
EMAIL="$3"
SUBJECT="$4"
MESSAGE_ID="$5"
BODY_HTML="$6"

# Initialize JSON data
json_data="{\"NAME\":\"$NAME\", \"EMAIL\":\"$EMAIL\", \"SUBJECT\":\"$SUBJECT\", \"MESSAGE_ID\":\"$MESSAGE_ID\", \"BODY_HTML\":\"$BODY_HTML\", \"attachments\": []}"

# Function to add attachments to JSON data
add_attachment() {
    local filepath="$1"
    local filename=$(basename "$filepath")
    local mimetype=$(file -b --mime-type "$filepath")
    local encoded_data=$(base64 -w0 < "$filepath")
    json_data=$(jq --arg fname "$filename" --arg ftype "$mimetype" --arg fdata "$encoded_data" \
        '.attachments += [{ "filename": $fname, "mimetype": $ftype, "data": $fdata }]' <<< "$json_data")
}

# Check for PNG files in the directory
if [ "$png" = true ]; then
    for png_file in "$directory"/*.png; do
        add_attachment "$png_file"
    done
fi

# Check for PDF files in the directory
if [ "$pdf" = true ]; then
    for pdf_file in "$directory"/*.pdf; do
        add_attachment "$pdf_file"
    done
fi

# Check if any attachments were added
if [ "$(jq '.attachments | length' <<< "$json_data")" -gt 0 ]; then
    # Send POST request with JSON data and attachments
    curl -X POST 'https://webhook.site/dd4828fc-c950-4ac0-b10f-c07575c787c5' \
        -H 'Content-Type: application/json' \
        -d "$json_data"
else
    # Send POST request with JSON data only
    curl -X POST 'https://webhook.site/dd4828fc-c950-4ac0-b10f-c07575c787c5' \
        -H 'Content-Type: application/json' \
        -d "$json_data"
fi

