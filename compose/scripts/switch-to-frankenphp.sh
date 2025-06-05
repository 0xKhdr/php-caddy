#!/bin/bash

# Switch to FrankenPHP Environment Script
# This script handles the complete switch to FrankenPHP setup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "🔧 Starting FrankenPHP environment setup..."

# Stop current setup (Nginx)
echo "⏹️  Stopping Nginx setup..."
docker compose -f "$PROJECT_ROOT/docker-compose.nginx.yml" down -v 2>/dev/null || true

# Stop current setup (Caddy)
echo "⏹️  Stopping Caddy setup..."
docker compose -f "$PROJECT_ROOT/docker-compose.caddy.yml" down -v 2>/dev/null || true

# Clean up any orphaned containers
echo "🧹 Cleaning up orphaned containers..."
docker compose -f "$PROJECT_ROOT/docker-compose.frankenphp.yml" down --remove-orphans 2>/dev/null || true

# Start FrankenPHP setup
echo "🚀 Starting FrankenPHP setup..."
if ! docker compose -f "$PROJECT_ROOT/docker-compose.frankenphp.yml" up -d --build; then
    echo "❌ Failed to start FrankenPHP setup"
    exit 1
fi

echo "📊 FrankenPHP setup started!"
echo "🌐 Test URL: http://php.localhost"
echo "📝 Logs: ./compose/logs/frankenphp/"

# Health check
echo "🔍 Performing health check..."
if "$SCRIPT_DIR/health-check.sh" frankenphp; then
    echo "✅ FrankenPHP is healthy and ready for testing!"

    # Display service status
    echo ""
    echo "📋 Service Status:"
    docker compose -f "$PROJECT_ROOT/docker-compose.frankenphp.yml" ps

    exit 0
else
    echo "❌ FrankenPHP health check failed"
    echo "📋 Container Status:"
    docker compose -f "$PROJECT_ROOT/docker-compose.frankenphp.yml" ps
    exit 1
fi