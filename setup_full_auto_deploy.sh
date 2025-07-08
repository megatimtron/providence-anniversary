#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 SETTING UP FULL AUTO-DEPLOYMENT PIPELINE${NC}"
echo "=============================================="
echo ""
echo "This will create a complete automation pipeline:"
echo "  1. 📱 Pi changes → Auto-commit to Git"
echo "  2. 🔄 Git push → Auto-deploy to Netlify" 
echo "  3. 🌐 iloveugo.com updates automatically!"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}📁 Initializing Git repository...${NC}"
    git init
    git add .
    git commit -m "Initial Providence Anniversary Website setup"
fi

# Create GitHub repository setup
echo -e "${BLUE}📝 Step 1: GitHub Repository Setup${NC}"
echo "=================================="

read -p "Have you created a GitHub repository yet? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "🌐 Please create a GitHub repository first:"
    echo "   1. Go to https://github.com/new"
    echo "   2. Repository name: provitinerary (or your choice)"
    echo "   3. Set as Public or Private"
    echo "   4. Don't initialize with README (we have files already)"
    echo "   5. Click 'Create repository'"
    echo ""
    read -p "Press Enter when you've created the GitHub repository..."
fi

echo ""
read -p "Enter your GitHub repository URL (e.g., https://github.com/username/provitinerary.git): " GITHUB_URL

if [ ! -z "$GITHUB_URL" ]; then
    echo -e "${YELLOW}🔗 Connecting to GitHub...${NC}"
    
    # Remove existing origin if it exists
    git remote remove origin 2>/dev/null || true
    
    # Add new origin
    git remote add origin "$GITHUB_URL"
    
    # Push to GitHub
    echo -e "${YELLOW}📤 Pushing to GitHub...${NC}"
    git branch -M main
    git push -u origin main
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Successfully connected to GitHub!${NC}"
    else
        echo -e "${RED}❌ Failed to push to GitHub. Please check your URL and permissions.${NC}"
        exit 1
    fi
fi

# Create auto-sync script for Pi
echo -e "${BLUE}📱 Step 2: Pi Auto-Sync Setup${NC}"
echo "=============================="

cat > auto_sync_to_git.sh << 'EOF'
#!/bin/bash

# Auto-sync Pi changes to Git and trigger Netlify deploy
echo "🔄 Auto-syncing changes to Git..."

# Check for changes
if ! git diff --quiet || ! git diff --cached --quiet; then
    
    # Stage all changes
    git add .
    
    # Create commit with timestamp
    commit_msg="Auto-update from Pi - $(date '+%Y-%m-%d %H:%M:%S')"
    git commit -m "$commit_msg"
    
    # Push to GitHub (this will trigger Netlify)
    echo "📤 Pushing to GitHub..."
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo "✅ Successfully synced to GitHub!"
        echo "🌐 Netlify will auto-deploy to iloveugo.com in ~2-3 minutes"
    else
        echo "❌ Failed to push to GitHub"
    fi
    
else
    echo "📋 No changes to sync"
fi
EOF

chmod +x auto_sync_to_git.sh

# Create watch script for real-time sync
cat > watch_and_auto_sync.sh << 'EOF'
#!/bin/bash

echo "👀 Watching for file changes..."
echo "Press Ctrl+C to stop"

# Install fswatch if not available (macOS)
if ! command -v fswatch &> /dev/null; then
    echo "📦 Installing fswatch..."
    brew install fswatch
fi

# Watch for changes and auto-sync
fswatch -o . \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='*.log' \
    --exclude='auto_sync_to_git.sh' \
    --exclude='watch_and_auto_sync.sh' | while read f; do
    
    echo "🔄 Changes detected, syncing..."
    sleep 2  # Brief delay to avoid rapid-fire syncs
    ./auto_sync_to_git.sh
done
EOF

chmod +x watch_and_auto_sync.sh

# Netlify setup instructions
echo ""
echo -e "${BLUE}🌐 Step 3: Netlify Git Integration${NC}"
echo "=================================="

echo "Now let's connect Netlify to your GitHub repository:"
echo ""
echo "1. Open: https://app.netlify.com"
echo "2. Click 'New site from Git'"
echo "3. Choose 'GitHub' as your Git provider"
echo "4. Select your repository: $(basename "$GITHUB_URL" .git)"
echo "5. Configure build settings:"
echo "   - Build command: (leave empty)"
echo "   - Publish directory: netlify-deploy"
echo "6. Click 'Deploy site'"
echo ""
echo "7. Set up custom domain:"
echo "   - Go to Site settings → Domain management"
echo "   - Add custom domain: iloveugo.com"
echo "   - Follow DNS configuration instructions"
echo ""

read -p "Press Enter when you've completed the Netlify setup..."

# Create netlify.toml for build configuration
echo -e "${YELLOW}📝 Creating Netlify configuration...${NC}"

cat > netlify.toml << 'EOF'
[build]
  publish = "netlify-deploy"
  
[build.environment]
  NODE_VERSION = "18"

[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-XSS-Protection = "1; mode=block"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"

[[headers]]
  for = "/assets/*"
  [headers.values]
    Cache-Control = "public, max-age=31536000"

# PWA Service Worker
[[headers]]
  for = "/sw.js"
  [headers.values]
    Cache-Control = "public, max-age=0, must-revalidate"
    Service-Worker-Allowed = "/"
EOF

# Commit netlify.toml
git add netlify.toml
git commit -m "Add Netlify configuration"
git push origin main

echo ""
echo -e "${GREEN}🎉 AUTOMATION SETUP COMPLETE!${NC}"
echo "=============================="
echo ""
echo -e "${BLUE}🔄 How it works now:${NC}"
echo "1. Make changes on your Pi"
echo "2. Run: ${YELLOW}./auto_sync_to_git.sh${NC} (manual sync)"
echo "   OR run: ${YELLOW}./watch_and_auto_sync.sh${NC} (automatic watching)"
echo "3. Changes are pushed to GitHub"
echo "4. Netlify automatically deploys to iloveugo.com"
echo ""
echo -e "${BLUE}📱 For Pi deployment:${NC}"
echo "- Local Pi: http://192.168.68.69"
echo "- Use existing deploy scripts or auto-sync"
echo ""
echo -e "${BLUE}🌐 For production:${NC}"
echo "- iloveugo.com will update automatically via Netlify"
echo "- Deploy time: ~2-3 minutes after git push"
echo ""
echo -e "${YELLOW}💡 Pro tip:${NC} Run ${YELLOW}./watch_and_auto_sync.sh${NC} to automatically"
echo "sync any file changes to both Pi and Netlify!"

# Create a status check script
cat > check_deployment_status.sh << 'EOF'
#!/bin/bash

echo "📊 DEPLOYMENT STATUS CHECK"
echo "=========================="

echo ""
echo "🏠 Local Pi Status:"
if curl -s --connect-timeout 5 http://192.168.68.69 >/dev/null; then
    echo "✅ Pi is live at http://192.168.68.69"
else
    echo "❌ Pi is not accessible"
fi

echo ""
echo "🌐 GitHub Status:"
git remote -v
echo "Latest commit: $(git log -1 --pretty=format:'%h - %s (%cr)')"

echo ""
echo "📝 To sync changes:"
echo "  Manual: ./auto_sync_to_git.sh"
echo "  Auto:   ./watch_and_auto_sync.sh"
EOF

chmod +x check_deployment_status.sh

echo ""
echo -e "${GREEN}✨ Your Providence Anniversary website now has full automation!${NC}"
echo ""
echo "🚀 Next steps:"
echo "1. Test the sync: ./auto_sync_to_git.sh"
echo "2. Check status: ./check_deployment_status.sh"
echo "3. Enable auto-watch: ./watch_and_auto_sync.sh"
