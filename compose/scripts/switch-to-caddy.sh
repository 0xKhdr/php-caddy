#!/bin/bash

# Switch to Caddy Environment Script
# This script handles the complete switch to Caddy setup

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "🔧 Starting Caddy environment setup..."

# Stop current setup (Nginx)
echo "⏹️  Stopping Nginx setup..."
docker compose -f "$PROJECT_ROOT/docker-compose.nginx.yml" down 2>/dev/null || true

# Clean up any orphaned containers
echo "🧹 Cleaning up orphaned containers..."
docker compose -f "$PROJECT_ROOT/docker-compose.caddy.yml" down --remove-orphans 2>/dev/null || true

# Start Caddy setup
echo "🚀 Starting Caddy setup..."
if ! docker compose -f "$PROJECT_ROOT/docker-compose.caddy.yml" up -d; then
    echo "❌ Failed to start Caddy setup"
    exit 1
fi

echo "📊 Caddy setup started!"
echo "🌐 Test URL: http://php.localhost/api/stress-test"
echo "📝 Logs: ./compose/logs/caddy/"

# Health check
echo "🔍 Performing health check..."
if "$SCRIPT_DIR/health-check.sh" caddy; then
    echo "✅ Caddy is healthy and ready for testing!"

    # Display service status
    echo ""
    echo "📋 Service Status:"
    docker compose -f "$PROJECT_ROOT/docker-compose.caddy.yml" ps

    exit 0
else
    echo "❌ Caddy health check failed"
    echo "📋 Container Status:"
    docker compose -f "$PROJECT_ROOT/docker-compose.caddy.yml" ps
    exit 1
fi