#!/bin/bash

# Simple file copy script for Providence Anniversary Website
# Run this from your Mac

echo "🍓 Copying Providence Anniversary files to Raspberry Pi..."
echo "📡 Target: pi@192.168.68.69"
echo "🔑 You'll be prompted for password: Fratesi7!"
echo ""

# Copy files
scp -r /Users/timothytremaglio/Downloads/provitinerary/* pi@192.168.68.69:/var/www/provitinerary/

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Files copied successfully!"
    echo "🌐 Your website should now be available at: http://192.168.68.69"
    echo ""
    echo "🔧 If the website doesn't load, SSH to your Pi and run:"
    echo "   sudo systemctl restart nginx"
else
    echo ""
    echo "❌ Copy failed. Make sure:"
    echo "   1. Your Pi is reachable: ping 192.168.68.69"
    echo "   2. SSH is working: ssh pi@192.168.68.69"
    echo "   3. The web directory exists on Pi: /var/www/provitinerary/"
fi
