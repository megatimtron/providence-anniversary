#!/bin/bash

# Providence Itinerary - Raspberry Pi 5 Setup Script
# Run this script directly on your Raspberry Pi

echo "🍓 Setting up Providence Anniversary Website on Raspberry Pi 5..."
echo "📅 Today is: $(date)"
echo ""

# Check if running as timothytremaglio user
if [ "$USER" != "timothytremaglio" ]; then
    echo "⚠️  Please run this script as the 'timothytremaglio' user"
    echo "   Switch to timothytremaglio user: su - timothytremaglio"
    exit 1
fi

# Update system
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Install required packages
echo "🔧 Installing web server and Python dependencies..."
sudo apt install -y nginx python3 python3-pip python3-venv git curl

# Install Node.js for any potential future enhancements
echo "📱 Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Enable SSH (if not already enabled)
echo "🔑 Ensuring SSH is enabled..."
sudo systemctl enable ssh
sudo systemctl start ssh

# Create web directory and set permissions
echo "📁 Setting up web directory..."
sudo mkdir -p /var/www/provitinerary
sudo chown timothytremaglio:www-data /var/www/provitinerary
sudo chmod 755 /var/www/provitinerary

# Create nginx configuration
echo "⚙️ Configuring Nginx..."
sudo tee /etc/nginx/sites-available/provitinerary > /dev/null <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name localhost;
    
    root /var/www/provitinerary;
    index index.html;
    
    # Enable gzip compression
    gzip on;
    gzip_types text/css application/javascript text/javascript application/json;
    
    # Cache static assets
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Handle all routes (for single page app)
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
}
EOF

# Enable the site
sudo ln -sf /etc/nginx/sites-available/provitinerary /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test nginx configuration
sudo nginx -t

# Start and enable services
echo "🚀 Starting services..."
sudo systemctl enable nginx
sudo systemctl restart nginx

# Set up Python virtual environment for scripts
echo "🐍 Setting up Python environment..."
cd /var/www/provitinerary
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip

# Install common Python packages that might be needed
pip install requests beautifulsoup4 lxml pillow

echo "✅ Setup complete!"
echo ""
echo "🎯 Your Raspberry Pi is now ready!"
echo "� Pi IP Address: $(hostname -I | awk '{print $1}')"
echo ""
echo "�📋 Next steps:"
echo "1. From your Mac, run: ./deploy_to_pi.sh $(hostname -I | awk '{print $1}')"
echo "2. Or manually copy files to: /var/www/provitinerary/"
echo "3. Your website will be available at: http://$(hostname -I | awk '{print $1}')"
echo ""
echo "🔧 Useful commands:"
echo "- Check nginx status: sudo systemctl status nginx"
echo "- Restart nginx: sudo systemctl restart nginx"
echo "- View nginx logs: sudo tail -f /var/log/nginx/error.log"
echo "- View access logs: sudo tail -f /var/log/nginx/access.log"
echo ""
echo "🌐 Web directory: /var/www/provitinerary"
echo "⚙️  Nginx config: /etc/nginx/sites-available/provitinerary"
