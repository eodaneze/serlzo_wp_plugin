#!/bin/bash
# Config
PLUGIN_NAME="serlzo"
VERSION="1.1"
REMOTE_HOST="serlzo.spellahub.com"
REMOTE_PATH="/downloads"

# Generate SHA256 checksum
ZIP_FILE="$PLUGIN_NAME-$VERSION.zip"
CHECKSUM=$(sha256sum "$ZIP_FILE" | awk '{print $1}')

# Update JSON file
jq --arg version "$VERSION" \
   --arg checksum "sha256:$CHECKSUM" \
   --arg download_url "https://$REMOTE_HOST$REMOTE_PATH/$ZIP_FILE" \
   '.version = $version |
    .download_url = $download_url |
    .download_checksum = $checksum' \
   "$PLUGIN_NAME-wp.json" > tmp.json && mv tmp.json "$PLUGIN_NAME-wp.json"

echo "Updated $PLUGIN_NAME-wp.json:"
echo "Version: $VERSION"
echo "Checksum: sha256:$CHECKSUM"
echo "Download URL: https://$REMOTE_HOST$REMOTE_PATH/$ZIP_FILE"
