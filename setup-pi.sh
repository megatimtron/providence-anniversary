#!/bin/bash

# 🍓 Raspberry Pi Setup Script for Providence Anniversary
# This script sets up the complete production environment

set -e

# Configuration
PI_USER="timothytremaglio"
WEB_DIR="/var/www/html"
API_DIR="$WEB_DIR/api"
DATA_DIR="$WEB_DIR/data"
UPLOAD_DIR="$WEB_DIR/uploads"
MEDIA_DIR="$WEB_DIR/media"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
    exit 1
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    error "Please run as root (use sudo)"
fi

# Update system
log "Updating system packages..."
apt update && apt upgrade -y

# Install required packages
log "Installing required packages..."
apt install -y \
    nginx \
    python3 \
    python3-pip \
    python3-venv \
    sqlite3 \
    git \
    curl \
    htop \
    ufw \
    fail2ban \
    logrotate

# Create directory structure
log "Creating directory structure..."
mkdir -p "$WEB_DIR" "$API_DIR" "$DATA_DIR" "$UPLOAD_DIR" "$MEDIA_DIR"
mkdir -p "$MEDIA_DIR/songs" "$MEDIA_DIR/videos"

# Set permissions
log "Setting permissions..."
chown -R www-data:www-data "$WEB_DIR"
chmod -R 755 "$WEB_DIR"
chmod -R 777 "$UPLOAD_DIR" "$MEDIA_DIR" "$DATA_DIR"

# Install Python dependencies
log "Installing Python dependencies..."
pip3 install \
    Flask==2.3.3 \
    Flask-CORS==4.0.0 \
    Werkzeug==2.3.7 \
    Pillow==10.0.1

# Copy API files
log "Setting up API server..."
if [ -f "api/app.py" ]; then
    cp api/app.py "$API_DIR/"
    cp api/requirements.txt "$API_DIR/"
    cp api/providence-api.service /etc/systemd/system/
    chown www-data:www-data "$API_DIR/app.py"
    chmod +x "$API_DIR/app.py"
fi

# Configure Nginx
log "Configuring Nginx..."
cat > /etc/nginx/sites-available/providence-anniversary << 'EOF'
server {
    listen 80;
    server_name localhost;
    
    root /var/www/html;
    index index.html;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    # Main site
    location / {
        try_files $uri $uri/ /index.html;
        expires 1h;
        add_header Cache-Control "public, no-transform";
    }
    
    # API endpoints
    location /api/ {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # CORS headers
        add_header Access-Control-Allow-Origin *;
        add_header Access-Control-Allow-Methods "GET, POST, OPTIONS";
        add_header Access-Control-Allow-Headers "Content-Type, Authorization";
        
        # Handle preflight requests
        if ($request_method = OPTIONS) {
            return 204;
        }
    }
    
    # Media files
    location /uploads/ {
        alias /var/www/html/uploads/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    location /media/ {
        alias /var/www/html/media/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Static assets
    location /assets/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Security
    location ~ /\. {
        deny all;
    }
    
    location ~ \.db$ {
        deny all;
    }
}
EOF

# Enable site
ln -sf /etc/nginx/sites-available/providence-anniversary /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# Test Nginx config
nginx -t || error "Nginx configuration test failed"

# Configure firewall
log "Configuring firewall..."
ufw --force enable
ufw allow ssh
ufw allow 80/tcp
ufw allow 8080/tcp

# Configure fail2ban
log "Configuring fail2ban..."
cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = ssh
filter = sshd
logpath = /var/log/auth.log
maxretry = 3

[nginx-http-auth]
enabled = true
filter = nginx-http-auth
port = http,https
logpath = /var/log/nginx/error.log
maxretry = 3

[nginx-limit-req]
enabled = true
filter = nginx-limit-req
port = http,https
logpath = /var/log/nginx/error.log
maxretry = 3
EOF

# Create log rotation
log "Setting up log rotation..."
cat > /etc/logrotate.d/providence-anniversary << 'EOF'
/var/log/providence-anniversary/*.log {
    daily
    rotate 14
    compress
    delaycompress
    missingok
    notifempty
    create 0644 www-data www-data
    postrotate
        systemctl reload nginx
    endscript
}
EOF

# Create backup script
log "Creating backup script..."
cat > /usr/local/bin/providence-backup.sh << 'EOF'
#!/bin/bash
# Providence Anniversary Backup Script

BACKUP_DIR="/home/timothytremaglio/backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="providence_backup_$DATE.tar.gz"

mkdir -p "$BACKUP_DIR"

# Create backup
tar -czf "$BACKUP_DIR/$BACKUP_FILE" \
    -C /var/www/html \
    --exclude='*.log' \
    --exclude='tmp/*' \
    .

# Keep only last 7 backups
find "$BACKUP_DIR" -name "providence_backup_*.tar.gz" -mtime +7 -delete

echo "Backup created: $BACKUP_FILE"
EOF

chmod +x /usr/local/bin/providence-backup.sh

# Create daily backup cron job
log "Setting up daily backups..."
cat > /etc/cron.d/providence-backup << 'EOF'
# Daily backup of Providence Anniversary site
0 2 * * * root /usr/local/bin/providence-backup.sh
EOF

# Create monitoring script
log "Creating monitoring script..."
cat > /usr/local/bin/providence-monitor.sh << 'EOF'
#!/bin/bash
# Providence Anniversary Monitoring Script

LOG_FILE="/var/log/providence-anniversary/monitor.log"
mkdir -p "$(dirname "$LOG_FILE")"

log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Check if Nginx is running
if ! systemctl is-active --quiet nginx; then
    log_message "ERROR: Nginx is not running, attempting to restart"
    systemctl restart nginx
fi

# Check if API server is running
if ! systemctl is-active --quiet providence-api; then
    log_message "ERROR: API server is not running, attempting to restart"
    systemctl restart providence-api
fi

# Check disk space
DISK_USAGE=$(df /var/www/html | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 80 ]; then
    log_message "WARNING: Disk usage is ${DISK_USAGE}%"
fi

# Check API health
if ! curl -f -s http://localhost:8080/api/health > /dev/null; then
    log_message "ERROR: API health check failed"
fi

log_message "Monitoring check completed"
EOF

chmod +x /usr/local/bin/providence-monitor.sh

# Create monitoring cron job
cat > /etc/cron.d/providence-monitor << 'EOF'
# Monitor Providence Anniversary site every 5 minutes
*/5 * * * * root /usr/local/bin/providence-monitor.sh
EOF

# Create systemd service for API
log "Setting up API service..."
if [ -f "/etc/systemd/system/providence-api.service" ]; then
    systemctl daemon-reload
    systemctl enable providence-api
fi

# Start services
log "Starting services..."
systemctl restart nginx
systemctl restart fail2ban

if [ -f "/etc/systemd/system/providence-api.service" ]; then
    systemctl restart providence-api
fi

# Create welcome message
log "Creating welcome message..."
cat > /etc/motd << 'EOF'
🍓 Providence Anniversary Raspberry Pi Server
===============================================

Services:
- Nginx: Web server running on port 80
- API Server: Running on port 8080
- Monitoring: Automated health checks every 5 minutes
- Backups: Daily at 2:00 AM

Useful Commands:
- Check services: sudo systemctl status nginx providence-api
- View logs: sudo journalctl -u providence-api -f
- Manual backup: sudo /usr/local/bin/providence-backup.sh
- Monitor health: sudo /usr/local/bin/providence-monitor.sh

Web Interface: http://192.168.68.69
API Endpoint: http://192.168.68.69:8080/api/status

💝 Your Providence Anniversary site is ready!
EOF

# Final status check
log "Performing final status check..."
sleep 5

# Check services
services=("nginx" "fail2ban")
if systemctl is-enabled providence-api &>/dev/null; then
    services+=("providence-api")
fi

for service in "${services[@]}"; do
    if systemctl is-active --quiet "$service"; then
        success "$service is running"
    else
        warning "$service is not running"
    fi
done

# Check web server
if curl -f -s http://localhost > /dev/null; then
    success "Web server is accessible"
else
    warning "Web server is not accessible"
fi

# Check API server
if curl -f -s http://localhost:8080/api/health > /dev/null; then
    success "API server is accessible"
else
    warning "API server is not accessible"
fi

echo ""
echo -e "${GREEN}🎉 Setup Complete!${NC}"
echo "=================================================="
echo -e "${GREEN}🌐 Web Interface: http://192.168.68.69${NC}"
echo -e "${GREEN}🔧 API Endpoint: http://192.168.68.69:8080/api/status${NC}"
echo -e "${GREEN}📱 Mobile-friendly and PWA-ready${NC}"
echo ""
echo -e "${BLUE}💝 Your Providence Anniversary site is now running!${NC}"
echo ""
echo "Next steps:"
echo "1. Upload your website files to /var/www/html/"
echo "2. Configure your domain name (optional)"
echo "3. Set up SSL certificate (recommended)"
echo "4. Test all functionality"
echo ""
echo "For support, check the logs:"
echo "- Web server: sudo journalctl -u nginx -f"
echo "- API server: sudo journalctl -u providence-api -f"
echo "- System: sudo tail -f /var/log/providence-anniversary/monitor.log"
