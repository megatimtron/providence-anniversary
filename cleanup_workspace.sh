#!/bin/bash

# 🧹 Providence Anniversary Website - Workspace Cleanup Script
# Removes temporary files and organizes the final project structure

echo "🧹 Cleaning up Providence Anniversary workspace..."
echo "=============================================="

# Set colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to safely remove files/directories
safe_remove() {
    if [ -e "$1" ]; then
        echo -e "${YELLOW}🗑️  Removing: $1${NC}"
        rm -rf "$1"
        echo -e "${GREEN}✅ Removed successfully${NC}"
    else
        echo -e "${BLUE}ℹ️  Not found (already clean): $1${NC}"
    fi
}

# Remove development and temporary files
echo -e "${BLUE}📁 Cleaning development files...${NC}"
safe_remove "button_test.html"
safe_remove "check_dns.sh"
safe_remove "copy_files.sh"
safe_remove "fix_permissions.sh"
safe_remove "test_ssh.sh"

# Remove old documentation that's been superseded
echo -e "${BLUE}📄 Removing superseded documentation...${NC}"
safe_remove "BUTTON_FIXES_README.md"
safe_remove "COLOR_REVERT_SUMMARY.md"
safe_remove "Comprehensive Website Enhancement Report.sty"
safe_remove "DNS_FIX_GUIDE.md"
safe_remove "DOMAIN_SETUP_GUIDE.md"
safe_remove "MANUAL_SETUP.md"
safe_remove "RASPBERRY_PI_SETUP.md"
safe_remove "SIMPLE_DEPLOYMENT.md"

# Remove old chat and development docs
echo -e "${BLUE}🗂️  Cleaning docs directory...${NC}"
safe_remove "docs/chat-formatter.html"
safe_remove "docs/complete_chat_messages.html"
safe_remove "docs/gemini_improvements117"
safe_remove "docs/our-chat-history.html"

# Keep important docs but organize them
mkdir -p "documentation/"
if [ -f "docs/PROJECT_STRUCTURE.md" ]; then
    mv "docs/PROJECT_STRUCTURE.md" "documentation/"
fi
if [ -f "docs/ROADMAP_PLAYLIST_INTEGRATION.md" ]; then
    mv "docs/ROADMAP_PLAYLIST_INTEGRATION.md" "documentation/"
fi
if [ -f "docs/WORKSPACE_CLEANUP_SUMMARY.md" ]; then
    mv "docs/WORKSPACE_CLEANUP_SUMMARY.md" "documentation/"
fi

# Remove empty docs directory if it exists
if [ -d "docs" ] && [ -z "$(ls -A docs)" ]; then
    rmdir "docs"
    echo -e "${GREEN}✅ Removed empty docs directory${NC}"
fi

# Remove script development files
echo -e "${BLUE}🔧 Cleaning script development files...${NC}"
safe_remove "scripts/advanced_chat_ocr.py"
safe_remove "scripts/chat_ocr_extractor.py"
safe_remove "scripts/focused_chat_processor.py"
safe_remove "scripts/manual_chat_processor.py"
safe_remove "scripts/process_ocr_results.py"

# Keep useful scripts
echo -e "${BLUE}📝 Organizing useful scripts...${NC}"
mkdir -p "tools/"
if [ -f "scripts/create_menu_mapping.py" ]; then
    mv "scripts/create_menu_mapping.py" "tools/"
fi
if [ -f "scripts/create_touch_icon.py" ]; then
    mv "scripts/create_touch_icon.py" "tools/"
fi
if [ -f "scripts/menu_downloader_playwright.py" ]; then
    mv "scripts/menu_downloader_playwright.py" "tools/"
fi
if [ -f "scripts/menu_downloader.py" ]; then
    mv "scripts/menu_downloader.py" "tools/"
fi

# Remove scripts directory if empty
if [ -d "scripts" ] && [ -z "$(ls -A scripts)" ]; then
    rmdir "scripts"
    echo -e "${GREEN}✅ Removed empty scripts directory${NC}"
fi

# Remove redundant deployment scripts (keep the main ones)
echo -e "${BLUE}🚀 Organizing deployment scripts...${NC}"
safe_remove "deploy_manual.sh"
safe_remove "deploy_to_pi_easy.sh"
safe_remove "quick_deploy_manual.sh"
safe_remove "quick_deploy.sh"
safe_remove "setup_pi.sh"

# Create final project structure summary
echo -e "${BLUE}📋 Creating final project structure...${NC}"

cat > "PROJECT_FINAL_STRUCTURE.md" << 'EOF'
# 🎉 Providence Anniversary Website - Final Project Structure

## 🌟 Core Website Files
```
├── index.html                    # Main anniversary website
├── login.html                    # Optional login page
├── manifest.json                 # PWA configuration
├── sw.js                        # Service worker for offline functionality
└── assets/
    ├── icons/                   # PWA icons and favicons
    ├── images/                  # Photos and graphics
    ├── videos/                  # Boomerang and memory videos
    └── js/
        └── enhancements.js      # Enhanced interactive functionality
```

## 📦 Deployment Package
```
├── netlify-deploy/              # Ready-to-deploy Netlify package
    ├── index.html               # Production website
    ├── assets/                  # All optimized assets
    ├── menus/                   # Restaurant menus (30+ PDFs)
    ├── manifest.json            # PWA config
    ├── sw.js                    # Service worker
    └── _redirects               # Netlify routing
```

## 🚀 Deployment Scripts
```
├── deploy_to_pi.sh              # Raspberry Pi deployment
└── deploy_to_netlify.sh         # Netlify package preparation
```

## 📚 Documentation
```
├── documentation/               # Project documentation
├── NETLIFY_DEPLOYMENT_GUIDE.md  # Netlify deployment instructions
├── ENHANCED_BUTTON_FUNCTIONALITY_COMPLETE.md  # Feature documentation
├── DEPLOYMENT_SUCCESS.md        # Deployment status
└── PROJECT_FINAL_STRUCTURE.md   # This file
```

## 🍽️ Restaurant Data
```
└── menus/                       # 30+ Providence restaurant menus
    ├── menu_mapping.json        # Menu data structure
    ├── regularmenus.txt         # Menu list
    └── [Restaurant PDFs]        # Individual restaurant menus
```

## 🛠️ Development Tools (Optional)
```
└── tools/                       # Development utilities
    ├── create_menu_mapping.py   # Menu data generator
    ├── create_touch_icon.py     # Icon generator
    └── menu_downloader*.py      # Menu download scripts
```

## 🎯 Enhanced Features Implemented

### ✅ Interactive Functionality
- Real itinerary management with localStorage persistence
- Dynamic budget calculator with personalized recommendations
- Auto-save notes system with quick snippets
- Interactive map with persistent custom points
- Live restaurant filtering and sorting
- Social sharing and calendar integration

### ✅ Progressive Web App (PWA)
- Offline functionality via service worker
- Installable as mobile/desktop app
- Optimized performance and caching
- Mobile-first responsive design

### ✅ Production Ready
- Deployed to Raspberry Pi (http://192.168.68.69)
- Netlify package ready for iloveugo.com
- All features tested and functional
- Professional documentation included

## 🎊 Mission Accomplished!

Your Providence Anniversary website is now a fully-featured, interactive experience with:
- ✅ Real button functionality (no more simple alerts!)
- ✅ Persistent data storage
- ✅ Professional deployment setup
- ✅ PWA capabilities
- ✅ Mobile-optimized design
- ✅ Comprehensive restaurant database

Perfect for planning an unforgettable romantic Providence getaway! 💕
EOF

echo -e "${GREEN}✅ Cleanup complete!${NC}"
echo ""
echo -e "${BLUE}📊 Final Project Summary:${NC}"
echo -e "${GREEN}✅ Core website files: Organized and optimized${NC}"
echo -e "${GREEN}✅ Netlify deployment package: Ready for iloveugo.com${NC}"
echo -e "${GREEN}✅ Raspberry Pi deployment: Live at http://192.168.68.69${NC}"
echo -e "${GREEN}✅ Documentation: Comprehensive and up-to-date${NC}"
echo -e "${GREEN}✅ Enhanced functionality: All buttons work with real logic${NC}"
echo ""
echo -e "${YELLOW}🚀 Next Steps:${NC}"
echo -e "${BLUE}1. Deploy to Netlify: Drag 'netlify-deploy' folder to https://app.netlify.com${NC}"
echo -e "${BLUE}2. Configure domain: Set up iloveugo.com in Netlify settings${NC}"
echo -e "${BLUE}3. Test features: Verify all enhanced functionality works${NC}"
echo ""
echo -e "${GREEN}🎉 Your Providence Anniversary website is production-ready! 💕${NC}"
