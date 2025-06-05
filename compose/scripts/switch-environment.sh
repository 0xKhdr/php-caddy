#!/bin/bash

# PHP Environment Switcher Script
# Usage: ./switch-environment.sh [nginx|caddy|frankenphp]

ENVIRONMENT=$1
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="$SCRIPT_DIR"

# Function to display usage
show_usage() {
    echo "Usage: $0 [nginx|caddy]"
    echo "  nginx - Switch to Nginx PHP environment"
    echo "  caddy - Switch to Caddy PHP environment"
    echo "  frankenphp - Switch to FrankenPHP environment"
    exit 1
}

# Function to check if script exists and is executable
check_script() {
    local script_path="$1"
    if [[ ! -f "$script_path" ]]; then
        echo "❌ Error: Script not found: $script_path"
        exit 1
    fi
    if [[ ! -x "$script_path" ]]; then
        echo "❌ Error: Script not executable: $script_path"
        echo "Run: chmod +x $script_path"
        exit 1
    fi
}

# Function to switch to Nginx
switch_to_nginx() {
    echo "🔄 Switching to Nginx setup..."

    local nginx_script="$SCRIPTS_DIR/switch-to-nginx.sh"
    check_script "$nginx_script"

    # Execute the nginx switch script
    if "$nginx_script"; then
        echo "✅ Successfully switched to Nginx!"
    else
        echo "❌ Failed to switch to Nginx"
        exit 1
    fi
}

# Function to switch to Caddy
switch_to_caddy() {
    echo "🔄 Switching to Caddy setup..."

    local caddy_script="$SCRIPTS_DIR/switch-to-caddy.sh"
    check_script "$caddy_script"

    # Execute the caddy switch script
    if "$caddy_script"; then
        echo "✅ Successfully switched to Caddy!"
    else
        echo "❌ Failed to switch to Caddy"
        exit 1
    fi
}

# Function to switch to FrankenPHP
switch_to_frankenphp() {
    echo "🔄 Switching to FrankenPHP setup..."

    local frankenphp_script="$SCRIPTS_DIR/switch-to-frankenphp.sh"
    check_script "$frankenphp_script"

    # Execute the caddy switch script
    if "$frankenphp_script"; then
        echo "✅ Successfully switched to FrankenPHP!"
    else
        echo "❌ Failed to switch to FrankenPHP"
        exit 1
    fi
}

# Create scripts directory if it doesn't exist
if [[ ! -d "$SCRIPTS_DIR" ]]; then
    echo "📁 Creating scripts directory: $SCRIPTS_DIR"
    mkdir -p "$SCRIPTS_DIR"
fi

# Main logic
case $ENVIRONMENT in
    "nginx")
        switch_to_nginx
        ;;
    "caddy")
        switch_to_caddy
        ;;
    "frankenphp")
        switch_to_frankenphp
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