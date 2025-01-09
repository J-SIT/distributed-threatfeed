FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache nginx git openssh bash

# Add scripts and configuration
COPY fetch_files.sh /usr/local/bin/fetch_files.sh
COPY nginx_entrypoint.sh /usr/local/bin/nginx_entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf
COPY whitelist.txt /etc/nginx/whitelist.txt

# Configure SSH
RUN mkdir -p /root/.ssh && chmod 700 /root/.ssh
RUN ssh-keyscan -t rsa github.com >> /root/.ssh/known_hosts

# Make scripts executable
RUN chmod +x /usr/local/bin/fetch_files.sh /usr/local/bin/nginx_entrypoint.sh
RUN chmod 644 /etc/nginx/nginx.conf

# Create Folder
RUN mkdir /var/www/html

# Expose port 80
EXPOSE 80

# Entrypoint
ENTRYPOINT ["/usr/local/bin/nginx_entrypoint.sh"]
