#!/bin/bash

# Providence Itinerary - Deployment Script for Raspberry Pi
# Usage: ./deploy_to_pi.sh [PI_IP_ADDRESS]

PI_IP=${1:-"192.168.68.69"}
LOCAL_PATH="/Users/timothytremaglio/Downloads/provitinerary"
REMOTE_PATH="/var/www/provitinerary"

echo "🍓 Deploying Providence Itinerary to Raspberry Pi..."
echo "📡 Target: timothytremaglio@${PI_IP}"
echo "📁 Local path: ${LOCAL_PATH}"
echo "🎯 Remote path: ${REMOTE_PATH}"
echo ""

# Check if local files exist
if [ ! -d "${LOCAL_PATH}" ]; then
    echo "❌ Local directory ${LOCAL_PATH} not found!"
    exit 1
fi

if [ ! -f "${LOCAL_PATH}/index.html" ]; then
    echo "❌ index.html not found in ${LOCAL_PATH}!"
    exit 1
fi

# Check if we can reach the Pi
echo "🔍 Checking connection to Raspberry Pi..."
if ! ping -c 1 ${PI_IP} > /dev/null 2>&1; then
    echo "❌ Cannot reach ${PI_IP}. Please check:"
    echo "   - Pi is powered on and connected to network"
    echo "   - IP address is correct"
    echo "   - Try: ping ${PI_IP}"
    exit 1
fi

echo "✅ Pi is reachable!"

# Test SSH connection
echo "🔑 Testing SSH connection..."
echo "   (You may need to enter the Pi password)"

if ! ssh -o ConnectTimeout=10 -o BatchMode=yes timothytremaglio@${PI_IP} 'exit' 2>/dev/null; then
    echo "⚠️  SSH key authentication failed. You'll need to enter password for each command."
    echo "   💡 To set up key-based auth later, run: ssh-copy-id timothytremaglio@${PI_IP}"
    echo ""
fi

# Copy files to Pi
echo "📁 Copying website files..."
echo "   This may take a moment and will ask for password..."

# Create remote directory first
ssh timothytremaglio@${PI_IP} "sudo mkdir -p ${REMOTE_PATH} && sudo chown timothytremaglio:www-data ${REMOTE_PATH}"

# Copy files using rsync
rsync -avz --progress \
    --exclude='.git' \
    --exclude='.DS_Store' \
    --exclude='*.pyc' \
    --exclude='__pycache__' \
    --exclude='.venv' \
    --exclude='setup_pi.sh' \
    --exclude='deploy_to_pi.sh' \
    --exclude='RASPBERRY_PI_SETUP.md' \
    ${LOCAL_PATH}/ timothytremaglio@${PI_IP}:${REMOTE_PATH}/

if [ $? -eq 0 ]; then
    echo "✅ Files copied successfully!"
else
    echo "❌ File copy failed. Possible solutions:"
    echo "   1. Check SSH password is correct"
    echo "   2. Ensure Pi has enough disk space: ssh timothytremaglio@${PI_IP} 'df -h'"
    echo "   3. Check Pi directory permissions"
    echo "   4. Try manual copy with: scp -r ${LOCAL_PATH}/* timothytremaglio@${PI_IP}:${REMOTE_PATH}/"
    exit 1
fi

# Verify files were copied
echo "🔍 Verifying file copy..."
FILE_COUNT=$(ssh timothytremaglio@${PI_IP} "find ${REMOTE_PATH} -name '*.html' -o -name '*.css' -o -name '*.js' | wc -l")
if [ "$FILE_COUNT" -gt 0 ]; then
    echo "✅ Found $FILE_COUNT web files on Pi"
else
    echo "⚠️  No web files found. Copy may have failed."
fi

# Set correct permissions
echo "🔐 Setting file permissions..."
ssh timothytremaglio@${PI_IP} "sudo chown -R timothytremaglio:www-data ${REMOTE_PATH} && sudo chmod -R 755 ${REMOTE_PATH}"

# Check if nginx is running, start if needed
echo "🔄 Checking web server status..."
NGINX_STATUS=$(ssh timothytremaglio@${PI_IP} "sudo systemctl is-active nginx" 2>/dev/null)
if [ "$NGINX_STATUS" != "active" ]; then
    echo "   Starting nginx..."
    ssh timothytremaglio@${PI_IP} "sudo systemctl start nginx"
else
    echo "   Restarting nginx..."
    ssh timothytremaglio@${PI_IP} "sudo systemctl restart nginx"
fi

# Verify nginx is running
NGINX_FINAL=$(ssh timothytremaglio@${PI_IP} "sudo systemctl is-active nginx" 2>/dev/null)
if [ "$NGINX_FINAL" = "active" ]; then
    echo "✅ Web server is running"
else
    echo "⚠️  Web server may not be running. Check with: ssh timothytremaglio@${PI_IP} 'sudo systemctl status nginx'"
fi

echo ""
echo "🎉 Deployment complete!"
echo "🌐 Your Providence Anniversary website should be available at:"
echo "   http://${PI_IP}"
echo ""
echo "🧪 Testing website accessibility..."
if curl -s --max-time 5 "http://${PI_IP}" > /dev/null; then
    echo "✅ Website is responding!"
else
    echo "⚠️  Website may not be accessible yet. Give it a moment or check:"
    echo "   - SSH to Pi: ssh timothytremaglio@${PI_IP}"
    echo "   - Check nginx: sudo systemctl status nginx"
    echo "   - Check files: ls -la /var/www/provitinerary/"
fi

echo ""
echo "💡 Next steps:"
echo "   - Open http://${PI_IP} in your browser"
echo "   - Access from any device on your network"
echo "   - Add to mobile home screen for app-like experience"
echo ""
echo "🔧 Troubleshooting commands:"
echo "   - Check nginx: ssh timothytremaglio@${PI_IP} 'sudo systemctl status nginx'"
echo "   - View logs: ssh timothytremaglio@${PI_IP} 'sudo tail -f /var/log/nginx/error.log'"
echo "   - Check files: ssh timothytremaglio@${PI_IP} 'ls -la /var/www/provitinerary/'"
