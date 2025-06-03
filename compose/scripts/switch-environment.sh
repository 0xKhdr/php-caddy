#!/bin/bash

# PHP Environment Switcher Script
# Usage: ./switch-environment.sh [nginx|caddy]

ENVIRONMENT=$1

# Function to display usage
show_usage() {
    echo "Usage: $0 [nginx|caddy]"
    echo "  nginx - Switch to Nginx PHP environment"
    echo "  caddy - Switch to Caddy PHP environment"
    exit 1
}

# Function to switch to Nginx
switch_to_nginx() {
    echo "Switching to Nginx setup..."

    # Stop current setup (Caddy)
    docker compose -f docker-compose.caddy.yml down 2>/dev/null || true

    # Start Nginx setup
    docker compose -f docker-compose.nginx.yml up -d

    echo "Nginx setup started!"
    echo "Test URL: http://php.localhost/api/stress-test"
    echo "Logs: ./logs/nginx/"

    # Wait for services
    echo "Waiting for services to be ready..."
    sleep 10

    # Health check
    if curl -s http://php.localhost > /dev/null; then
        echo "✅ Nginx is healthy and ready for testing!"
    else
        echo "❌ Nginx health check failed"
    fi
}

# Function to switch to Caddy
switch_to_caddy() {
    echo "Switching to Caddy setup..."

    # Stop current setup (Nginx)
    docker compose -f docker-compose.nginx.yml down 2>/dev/null || true

    # Start Caddy setup
    docker compose -f docker-compose.caddy.yml up -d

    echo "Caddy setup started!"
    echo "Test URL: http://php.localhost/api/stress-test"
    echo "Logs: ./logs/caddy/"

    # Wait for services
    echo "Waiting for services to be ready..."
    sleep 10

    # Health check
    if curl -s http://php.localhost > /dev/null; then
        echo "✅ Caddy is healthy and ready for testing!"
    else
        echo "❌ Caddy health check failed"
    fi
}

# Main logic
case $ENVIRONMENT in
    "nginx")
        switch_to_nginx
        ;;
    "caddy")
        switch_to_caddy
        ;;
    "")
        echo "Error: No environment specified"
        show_usage
        ;;
    *)
        echo "Error: Invalid environment '$ENVIRONMENT'"
        show_usage
        ;;
esac