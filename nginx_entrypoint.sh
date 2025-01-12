#!/bin/bash

# Function: Configure NGINX with Whitelist and Basic Auth
configure_nginx() {
  # Update the Whitelist
  fetch_files.sh "$GITHUB_URL" "$INDEX_FILE" "$WHITELIST_FILE"

  # Configure Basic Auth
  if [ "$BASIC_AUTH" == "true" ]; then
    if [ -n "$BASIC_AUTH_USER" ] && [ -n "$BASIC_AUTH_PASSWORD" ]; then
      echo "Enabling Basic Auth for user: $BASIC_AUTH_USER"
      echo "$BASIC_AUTH_USER:$(openssl passwd -apr1 $BASIC_AUTH_PASSWORD)" > /etc/nginx/.htpasswd
    else
      echo "Error: BASIC_AUTH is enabled, but username or password is missing."
      exit 1
    fi
  else
    echo "Basic Auth is disabled."
    # Delete the htpasswd file if it exists
    [ -f /etc/nginx/.htpasswd ] && rm /etc/nginx/.htpasswd
  fi
}

# Initial configuration of NGINX
configure_nginx

# Background process: Repeated configuration
while true; do
  configure_nginx
  sleep "$UPDATE_INTERVAL"
done &

# Start NGINX
nginx -g "daemon off;"
