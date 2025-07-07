#!/bin/bash

# 🔍 Check DNS propagation for iloveugo.com

echo "🔍 Checking DNS propagation for iloveugo.com..."
echo "=============================================="
echo ""

echo "Current DNS resolution:"
nslookup iloveugo.com
echo ""

echo "Looking for Netlify IP (75.2.60.5)..."
if nslookup iloveugo.com | grep -q "75.2.60.5"; then
    echo "✅ SUCCESS! DNS is pointing to Netlify!"
    echo "🎉 Go to Netlify and click 'Retry DNS verification'"
else
    echo "⏰ Still propagating... Check again in 10-15 minutes"
    echo "💡 Expected IP: 75.2.60.5"
    echo "📋 Current IPs shown above"
fi

echo ""
echo "🌐 Your site will be live at https://iloveugo.com soon!"
