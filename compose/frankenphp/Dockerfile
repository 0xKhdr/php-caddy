FROM dunglas/frankenphp

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql zip opcache exif bcmath sockets && \
    docker-php-ext-enable opcache

# Install Composer
RUN curl -sS https://getcomposer.org/installer  | php -- \
    --install-dir=/usr/local/bin \
    --filename=composer && \
    chmod +x /usr/local/bin/composer

# Create app user and group
ARG UID=1000
ARG GID=1000
RUN groupadd -g $GID app-group && \
    useradd -u $UID -g app-group -ms /bin/bash app-user

# Set working directory
WORKDIR /var/www/html

# Create log directories and set permissions
RUN mkdir -p /var/log/frankenphp /var/log/caddy /var/log/php && \
    chown -R app-user:app-group /var/log/frankenphp /var/log/caddy /var/log/php /var/www/html

# Copy PHP ini configuration if needed
COPY ./compose/php/php.ini /usr/local/etc/php/php.ini

# Copy composer files first for better layer caching
COPY --chown=app-user:app-group ./src/composer.* ./

# Install dependencies (no-dev for production)
RUN composer install --optimize-autoloader --no-interaction --no-progress --no-scripts

# Copy app files
COPY --chown=app-user:app-group ./src /var/www/html

# Copy Caddyfile
COPY --chown=app-user:app-group ./compose/frankenphp/Caddyfile /etc/frankenphp/Caddyfile

# Expose port and run FrankenPHP
EXPOSE 80 443

# Use app user
USER app-user

# Start FrankenPHP server
#CMD ["frankenphp", "run"]
