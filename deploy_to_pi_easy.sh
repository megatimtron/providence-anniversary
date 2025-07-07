#!/bin/bash

# 🍓 Providence Anniversary Website - Easy Pi Deployment Script
# This script will deploy your beautiful anniversary website to your Raspberry Pi
# Run this from your Mac: ./deploy_to_pi_easy.sh

# Configuration
PI_IP="192.168.68.69"
PI_USER="pi"
PI_PASSWORD="Fratesi7!"
LOCAL_PATH="/Users/timothytremaglio/Downloads/provitinerary"
REMOTE_PATH="/var/www/provitinerary"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print colored output
print_step() {
    echo -e "${CYAN}🍓 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}💡 $1${NC}"
}

# Header
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║               🍓 Providence Anniversary Website              ║"
echo "║                    Easy Pi Deployment                       ║"
echo "║                                                              ║"
echo "║  This will deploy your romantic website to your Pi!         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Step 1: Check local files
print_step "Step 1: Checking local files..."
if [ ! -d "$LOCAL_PATH" ]; then
    print_error "Local directory $LOCAL_PATH not found!"
    exit 1
fi

if [ ! -f "$LOCAL_PATH/index.html" ]; then
    print_error "index.html not found in $LOCAL_PATH!"
    exit 1
fi

print_success "Local files found ✨"
echo "   📁 Source: $LOCAL_PATH"
echo "   📄 Found: index.html and other files"
echo ""

# Step 2: Test Pi connection
print_step "Step 2: Testing connection to Raspberry Pi..."
if ping -c 1 $PI_IP > /dev/null 2>&1; then
    print_success "Pi is reachable at $PI_IP"
else
    print_error "Cannot reach Pi at $PI_IP"
    print_info "Please check:"
    echo "   - Pi is powered on"
    echo "   - Pi is connected to WiFi"
    echo "   - IP address is correct: $PI_IP"
    exit 1
fi
echo ""

# Step 3: Install sshpass if needed (for automatic password)
print_step "Step 3: Checking SSH tools..."
if ! command -v sshpass &> /dev/null; then
    print_warning "sshpass not found. Installing with Homebrew..."
    if command -v brew &> /dev/null; then
        brew install hudochenkov/sshpass/sshpass
        print_success "sshpass installed"
    else
        print_error "Homebrew not found. Please install manually:"
        echo "   brew install hudochenkov/sshpass/sshpass"
        echo ""
        print_info "For now, you'll need to enter password manually"
        USE_SSHPASS=false
    fi
else
    print_success "SSH tools ready"
    USE_SSHPASS=true
fi
echo ""

# Step 4: Setup Pi (if needed)
print_step "Step 4: Setting up Raspberry Pi web server..."
print_info "Checking if nginx is installed..."

# Create setup commands
SETUP_COMMANDS="
# Update system
echo 'Updating system packages...'
sudo apt update -y

# Install nginx if not present
if ! command -v nginx &> /dev/null; then
    echo 'Installing nginx...'
    sudo apt install -y nginx
else
    echo 'nginx already installed ✅'
fi

# Create web directory
echo 'Setting up web directory...'
sudo mkdir -p $REMOTE_PATH
sudo chown pi:pi $REMOTE_PATH
sudo chmod 755 $REMOTE_PATH

# Create nginx configuration
echo 'Configuring nginx...'
sudo tee /etc/nginx/sites-available/provitinerary > /dev/null << 'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name _;
    
    root $REMOTE_PATH;
    index index.html;
    
    # Enable gzip compression
    gzip on;
    gzip_types text/css application/javascript text/javascript application/json text/html;
    
    location / {
        try_files \\\$uri \\\$uri/ /index.html;
    }
    
    # Cache static files for better performance
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control \"public, immutable\";
    }
    
    # Security headers
    add_header X-Frame-Options \"SAMEORIGIN\" always;
    add_header X-Content-Type-Options \"nosniff\" always;
    add_header Referrer-Policy \"no-referrer-when-downgrade\" always;
}
EOF

# Enable the site
sudo ln -sf /etc/nginx/sites-available/provitinerary /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test nginx configuration
if sudo nginx -t; then
    echo 'nginx configuration is valid ✅'
else
    echo 'nginx configuration error ❌'
    exit 1
fi

# Start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx

echo '✅ Pi setup complete!'
"

if [ "$USE_SSHPASS" = true ]; then
    sshpass -p "$PI_PASSWORD" ssh -o StrictHostKeyChecking=no $PI_USER@$PI_IP "$SETUP_COMMANDS"
else
    echo "Please enter your Pi password when prompted..."
    ssh $PI_USER@$PI_IP "$SETUP_COMMANDS"
fi

if [ $? -eq 0 ]; then
    print_success "Pi setup completed"
else
    print_error "Pi setup failed"
    exit 1
fi
echo ""

# Step 5: Copy files
print_step "Step 5: Copying website files to Pi..."
print_info "This may take a moment..."

# Create file list to copy (exclude unnecessary files)
RSYNC_EXCLUDES="
--exclude='.git'
--exclude='.DS_Store'
--exclude='*.pyc'
--exclude='__pycache__'
--exclude='.venv'
--exclude='setup_pi.sh'
--exclude='deploy_to_pi.sh'
--exclude='copy_files.sh'
--exclude='deploy_to_pi_easy.sh'
--exclude='*README*.md'
--exclude='MANUAL_SETUP.md'
--exclude='BUTTON_FIXES_README.md'
--exclude='COLOR_REVERT_SUMMARY.md'
--exclude='button_test.html'
"

if [ "$USE_SSHPASS" = true ]; then
    sshpass -p "$PI_PASSWORD" rsync -avz --progress $RSYNC_EXCLUDES $LOCAL_PATH/ $PI_USER@$PI_IP:$REMOTE_PATH/
else
    echo "Please enter your Pi password when prompted..."
    rsync -avz --progress $RSYNC_EXCLUDES $LOCAL_PATH/ $PI_USER@$PI_IP:$REMOTE_PATH/
fi

if [ $? -eq 0 ]; then
    print_success "Files copied successfully"
else
    print_error "File copy failed"
    exit 1
fi
echo ""

# Step 6: Set permissions and restart nginx
print_step "Step 6: Final configuration..."

FINAL_COMMANDS="
# Set correct permissions
sudo chown -R pi:pi $REMOTE_PATH
sudo chmod -R 755 $REMOTE_PATH

# Restart nginx
sudo systemctl restart nginx

# Check nginx status
if sudo systemctl is-active --quiet nginx; then
    echo '✅ nginx is running'
else
    echo '❌ nginx is not running'
    sudo systemctl status nginx
fi

# Verify files
echo 'Files in web directory:'
ls -la $REMOTE_PATH/ | head -10
"

if [ "$USE_SSHPASS" = true ]; then
    sshpass -p "$PI_PASSWORD" ssh $PI_USER@$PI_IP "$FINAL_COMMANDS"
else
    echo "Please enter your Pi password when prompted..."
    ssh $PI_USER@$PI_IP "$FINAL_COMMANDS"
fi

if [ $? -eq 0 ]; then
    print_success "Final configuration completed"
else
    print_error "Final configuration failed"
fi
echo ""

# Step 7: Test website
print_step "Step 7: Testing website..."
print_info "Checking if website is accessible..."

if curl -s --max-time 10 "http://$PI_IP" > /dev/null; then
    print_success "Website is responding!"
else
    print_warning "Website may not be accessible yet (this is normal, give it a moment)"
fi
echo ""

# Success message
echo -e "${PURPLE}"
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║                    🎉 DEPLOYMENT COMPLETE! 🎉                ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
print_success "Your beautiful Providence Anniversary website is now live!"
echo ""
echo -e "${CYAN}🌐 Access your website at:${NC}"
echo -e "   ${GREEN}http://$PI_IP${NC}"
echo ""
echo -e "${CYAN}📱 Mobile access:${NC}"
echo "   - Open browser on any device on your network"
echo "   - Go to: http://$PI_IP"
echo "   - Add to home screen for app-like experience"
echo ""
echo -e "${CYAN}🔧 Useful commands for your Pi:${NC}"
echo "   - Check status: ssh $PI_USER@$PI_IP 'sudo systemctl status nginx'"
echo "   - Restart server: ssh $PI_USER@$PI_IP 'sudo systemctl restart nginx'"
echo "   - View logs: ssh $PI_USER@$PI_IP 'sudo tail -f /var/log/nginx/error.log'"
echo ""
echo -e "${PURPLE}💕 Enjoy planning your romantic Providence anniversary! ✨${NC}"
echo ""

# Optional: Open browser
read -p "Would you like to open the website in your browser now? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    open "http://$PI_IP"
    print_success "Opening website in browser..."
fi

print_info "Deployment script completed successfully!"
