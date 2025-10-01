#!/bin/bash

PLUGIN_NAME="serlzo"
VERSION="1.0.0"
REMOTE_HOST="serlzo.zecconsultin.com"
REMOTE_PATH="/downloads"

ZIP_FILE="downloads/${PLUGIN_NAME}${VERSION}.zip"
CHECKSUM=$(sha256sum "$ZIP_FILE" | awk '{print $1}')

jq --arg version "$VERSION" \
   --arg checksum "sha256:$CHECKSUM" \
   --arg download_url "https://$REMOTE_HOST$REMOTE_PATH/${PLUGIN_NAME}${VERSION}.zip" \
   '.version = $version |
    .download_url = $download_url |
    .download_checksum = $checksum' \
   serlzo-wp.json > tmp.json && mv tmp.json serlzo-wp.json

echo "Updated serlzo-wp.json with:"
echo "Version: $VERSION"
echo "Checksum: sha256:$CHECKSUM"
