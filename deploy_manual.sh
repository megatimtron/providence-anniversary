#!/bin/bash

# 🍓 Providence Anniversary Website - Manual Password Deployment
# This version prompts for password manually (more reliable)

# Configuration
PI_IP="192.168.68.69"
PI_USER="timothytremaglio"
LOCAL_PATH="/Users/timothytremaglio/Downloads/provitinerary"
REMOTE_PATH="/var/www/provitinerary"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║               🍓 Providence Anniversary Website              ║"
echo "║                  Manual Deployment Script                   ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

echo -e "${CYAN}🍓 Step 1: Testing Pi connection...${NC}"
if ping -c 1 $PI_IP > /dev/null 2>&1; then
    echo -e "${GREEN}✅ Pi is reachable at $PI_IP${NC}"
else
    echo -e "${RED}❌ Cannot reach Pi at $PI_IP${NC}"
    exit 1
fi
echo ""

echo -e "${CYAN}🍓 Step 2: Setting up Pi web server...${NC}"
echo -e "${BLUE}💡 You'll be prompted for your Pi password (Fratesi7!)${NC}"
echo ""

ssh $PI_USER@$PI_IP << 'ENDSSH'
echo "🔧 Setting up nginx web server..."

# Update system
sudo apt update -y

# Install nginx if needed
if ! command -v nginx &> /dev/null; then
    echo "📦 Installing nginx..."
    sudo apt install -y nginx
else
    echo "✅ nginx already installed"
fi

# Create web directory
echo "📁 Creating web directory..."
sudo mkdir -p /var/www/provitinerary
sudo chown pi:pi /var/www/provitinerary
sudo chmod 755 /var/www/provitinerary

# Create nginx configuration
echo "⚙️ Configuring nginx..."
sudo tee /etc/nginx/sites-available/provitinerary > /dev/null << 'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name _;
    
    root /var/www/provitinerary;
    index index.html;
    
    # Enable gzip compression
    gzip on;
    gzip_types text/css application/javascript text/javascript application/json text/html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    # Cache static files
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
EOF

# Enable the site
sudo ln -sf /etc/nginx/sites-available/provitinerary /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx

echo "✅ Pi setup complete!"
ENDSSH

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Pi setup completed successfully${NC}"
else
    echo -e "${RED}❌ Pi setup failed${NC}"
    exit 1
fi
echo ""

echo -e "${CYAN}🍓 Step 3: Copying website files...${NC}"
echo -e "${BLUE}💡 Enter your Pi password again when prompted${NC}"
echo ""

# Copy files with manual password
rsync -avz --progress \
    --exclude='.git' \
    --exclude='.DS_Store' \
    --exclude='*.pyc' \
    --exclude='__pycache__' \
    --exclude='.venv' \
    --exclude='setup_pi.sh' \
    --exclude='deploy_to_pi*.sh' \
    --exclude='copy_files.sh' \
    --exclude='quick_deploy.sh' \
    --exclude='*README*.md' \
    --exclude='MANUAL_SETUP.md' \
    --exclude='BUTTON_FIXES_README.md' \
    --exclude='COLOR_REVERT_SUMMARY.md' \
    --exclude='DEPLOYMENT_GUIDE.md' \
    --exclude='button_test.html' \
    $LOCAL_PATH/ $PI_USER@$PI_IP:$REMOTE_PATH/

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Files copied successfully${NC}"
else
    echo -e "${RED}❌ File copy failed${NC}"
    exit 1
fi
echo ""

echo -e "${CYAN}🍓 Step 4: Final configuration...${NC}"
echo -e "${BLUE}💡 Enter your Pi password one more time${NC}"
echo ""

ssh $PI_USER@$PI_IP << 'ENDSSH'
echo "🔐 Setting file permissions..."
sudo chown -R pi:pi /var/www/provitinerary
sudo chmod -R 755 /var/www/provitinerary

echo "🔄 Restarting nginx..."
sudo systemctl restart nginx

echo "🧪 Checking nginx status..."
if sudo systemctl is-active --quiet nginx; then
    echo "✅ nginx is running"
else
    echo "❌ nginx is not running"
    sudo systemctl status nginx
fi

echo "📁 Verifying files..."
ls -la /var/www/provitinerary/ | head -5

echo "✅ Configuration complete!"
ENDSSH

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Final configuration completed${NC}"
else
    echo -e "${RED}❌ Final configuration failed${NC}"
fi
echo ""

echo -e "${CYAN}🍓 Step 5: Testing website...${NC}"
if curl -s --max-time 10 "http://$PI_IP" > /dev/null; then
    echo -e "${GREEN}✅ Website is responding!${NC}"
else
    echo -e "${BLUE}💡 Website may need a moment to start (this is normal)${NC}"
fi
echo ""

echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    🎉 DEPLOYMENT COMPLETE! 🎉                ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "${GREEN}🌐 Your Providence Anniversary website is now live at:${NC}"
echo -e "${CYAN}   http://$PI_IP${NC}"
echo ""
echo -e "${BLUE}📱 Access from any device on your network!${NC}"
echo -e "${PURPLE}💕 Enjoy planning your romantic Providence getaway! ✨${NC}"
echo ""

# Ask if they want to open browser
read -p "Would you like to open the website in your browser now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "http://$PI_IP"
    echo -e "${GREEN}🌐 Opening website in browser...${NC}"
fi

echo -e "${CYAN}💡 For future updates, just run: ./quick_deploy_manual.sh${NC}"
