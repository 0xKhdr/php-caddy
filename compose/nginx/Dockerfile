FROM nginx:alpine

# Define arguments
ARG UID=1000
ARG GID=1000

# Install basic tools
RUN apk add --no-cache curl

# Create app user and group to match PHP-FPM
RUN addgroup -g $GID -S app-group && adduser -u $UID -S app-user -G app-group

# Create log directories and set permissions
RUN mkdir -p /var/log/nginx && \
    chown -R app-user:app-group /var/log/nginx /var/cache/nginx /var/run

# Remove default config
RUN rm /etc/nginx/conf.d/default.conf

# Copy configurations
COPY ./compose/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./compose/nginx/default.conf /etc/nginx/conf.d/default.conf

# Set working directory
WORKDIR /var/www/html

# Expose ports
EXPOSE 80 443

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1