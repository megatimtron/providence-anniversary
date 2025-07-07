#!/bin/bash

# Git-based Auto-Deployment to Raspberry Pi
# This script sets up automatic deployment when you push to a Git repository

PI_IP=${1:-"192.168.68.69"}
REPO_NAME="provitinerary"
LOCAL_PATH="/Users/timothytremaglio/Downloads/provitinerary"

echo "🍓 Setting up Git-based deployment to Raspberry Pi..."
echo "📡 Target: timothytremaglio@${PI_IP}"
echo "📁 Repository: ${REPO_NAME}"
echo ""

# Step 1: Initialize local Git repository if not exists
if [ ! -d "${LOCAL_PATH}/.git" ]; then
    echo "📦 Initializing Git repository..."
    cd "${LOCAL_PATH}"
    git init
    git add .
    git commit -m "Initial commit - Providence Anniversary Website"
    echo "✅ Local Git repository created"
else
    echo "✅ Git repository already exists"
fi

# Step 2: Set up bare repository on Pi
echo "🔧 Setting up bare repository on Raspberry Pi..."
ssh timothytremaglio@${PI_IP} << 'EOF'
# Create bare repository directory
mkdir -p /home/timothytremaglio/git/provitinerary.git
cd /home/timothytremaglio/git/provitinerary.git

# Initialize bare repository
git init --bare

echo "✅ Bare repository created at /home/timothytremaglio/git/provitinerary.git"
EOF

# Step 3: Create post-receive hook for auto-deployment
echo "🚀 Creating auto-deployment hook..."
ssh timothytremaglio@${PI_IP} << 'EOF'
# Create post-receive hook
cat > /home/timothytremaglio/git/provitinerary.git/hooks/post-receive << 'HOOK'
#!/bin/bash

# Post-receive hook for automatic deployment
echo "🚀 Deploying to /var/www/provitinerary..."

# Checkout files to web directory
cd /var/www/provitinerary
git --git-dir=/home/timothytremaglio/git/provitinerary.git --work-tree=/var/www/provitinerary checkout -f

# Set proper permissions
sudo chown -R timothytremaglio:www-data /var/www/provitinerary
sudo chmod -R 755 /var/www/provitinerary

# Restart nginx to ensure changes are picked up
sudo systemctl reload nginx

echo "✅ Deployment complete! Website updated at http://$(hostname -I | awk '{print $1}')"
echo "📅 Deployed at: $(date)"
HOOK

# Make the hook executable
chmod +x /home/timothytremaglio/git/provitinerary.git/hooks/post-receive

echo "✅ Post-receive hook created and configured"
EOF

# Step 4: Add Pi as remote
echo "🔗 Adding Raspberry Pi as Git remote..."
cd "${LOCAL_PATH}"

# Remove existing remote if it exists
git remote remove pi 2>/dev/null || true

# Add Pi as remote
git remote add pi timothytremaglio@${PI_IP}:/home/timothytremaglio/git/provitinerary.git

echo "✅ Raspberry Pi added as 'pi' remote"

# Step 5: Initial deployment
echo "🚀 Performing initial deployment..."
git push pi main 2>/dev/null || git push pi master 2>/dev/null || {
    echo "📝 Creating and pushing main branch..."
    git checkout -b main 2>/dev/null || git checkout main
    git push -u pi main
}

echo ""
echo "🎉 Git deployment setup complete!"
echo ""
echo "📋 Usage Instructions:"
echo "   1. Make changes to your files"
echo "   2. Commit changes: git add . && git commit -m 'Your message'"
echo "   3. Deploy to Pi: git push pi main"
echo ""
echo "🌐 Your website will be automatically updated at:"
PI_LOCAL_IP=$(ssh timothytremaglio@${PI_IP} "hostname -I | awk '{print \$1}'")
echo "   http://${PI_LOCAL_IP}"
echo ""
echo "💡 Pro tip: Create an alias for easy deployment:"
echo "   echo 'alias deploy=\"git add . && git commit -m \\\"Auto-deploy \$(date)\\\" && git push pi main\"' >> ~/.zshrc"
