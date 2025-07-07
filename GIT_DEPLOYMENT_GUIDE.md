# 🚀 Git-Based Deployment to Raspberry Pi

## Overview
This setup allows you to deploy your Providence Anniversary website to your Raspberry Pi using Git, similar to how GitHub Pages works, but to your own server.

## ⚡ Quick Setup

### 1. First-Time Setup
```bash
# Make scripts executable
chmod +x setup_git_deployment.sh
chmod +x git_deploy.sh

# Run the setup (replace with your Pi's IP)
./setup_git_deployment.sh 192.168.68.69
```

### 2. Daily Usage
```bash
# Quick deploy with auto-generated message
./git_deploy.sh

# Deploy with custom message
./git_deploy.sh "Added romantic floating hearts feature"
```

## 🔧 How It Works

1. **Bare Repository**: Creates a bare Git repo on your Pi at `/home/timothytremaglio/git/provitinerary.git`
2. **Post-Receive Hook**: Automatically deploys files to `/var/www/provitinerary` when you push
3. **Remote**: Adds your Pi as a Git remote called "pi"
4. **Auto-Deploy**: When you push, files are instantly deployed and nginx is reloaded

## 📋 Commands Reference

### Setup Commands
```bash
# Initial setup
./setup_git_deployment.sh [PI_IP]

# Check remote is configured
git remote -v
```

### Deployment Commands
```bash
# Stage changes
git add .

# Commit changes
git commit -m "Your message"

# Deploy to Pi
git push pi main

# Or use the quick deploy script
./git_deploy.sh "Your message"
```

### Useful Aliases
Add to your `~/.zshrc` or `~/.bashrc`:
```bash
# Quick deploy alias
alias deploy="git add . && git commit -m \"Auto-deploy $(date)\" && git push pi main"

# Deploy with message
alias deploym="git add . && git commit -m"
```

## 🌐 Accessing Your Website

After deployment, your website will be available at:
- `http://[YOUR_PI_IP]`
- `http://[YOUR_PI_HOSTNAME].local` (if mDNS is enabled)

## 🔍 Troubleshooting

### Check Deployment Status
```bash
# SSH into Pi and check logs
ssh timothytremaglio@[PI_IP]
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log
```

### Manual Deployment
```bash
# If auto-deployment fails, manually update
ssh timothytremaglio@[PI_IP]
cd /var/www/provitinerary
sudo git --git-dir=/home/timothytremaglio/git/provitinerary.git --work-tree=/var/www/provitinerary checkout -f
sudo chown -R timothytremaglio:www-data /var/www/provitinerary
sudo systemctl reload nginx
```

### Reset Git Setup
```bash
# Remove Pi remote and start over
git remote remove pi
./setup_git_deployment.sh [PI_IP]
```

## 🎯 Benefits Over Manual Deployment

- ✅ **Version Control**: Full Git history of your changes
- ✅ **Instant Deploy**: Push and it's live in seconds
- ✅ **Rollback**: Easy to revert to previous versions
- ✅ **Automated**: No manual file copying
- ✅ **Professional**: Industry-standard deployment method

## 🔒 Security Notes

- The Git repository on your Pi is only accessible via SSH
- Files are deployed with proper web server permissions
- Nginx serves files securely with appropriate headers

## 📝 Example Workflow

```bash
# Edit your website
code index.html

# Deploy changes
./git_deploy.sh "Updated anniversary countdown"

# Website is automatically live!
```

Your Providence Anniversary website will be deployed professionally using Git! 🍓💕
