#!/bin/bash

set -e

echo "🔧 Optimizing Laravel for stress test..."

docker compose exec php php artisan config:clear
docker compose exec php php artisan route:clear
docker compose exec php php artisan view:clear
docker compose exec php php artisan event:clear

docker compose exec php php artisan config:cache
docker compose exec php php artisan route:cache
docker compose exec php php artisan view:cache
docker compose exec php php artisan event:cache

echo "🧪 Running Pest stress test on http://php.localhost..."

docker compose exec php ./vendor/bin/pest stress http://php.localhost --duration=10 --concurrency=10 --report

echo "✅ Stress test completed."
