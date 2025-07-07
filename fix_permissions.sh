#!/bin/bash

# 🍓 Quick Fix for Pi Permissions Issue
# Run this to fix the www-data permission error

PI_IP="192.168.68.69"

echo "🔧 Fixing Pi permissions..."
echo "💡 Enter your Pi password when prompted"
echo ""

ssh pi@$PI_IP << 'ENDSSH'
echo "🔐 Fixing file permissions..."
sudo chown -R pi:pi /var/www/provitinerary
sudo chmod -R 755 /var/www/provitinerary

echo "🔄 Restarting nginx..."
sudo systemctl restart nginx

echo "🧪 Checking nginx status..."
if sudo systemctl is-active --quiet nginx; then
    echo "✅ nginx is running"
    echo "✅ Permissions fixed!"
else
    echo "❌ nginx issue - checking status..."
    sudo systemctl status nginx
fi

echo "📁 Checking files..."
ls -la /var/www/provitinerary/ | head -5
ENDSSH

echo ""
echo "🎉 Permissions fixed!"
echo "🌐 Try your website: http://$PI_IP"
echo "💕 Your Providence Anniversary site should work now!"
