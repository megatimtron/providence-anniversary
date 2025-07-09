#!/bin/bash

# 🍓 Direct Pi Sync Script - Updates Raspberry Pi immediately

echo "🍓 Syncing to Raspberry Pi..."
echo "================================"

# Pi connection details
PI_USER="timothytremaglio"
PI_HOST="192.168.68.69"
PI_PATH="/var/www/html"

# Check if Pi is reachable
echo "🔍 Checking Pi connection..."
if ! ping -c 1 "$PI_HOST" &> /dev/null; then
    echo "❌ Cannot reach Pi at $PI_HOST"
    echo "   Make sure you're on the same network and Pi is running"
    exit 1
fi

echo "✅ Pi is reachable"

# Sync main files
echo "📤 Syncing main files..."
ssh "$PI_USER@$PI_HOST" "sudo mkdir -p $PI_PATH && sudo chown -R $PI_USER:$PI_USER $PI_PATH" || {
    echo "❌ Failed to prepare directory"
    exit 1
}

scp index.html "$PI_USER@$PI_HOST:$PI_PATH/" || {
    echo "❌ Failed to sync index.html"
    exit 1
}

scp sw.js "$PI_USER@$PI_HOST:$PI_PATH/" || {
    echo "❌ Failed to sync sw.js"
    exit 1
}

scp manifest.json "$PI_USER@$PI_HOST:$PI_PATH/" || {
    echo "❌ Failed to sync manifest.json"
    exit 1
}

# Sync assets directory
echo "📤 Syncing assets..."
scp -r assets/ "$PI_USER@$PI_HOST:$PI_PATH/" || {
    echo "❌ Failed to sync assets"
    exit 1
}

# Sync menus directory
echo "📤 Syncing menus..."
scp -r menus/ "$PI_USER@$PI_HOST:$PI_PATH/" || {
    echo "❌ Failed to sync menus"
    exit 1
}

# Sync API if it exists
if [ -d "api" ]; then
    echo "📤 Syncing API..."
    scp -r api/ "$PI_USER@$PI_HOST:$PI_PATH/" || {
        echo "❌ Failed to sync API"
        exit 1
    }
fi

# Restart web server on Pi
echo "🔄 Restarting web server on Pi..."
ssh "$PI_USER@$PI_HOST" "sudo systemctl restart nginx" || {
    echo "⚠️  Could not restart nginx, but files are synced"
}

echo ""
echo "✅ Pi sync complete!"
echo "🌐 Your site is now live at: http://$PI_HOST"
echo "🎉 All changes have been deployed!"

# Test the deployment
echo ""
echo "🧪 Testing deployment..."
if curl -s "http://$PI_HOST" > /dev/null; then
    echo "✅ Pi deployment is working!"
else
    echo "⚠️  Pi deployment may have issues - check manually"
fi
