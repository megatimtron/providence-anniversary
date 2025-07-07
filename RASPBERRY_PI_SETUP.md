# 🍓 Providence Anniversary Website - Raspberry Pi Setup Guide

## Step 1: Initial Setup on Raspberry Pi

### On your Raspberry Pi (via SSH, VNC, or direct connection):

1. **Copy the setup script to your Pi:**
   ```bash
   # Method 1: If you have the files locally on Pi
   cd /home/pi
   # Copy setup_pi.sh here, then:
   chmod +x setup_pi.sh
   ./setup_pi.sh
   ```

   ```bash
   # Method 2: Download directly (if you have the script online)
   wget -O setup_pi.sh [URL_TO_SETUP_SCRIPT]
   chmod +x setup_pi.sh
   ./setup_pi.sh
   ```

2. **Or run the setup commands manually:**
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y
   
   # Install required packages
   sudo apt install -y nginx python3 python3-pip python3-venv git curl
   
   # Create web directory
   sudo mkdir -p /var/www/provitinerary
   sudo chown pi:www-data /var/www/provitinerary
   sudo chmod 755 /var/www/provitinerary
   
   # Configure nginx
   sudo tee /etc/nginx/sites-available/provitinerary > /dev/null <<EOF
server {
    listen 80;
    listen [::]:80;
    server_name _;
    
    root /var/www/provitinerary;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    # Cache static files
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
   ```

## Step 2: Deploy Website Files

### Method A: Using SCP (requires SSH password)
```bash
# From your Mac
scp -r /Users/timothytremaglio/Downloads/provitinerary/* pi@192.168.68.69:/var/www/provitinerary/
```

### Method B: Using USB Drive
1. Copy the `provitinerary` folder to a USB drive
2. Insert USB into Pi
3. Mount and copy:
   ```bash
   # On Pi - find your USB drive
   sudo fdisk -l
   
   # Mount USB (assuming it's /dev/sda1)
   sudo mkdir /mnt/usb
   sudo mount /dev/sda1 /mnt/usb
   
   # Copy files
   cp -r /mnt/usb/provitinerary/* /var/www/provitinerary/
   
   # Set permissions
   sudo chown -R pi:www-data /var/www/provitinerary
   sudo chmod -R 755 /var/www/provitinerary
   
   # Unmount USB
   sudo umount /mnt/usb
   ```

### Method C: Manual File Transfer
1. Use your preferred file transfer method (WinSCP, FileZilla, etc.)
2. Transfer all files from `/Users/timothytremaglio/Downloads/provitinerary/` to `/var/www/provitinerary/` on the Pi

## Step 3: Final Configuration

```bash
# On your Pi, set correct permissions
sudo chown -R pi:www-data /var/www/provitinerary
sudo chmod -R 755 /var/www/provitinerary

# Restart nginx
sudo systemctl restart nginx

# Check status
sudo systemctl status nginx
```

## Step 4: Access Your Website

🌐 **Your Providence Anniversary website will be available at:**
- `http://192.168.68.69`
- From any device on your network!

## 🛠️ Troubleshooting

### Check nginx status:
```bash
sudo systemctl status nginx
```

### View nginx error logs:
```bash
sudo tail -f /var/log/nginx/error.log
```

### Test nginx configuration:
```bash
sudo nginx -t
```

### Restart nginx:
```bash
sudo systemctl restart nginx
```

### Check if files are in the right place:
```bash
ls -la /var/www/provitinerary/
```

### Check Pi's IP address:
```bash
hostname -I
```

## 🎯 Success Indicators

✅ nginx is running: `sudo systemctl status nginx` shows "active (running)"  
✅ Files are in place: `/var/www/provitinerary/index.html` exists  
✅ Website loads: Visiting `http://192.168.68.69` shows your anniversary site  

## 📱 Mobile Access

Once running, you can:
- Access from any phone/tablet on your network
- Add to home screen for app-like experience
- Share the local IP with family/friends on same network

---

🎉 **Enjoy your beautiful Providence Anniversary planning website!**
