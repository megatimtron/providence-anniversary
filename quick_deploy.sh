#!/bin/bash

# 🍓 Super Simple Providence Anniversary Deployment
# Just run: ./quick_deploy.sh

echo "🍓 Quick deploying to your Pi..."

# Copy files
echo "📁 Copying files..."
scp -r /Users/timothytremaglio/Downloads/provitinerary/* pi@192.168.68.69:/var/www/provitinerary/

# Set permissions and restart
echo "🔧 Configuring Pi..."
ssh pi@192.168.68.69 "
sudo chown -R pi:pi /var/www/provitinerary
sudo chmod -R 755 /var/www/provitinerary
sudo systemctl restart nginx
echo '✅ Done!'
"

echo ""
echo "🎉 Your website is ready at: http://192.168.68.69"
echo "💕 Enjoy your romantic Providence planning!"
