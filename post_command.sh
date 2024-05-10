#!/bin/bash

# Directory containing email files
EMAIL_DIR=$1

formatted_name_email="${EMAIL_DIR##*/}"
numer_of_mail="${formatted_name_email%.mail}"
ATTACHMENTS_DIR="$numer_of_mail-attach"
directory="$ATTACHMENTS_DIR"

ripmime -i "$EMAIL_DIR" -d "$ATTACHMENTS_DIR" 

echo "dir of attachement: $ATTACHMENTS_DIR"
echo "Extracted filename: $numer_of_mail"
echo "Processing $numer_of_mail"

from_field=$(grep "^From: " "$EMAIL_DIR" | sed 's/From: //')
name=$(echo "$from_field" | cut -d'<' -f1 | sed 's/^[ \t]*//;s/[ \t]*$//') # Remove leading/trailing whitespaces
email=$(echo "$from_field" | cut -d'<' -f2 | sed 's/>//')

# Printing the extracted name and email for verification
echo "Name: $name"
echo "Email: $email"

subject_field=$(grep "^Subject: " "$EMAIL_DIR" | sed 's/Subject: //')
body_html=$(cat "$ATTACHMENTS_DIR/textfile2")
encoded_html=$(echo -n "$body_html" | base64)
message_id=$(grep -i "^Message-ID: " "$EMAIL_DIR" | sed 's/Message-ID: //')

echo "Attachments stored in $ATTACHMENTS_DIR"
echo "From Field: $from_field"
echo "dir to delete $ATTACHMENTS_DIR"
echo "body: $encoded_html"
rm -rf $ATTACHMENTS_DIR/text*

./file_checker.sh $ATTACHMENTS_DIR  "$name" "$email" "$subject_field" "$message_id" "$encoded_html"

rm -rf $ATTACHMENTS_DIR

