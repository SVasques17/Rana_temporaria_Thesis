#!/bin/bash
set -Eeuo pipefail

URL="$1"
OUTPUT="$2"

echo "Downloading the classifier"
echo "URL: $URL"
echo "Output Directory: $OUTPUT"

#Download of the classifier
curl -L --fail --show-error \
	-o "$OUTPUT" \
	"$URL"

echo "Download completed successfully!"
echo "File saved at: $OUTPUT"
