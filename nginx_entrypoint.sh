#!/bin/bash

# Start initial fetch
fetch_files.sh "$GITHUB_URL" "$INDEX_FILE" "$WHITELIST_FILE"

# Start Backgroundprocess
while true; do
  fetch_files.sh "$GITHUB_URL" "$INDEX_FILE" "$WHITELIST_FILE"
  sleep "$UPDATE_INTERVAL"
done &

# Start NGINX
nginx -g "daemon off;"
