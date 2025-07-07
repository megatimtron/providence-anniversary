# 🍓 Simple Manual Setup for Providence Anniversary Website

## Step 1: Set up your Raspberry Pi (Run these commands on your Pi)

**Connect to your Pi first:**
```bash
ssh timothytremaglio@192.168.68.69
# Enter your Pi password when prompted
```

**Once connected to your Pi, run these commands one by one:**

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install nginx
sudo apt install -y nginx

# Create web directory
sudo mkdir -p /var/www/provitinerary
sudo chown timothytremaglio:timothytremaglio /var/www/provitinerary
sudo chmod 755 /var/www/provitinerary

# Create nginx configuration
sudo tee /etc/nginx/sites-available/provitinerary > /dev/null << 'EOF'
server {
    listen 80;
    listen [::]:80;
    server_name _;
    
    root /var/www/provitinerary;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location ~* \.(css|js|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public";
    }
}
EOF

# Enable the site
sudo ln -sf /etc/nginx/sites-available/provitinerary /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Start nginx
sudo systemctl enable nginx
sudo systemctl restart nginx

# Check if nginx is running
sudo systemctl status nginx

echo "✅ Pi setup complete! Web server is ready."
```

## Step 2: Copy files from your Mac

**On your Mac terminal, run this command:**
```bash
# Copy all website files to your Pi
scp -r /Users/timothytremaglio/Downloads/provitinerary/* timothytremaglio@192.168.68.69:/var/www/provitinerary/
# Enter your Pi password when prompted
```

## Step 3: Final setup on Pi

**Back on your Pi (SSH connection), run:**
```bash
# Set correct permissions
sudo chown -R timothytremaglio:timothytremaglio /var/www/provitinerary
sudo chmod -R 755 /var/www/provitinerary

# Restart nginx
sudo systemctl restart nginx

# Verify files are there
ls -la /var/www/provitinerary/

echo "🎉 Setup complete! Your website should be available at http://192.168.68.69"
```

## Quick Test

**Open a web browser and go to:**
http://192.168.68.69

You should see your beautiful Providence Anniversary website!

---

## 🚨 If something goes wrong:

**Check nginx status:**
```bash
sudo systemctl status nginx
```

**Check nginx logs:**
```bash
sudo tail -f /var/log/nginx/error.log
```

**Restart nginx:**
```bash
sudo systemctl restart nginx
```

**Check if files copied correctly:**
```bash
ls -la /var/www/provitinerary/
# You should see index.html and other files
```
