
#!/bin/bash

GITHUB_URL=$1
INDEX_FILE=$2
WHITELIST_FILE=$3

REPO_DIR=/tmp/repo

# Set permissions for the SSH Key
chmod 600 /root/.ssh/id_rsa

# Clone GitHub Repository
if [ ! -d "$REPO_DIR" ]; then
  git clone "$GITHUB_URL" "$REPO_DIR"
else
  cd "$REPO_DIR" && git pull origin main
fi

# Copy files
if [ -f "$REPO_DIR/$INDEX_FILE" ]; then
  cp "$REPO_DIR/$INDEX_FILE" /var/www/html/
else
  echo "Index file not found: $REPO_DIR/$INDEX_FILE"
  exit 1
fi

if [ -f "$REPO_DIR/$WHITELIST_FILE" ]; then
  cp "$REPO_DIR/$WHITELIST_FILE" /etc/nginx/whitelist.txt
else
  echo "Whitelist file not found: $REPO_DIR/$WHITELIST_FILE"
  exit 1
fi

# Convert whitelist in nginx format
WHITELIST_CONF=/etc/nginx/whitelist_dynamic.conf
> $WHITELIST_CONF

while IFS= read -r ip; do
  echo "allow $ip;" >> $WHITELIST_CONF
done < /etc/nginx/whitelist.txt

echo "deny all;" >> $WHITELIST_CONF
