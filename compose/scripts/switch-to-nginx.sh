#!/bin/bash

# Switch to Nginx Environment Script
# This script handles the complete switch to Nginx setup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "🔧 Starting Nginx environment setup..."

# Stop current setup (Caddy)
echo "⏹️  Stopping Caddy setup..."
docker compose -f "$PROJECT_ROOT/docker-compose.caddy.yml" down 2>/dev/null || true

# Clean up any orphaned containers
echo "🧹 Cleaning up orphaned containers..."
docker compose -f "$PROJECT_ROOT/docker-compose.nginx.yml" down --remove-orphans 2>/dev/null || true

# Start Nginx setup
echo "🚀 Starting Nginx setup..."
if ! docker compose -f "$PROJECT_ROOT/docker-compose.nginx.yml" up -d; then
    echo "❌ Failed to start Nginx setup"
    exit 1
fi

echo "📊 Nginx setup started!"
echo "🌐 Test URL: http://php.localhost/api/stress-test"
echo "📝 Logs: ./compose/logs/nginx/"

# Health check
echo "🔍 Performing health check..."
if "$SCRIPT_DIR/health-check.sh" nginx; then
    echo "✅ Nginx is healthy and ready for testing!"

    # Display service status
    echo ""
    echo "📋 Service Status:"
    docker compose -f "$PROJECT_ROOT/docker-compose.nginx.yml" ps

    exit 0
else
    echo "❌ Nginx health check failed"
    echo "📋 Container Status:"
    docker compose -f "$PROJECT_ROOT/docker-compose.nginx.yml" ps
    exit 1
fi