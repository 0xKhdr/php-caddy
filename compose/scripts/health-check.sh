#!/bin/bash

# Health Check Script
# Usage: ./health-check.sh [nginx|caddy|frankenphp]

ENVIRONMENT=$1
MAX_RETRIES=30
RETRY_INTERVAL=2

# Function to display usage
show_usage() {
    echo "Usage: $0 [nginx|caddy|frankenphp]"
    echo "  nginx - Health check for Nginx environment"
    echo "  caddy - Health check for Caddy environment"
    echo "  frankenphp - Health check for FrankenPHP environment"
    exit 1
}

# Function to check if URL is responding
check_url() {
    local url=$1
    local description=$2

    echo "🔍 Checking $description: $url"

    for i in $(seq 1 $MAX_RETRIES); do
        if curl -s -f -m 10 "$url" > /dev/null 2>&1; then
            echo "✅ $description is responding"
            return 0
        else
            echo "⏳ Attempt $i/$MAX_RETRIES: $description not ready, waiting ${RETRY_INTERVAL}s..."
            sleep $RETRY_INTERVAL
        fi
    done

    echo "❌ $description failed health check after $MAX_RETRIES attempts"
    return 1
}

# Function to perform comprehensive health check
perform_health_check() {
    local environment=$1

    echo "🏥 Starting comprehensive health check for $environment..."

    # Check application health
    if ! check_url "http://php.localhost/up" "Health endpoint"; then
      echo "⚠️  Health endpoint failed, but main app is working"
      return 1
    fi

    echo "✅ Health check completed successfully for $environment"
    return 0
}

# Main logic
case $ENVIRONMENT in
    "nginx"|"caddy"|"frankenphp")
        perform_health_check "$ENVIRONMENT"
        ;;
    "")
        echo "❌ Error: No environment specified"
        show_usage
        ;;
    *)
        echo "❌ Error: Invalid environment '$ENVIRONMENT'"
        show_usage
        ;;
esac