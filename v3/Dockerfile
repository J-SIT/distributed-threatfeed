FROM alpine:latest

# Install necessary packages
RUN apk add --no-cache nginx bash openssl

# Add scripts and configuration
COPY nginx_entrypoint.sh /usr/local/bin/nginx_entrypoint.sh
COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf


# Make scripts executable
RUN chmod +x /usr/local/bin/nginx_entrypoint.sh
RUN chmod 644 /etc/nginx/nginx.conf

# Create Folder
RUN mkdir /var/www/html
RUN chown -R nginx:nginx /var/www/html
RUN chmod -R 644 /var/www/html

# Create index.html
RUN touch /var/www/html/index.html

# Expose port 80
EXPOSE 80

# Entrypoint
ENTRYPOINT ["/usr/local/bin/nginx_entrypoint.sh"]
