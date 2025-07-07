#!/bin/bash

# 🍓 Quick Update for Providence Anniversary Website
# Use this for quick updates after initial setup

PI_IP="192.168.68.69"
PI_USER="timothytremaglio"
LOCAL_PATH="/Users/timothytremaglio/Downloads/provitinerary"
REMOTE_PATH="/var/www/provitinerary"

echo "🍓 Quick deploying updates to your Pi..."
echo "💡 Enter your Pi password when prompted"
echo ""

echo "📁 Copying files..."
rsync -avz --progress \
    --exclude='.git' \
    --exclude='.DS_Store' \
    --exclude='*.pyc' \
    --exclude='__pycache__' \
    --exclude='.venv' \
    --exclude='*deploy*.sh' \
    --exclude='*README*.md' \
    --exclude='button_test.html' \
    $LOCAL_PATH/ $PI_USER@$PI_IP:$REMOTE_PATH/

echo ""
echo "🔧 Restarting server..."
ssh $PI_USER@$PI_IP "
sudo chown -R pi:pi $REMOTE_PATH
sudo chmod -R 755 $REMOTE_PATH
sudo systemctl restart nginx
echo '✅ Server restarted!'
"

echo ""
echo "🎉 Update complete!"
echo "🌐 Your website: http://$PI_IP"
echo "💕 Enjoy your beautiful Providence site!"
