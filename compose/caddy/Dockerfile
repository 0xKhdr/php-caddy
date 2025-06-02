FROM caddy:2-alpine

# Define arguments
ARG UID=1000
ARG GID=1000

# Mange user and permissions
RUN addgroup -g $GID -S app-group && adduser -u $UID -S app-user -G app-group && \
    mkdir -p /var/log/caddy && \
    chown -R app-user:app-group /var/log/caddy

# Copy Caddyfile
COPY ./compose/caddy/Caddyfile /etc/caddy/Caddyfile

# Expose ports
EXPOSE 80 443
