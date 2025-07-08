#!/bin/bash

# 🚀 Auto-Deploy System for Providence Anniversary Website
# Automatically deploys to both Raspberry Pi AND Netlify when you make changes

echo "🚀 Setting up Auto-Deploy System..."
echo "=================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if git is initialized
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}📁 Initializing Git repository...${NC}"
    git init
    git add .
    git commit -m "Initial Providence Anniversary Website"
fi

# Create git hooks directory
mkdir -p .git/hooks

# Create post-commit hook for automatic deployment
cat > .git/hooks/post-commit << 'EOF'
#!/bin/bash

echo "🔄 Auto-deploying Providence Anniversary Website..."

# Deploy to Raspberry Pi
echo "📡 Deploying to Raspberry Pi (192.168.68.69)..."
./deploy_to_pi.sh

# Update Netlify package
echo "📦 Updating Netlify deployment package..."
./deploy_to_netlify.sh

echo "✅ Auto-deployment complete!"
echo "🍓 Pi: http://192.168.68.69"
echo "🌐 Netlify: Ready for manual upload or Git integration"
EOF

# Make the hook executable
chmod +x .git/hooks/post-commit

# Create a convenient deploy script
cat > auto_deploy.sh << 'EOF'
#!/bin/bash

# 🚀 Auto-Deploy Script - Updates both Pi and Netlify package

echo "🚀 Auto-deploying Providence Anniversary Website..."
echo "=================================================="

# Check for changes
if git diff --quiet && git diff --cached --quiet; then
    echo "⚠️  No changes detected. Make some changes first!"
    exit 1
fi

# Commit changes
echo "📝 Committing changes..."
git add .
echo "Enter commit message (or press Enter for default):"
read -r commit_msg
if [ -z "$commit_msg" ]; then
    commit_msg="Update Providence Anniversary Website - $(date '+%Y-%m-%d %H:%M')"
fi

git commit -m "$commit_msg"

# The post-commit hook will automatically deploy to both Pi and Netlify
echo ""
echo "✅ Deployment initiated!"
echo "🍓 Pi will be updated at: http://192.168.68.69"
echo "📦 Netlify package updated in: ./netlify-deploy/"
echo ""
echo "🌐 To update iloveugo.com:"
echo "   1. Go to https://app.netlify.com"
echo "   2. Drag ./netlify-deploy/ folder to update the site"
echo "   OR set up Git integration for fully automatic updates"
EOF

chmod +x auto_deploy.sh

# Create Git integration setup for Netlify
cat > setup_netlify_git_integration.sh << 'EOF'
#!/bin/bash

echo "🔗 Setting up Netlify Git Integration for Fully Automatic Deployments"
echo "====================================================================="

echo "This will set up automatic deployments to iloveugo.com whenever you push changes."
echo ""
echo "📋 Steps to complete:"
echo "1. Create a GitHub repository (free)"
echo "2. Connect this project to GitHub"
echo "3. Connect Netlify to your GitHub repo"
echo "4. Every git push will auto-deploy to iloveugo.com!"

read -p "Do you want to continue? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🔗 Setting up GitHub integration..."
    
    # Check if remote exists
    if git remote get-url origin &> /dev/null; then
        echo "✅ Git remote already configured"
        git remote -v
    else
        echo "📝 You'll need to:"
        echo "   1. Create a new repository on GitHub.com"
        echo "   2. Run: git remote add origin [your-github-repo-url]"
        echo "   3. Run: git push -u origin main"
    fi
    
    echo ""
    echo "🌐 Netlify Git Integration Setup:"
    echo "   1. Go to https://app.netlify.com"
    echo "   2. Click 'New site from Git'"
    echo "   3. Connect to GitHub and select your repository"
    echo "   4. Set build directory to: netlify-deploy"
    echo "   5. Deploy!"
    echo ""
    echo "✨ After setup, every git push will automatically:"
    echo "   - Update the Pi (via git hooks)"
    echo "   - Update iloveugo.com (via Netlify)"
fi
EOF

chmod +x setup_netlify_git_integration.sh

# Create a file watcher for real-time updates (optional)
cat > watch_and_deploy.sh << 'EOF'
#!/bin/bash

echo "👀 Starting File Watcher for Auto-Deploy..."
echo "This will automatically deploy when you save files"
echo "Press Ctrl+C to stop"

# macOS file watching (requires fswatch: brew install fswatch)
if command -v fswatch &> /dev/null; then
    fswatch -o . --exclude='.git' --exclude='netlify-deploy' | while read f; do
        echo "📁 Files changed, auto-deploying..."
        ./auto_deploy.sh
    done
else
    echo "⚠️  fswatch not found. Install with: brew install fswatch"
    echo "📝 Alternative: Use ./auto_deploy.sh manually after making changes"
fi
EOF

chmod +x watch_and_deploy.sh

echo -e "${GREEN}✅ Auto-Deploy System Setup Complete!${NC}"
echo ""
echo -e "${BLUE}🎯 Available Deployment Options:${NC}"
echo ""
echo -e "${YELLOW}1. Manual Deploy (Current):${NC}"
echo "   ./deploy_to_pi.sh        # Update Pi only"
echo "   ./deploy_to_netlify.sh   # Update Netlify package only"
echo ""
echo -e "${YELLOW}2. Auto-Deploy on Git Commit:${NC}"
echo "   ./auto_deploy.sh         # Commit changes & deploy both"
echo ""
echo -e "${YELLOW}3. Real-time File Watching:${NC}"
echo "   ./watch_and_deploy.sh    # Auto-deploy when files change"
echo ""
echo -e "${YELLOW}4. Full Git Integration:${NC}"
echo "   ./setup_netlify_git_integration.sh  # Setup GitHub + Netlify"
echo ""
echo -e "${BLUE}🔄 How it works:${NC}"
echo "• Pi (192.168.68.69): Updates immediately"
echo "• Netlify (iloveugo.com): Package updated, manual upload OR Git integration"
echo ""
echo -e "${GREEN}🚀 Quick Start: Run ./auto_deploy.sh after making changes!${NC}"
