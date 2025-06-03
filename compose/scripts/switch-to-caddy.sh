#!/bin/bash

echo "Switching to Caddy setup..."

# Stop current setup
docker compose -f docker-compose.nginx.yml down 2>/dev/null || true

# Start Caddy setup
docker compose -f docker-compose.caddy.yml up -d

echo "Caddy setup started!"
echo "Test URL: http://php.caddy.localhost/api/stress-test"
echo "Logs: ./logs/caddy/"

# Wait for services
echo "Waiting for services to be ready..."
sleep 10

# Health check
if curl -s http://php.caddy.localhost > /dev/null; then
    echo "✅ Caddy is healthy and ready for testing!"
else
    echo "❌ Caddy health check failed"
fi