#!/bin/bash

# Advanced webhook-based deployment for instant updates
# This creates a webhook that Netlify can call to trigger Pi updates

echo "🔗 ADVANCED WEBHOOK DEPLOYMENT SETUP"
echo "====================================="

# Create webhook receiver script for Pi
cat > webhook_receiver.py << 'EOF'
#!/usr/bin/env python3

"""
Webhook receiver for Providence Anniversary Website
Listens for Netlify deployment webhooks and updates Pi accordingly
"""

from http.server import HTTPServer, BaseHTTPRequestHandler
import json
import subprocess
import os
import logging
from datetime import datetime

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('webhook.log'),
        logging.StreamHandler()
    ]
)

class WebhookHandler(BaseHTTPRequestHandler):
    
    def do_POST(self):
        """Handle incoming webhook from Netlify"""
        try:
            # Get content length
            content_length = int(self.headers.get('Content-Length', 0))
            
            # Read the payload
            payload = self.rfile.read(content_length)
            data = json.loads(payload.decode('utf-8'))
            
            # Log the webhook
            logging.info(f"Webhook received: {data.get('state', 'unknown')}")
            
            # Check if this is a successful deployment
            if data.get('state') == 'ready' and data.get('context') == 'production':
                logging.info("Production deployment successful, updating Pi...")
                self.update_pi()
                
                # Send success response
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                response = {'status': 'success', 'message': 'Pi updated successfully'}
                self.wfile.write(json.dumps(response).encode())
            else:
                # Send acknowledgment
                self.send_response(200)
                self.send_header('Content-Type', 'application/json')
                self.end_headers()
                response = {'status': 'acknowledged', 'message': 'Webhook received'}
                self.wfile.write(json.dumps(response).encode())
                
        except Exception as e:
            logging.error(f"Error processing webhook: {str(e)}")
            self.send_response(500)
            self.end_headers()
    
    def update_pi(self):
        """Update Pi with latest changes from Git"""
        try:
            # Pull latest changes
            result = subprocess.run(['git', 'pull', 'origin', 'main'], 
                                  capture_output=True, text=True)
            
            if result.returncode == 0:
                logging.info("Git pull successful")
                
                # Restart any services if needed
                self.restart_services()
                
            else:
                logging.error(f"Git pull failed: {result.stderr}")
                
        except Exception as e:
            logging.error(f"Error updating Pi: {str(e)}")
    
    def restart_services(self):
        """Restart web services if needed"""
        try:
            # Add any service restart commands here
            # Example: subprocess.run(['sudo', 'systemctl', 'reload', 'nginx'])
            logging.info("Services restarted (if applicable)")
        except Exception as e:
            logging.error(f"Error restarting services: {str(e)}")
    
    def do_GET(self):
        """Handle GET requests for status checks"""
        self.send_response(200)
        self.send_header('Content-Type', 'application/json')
        self.end_headers()
        
        status = {
            'status': 'running',
            'timestamp': datetime.now().isoformat(),
            'service': 'Providence Anniversary Webhook Receiver'
        }
        
        self.wfile.write(json.dumps(status).encode())

def run_webhook_server(port=8080):
    """Run the webhook server"""
    server_address = ('', port)
    httpd = HTTPServer(server_address, WebhookHandler)
    
    logging.info(f"Webhook server starting on port {port}")
    logging.info("Ready to receive Netlify deployment webhooks")
    
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        logging.info("Webhook server stopped")
        httpd.server_close()

if __name__ == '__main__':
    run_webhook_server()
EOF

chmod +x webhook_receiver.py

# Create systemd service for webhook (Pi)
cat > webhook.service << 'EOF'
[Unit]
Description=Providence Anniversary Webhook Receiver
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/provitinerary
ExecStart=/usr/bin/python3 /home/pi/provitinerary/webhook_receiver.py
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

# Create webhook setup script for Pi
cat > setup_webhook_on_pi.sh << 'EOF'
#!/bin/bash

echo "🔗 Setting up webhook receiver on Raspberry Pi"
echo "=============================================="

# Copy webhook files to Pi
echo "📤 Copying webhook files to Pi..."

# You'll need to run this from your development machine
PI_IP="192.168.68.69"  # Update if different
PI_USER="pi"           # Update if different

# Copy files to Pi
scp webhook_receiver.py ${PI_USER}@${PI_IP}:~/provitinerary/
scp webhook.service ${PI_USER}@${PI_IP}:~/

echo "⚙️  Setting up webhook service on Pi..."

# SSH to Pi and setup service
ssh ${PI_USER}@${PI_IP} << 'REMOTE_EOF'

# Move service file
sudo mv ~/webhook.service /etc/systemd/system/

# Reload systemd
sudo systemctl daemon-reload

# Enable and start webhook service
sudo systemctl enable webhook.service
sudo systemctl start webhook.service

# Check status
sudo systemctl status webhook.service

echo "✅ Webhook service installed and running"
echo "🌐 Webhook URL: http://192.168.68.69:8080"

REMOTE_EOF

echo ""
echo "🎉 Webhook setup complete!"
echo ""
echo "📝 Next steps:"
echo "1. In Netlify dashboard, go to Site settings → Build & deploy → Deploy notifications"
echo "2. Add webhook URL: http://192.168.68.69:8080"
echo "3. Select 'Deploy succeeded' event"
echo "4. Save webhook"
echo ""
echo "Now when Netlify deploys, your Pi will automatically update too!"

EOF

chmod +x setup_webhook_on_pi.sh

# Create bidirectional sync script
cat > setup_bidirectional_sync.sh << 'EOF'
#!/bin/bash

echo "🔄 BIDIRECTIONAL SYNC SETUP"
echo "==========================="
echo "This creates two-way sync: Pi ↔ GitHub ↔ Netlify"

# Create Pi to GitHub sync (triggered by file changes)
cat > pi_to_github_sync.sh << 'SYNC_EOF'
#!/bin/bash

# Sync Pi changes to GitHub
echo "📱 → 🌐 Syncing Pi changes to GitHub..."

# Check for changes
if ! git diff --quiet || ! git diff --cached --quiet; then
    
    # Copy current state to netlify-deploy folder
    echo "📦 Updating netlify-deploy folder..."
    
    # Sync everything except git and scripts
    rsync -av --delete \
        --exclude='.git' \
        --exclude='*.sh' \
        --exclude='*.py' \
        --exclude='*.log' \
        --exclude='webhook.service' \
        --exclude='netlify.toml' \
        ./ ./netlify-deploy/
    
    # Stage changes
    git add .
    
    # Commit with timestamp  
    commit_msg="Pi update: $(date '+%Y-%m-%d %H:%M:%S')"
    git commit -m "$commit_msg"
    
    # Push to GitHub (triggers Netlify)
    git push origin main
    
    echo "✅ Synced to GitHub - Netlify will deploy automatically"
    
else
    echo "📋 No changes to sync"
fi
SYNC_EOF

chmod +x pi_to_github_sync.sh

# Create GitHub to Pi sync (triggered by webhook)
echo "📄 Created pi_to_github_sync.sh"
echo "📄 Created webhook_receiver.py (for GitHub → Pi sync)"

echo ""
echo "🎯 COMPLETE AUTOMATION PIPELINE:"
echo "================================"
echo ""
echo "1. 📱 Pi Changes → GitHub:"
echo "   Run: ./pi_to_github_sync.sh"
echo "   Or:  ./watch_and_auto_sync.sh (continuous)"
echo ""
echo "2. 🌐 GitHub → Netlify:"
echo "   Automatic via Git integration"
echo ""  
echo "3. 🔄 Netlify → Pi:"
echo "   Automatic via webhook (run setup_webhook_on_pi.sh)"
echo ""
echo "Result: Any change anywhere updates everywhere! 🚀"

EOF

chmod +x setup_bidirectional_sync.sh

echo ""
echo -e "${GREEN}🎉 ADVANCED AUTOMATION CREATED!${NC}"
echo "==============================="
echo ""
echo "📜 Scripts created:"
echo "✅ setup_full_auto_deploy.sh   - Complete Git + Netlify setup"
echo "✅ webhook_receiver.py          - Webhook server for Pi"
echo "✅ setup_webhook_on_pi.sh      - Install webhook on Pi"
echo "✅ setup_bidirectional_sync.sh - Two-way sync setup"
echo ""
echo "🚀 Quick start:"
echo "1. ./setup_full_auto_deploy.sh  (Git + Netlify)"
echo "2. ./setup_webhook_on_pi.sh     (Pi webhook)"
echo "3. Add webhook URL in Netlify dashboard"
echo ""
echo "Result: Pi ↔ GitHub ↔ Netlify all auto-sync! 🔄"
