FROM php:8.2-fpm-alpine

# Define arguments
ARG UID=1000
ARG GID=1000

# Install system dependencies and PHP extensions
RUN apk add --no-cache \
        curl \
        git \
        libpng-dev \
        libjpeg-turbo-dev \
        freetype-dev \
        libzip-dev \
        oniguruma-dev \
        zip \
        linux-headers \
        $PHPIZE_DEPS \
        fcgi \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql gd zip opcache

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    chmod +x /usr/local/bin/composer

# Create app user and group
RUN addgroup -g $GID -S app-group && adduser -u $UID -S app-user -G app-group

# Set working directory
WORKDIR /var/www/html

# Create log directories
RUN mkdir -p /var/log/php-fpm /var/log/php && \
    chown -R app-user:app-group /var/log/php-fpm /var/log/php /var/www/html

# Copy PHP-FPM configuration
COPY ./compose/php/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./compose/php/php.ini /usr/local/etc/php/php.ini

# Add health check script
RUN echo '#!/bin/sh' > /usr/local/bin/php-fpm-healthcheck && \
    echo 'SCRIPT_NAME=/ping SCRIPT_FILENAME=/ping REQUEST_METHOD=GET cgi-fcgi -bind -connect 127.0.0.1:9000' >> /usr/local/bin/php-fpm-healthcheck && \
    chmod +x /usr/local/bin/php-fpm-healthcheck

# Expose port
EXPOSE 9000

# Use app user
USER app-user

# Start PHP-FPM (no need for Supervisor)
CMD ["php-fpm", "--nodaemonize", "--force-stderr"]