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
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql gd zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    chmod +x /usr/local/bin/composer

# Set working directory
WORKDIR /var/www/html

# Mange user and permissions
RUN addgroup -g $GID -S app-group && adduser -u $UID -S app-user -G app-group && \
    chown -R app-user:app-group /var/www/html
