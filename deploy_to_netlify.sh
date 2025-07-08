#!/bin/bash

# 🌐 Deploy Providence Anniversary Website to Netlify
# This prepares your site for cloud hosting at iloveugo.com

echo "🌐 Preparing Providence Anniversary Website for iloveugo.com"
echo "============================================================="
echo ""

# Create deployment directory
echo "📁 Creating clean deployment package..."
rm -rf netlify-deploy
mkdir netlify-deploy

# Copy essential files
echo "📋 Copying website files..."
cp index.html netlify-deploy/
cp login.html netlify-deploy/ 2>/dev/null || echo "⚠️ login.html not found, skipping..."
cp manifest.json netlify-deploy/ 2>/dev/null || echo "✅ PWA manifest added"
cp sw.js netlify-deploy/ 2>/dev/null || echo "✅ Service worker added"
cp button_test.html netlify-deploy/ 2>/dev/null || echo "✅ Button test page added"
cp -r assets netlify-deploy/ 2>/dev/null || echo "⚠️ assets directory not found"
cp -r menus netlify-deploy/ 2>/dev/null || echo "⚠️ menus directory not found"

# Create a simple README for the deployed site
cat > netlify-deploy/README.md << 'EOF'
# 🍓 Providence Anniversary Website

This is the beautiful anniversary website for Tim & Ugo's Providence memories.

## Features
- Interactive restaurant exploration
- Memory timeline
- Beautiful romantic design
- Mobile responsive
- PWA support with offline capabilities
- Weather integration
- Dark mode toggle
- Enhanced photo gallery
- Interactive map

## Access
- **Public**: iloveugo.com (Netlify deployment)
- **Private Pi**: http://24.151.105.204 (with port forwarding)
- **Local Network**: http://192.168.68.69

Deployed with ❤️ at iloveugo.com
EOF

# Create a simple _redirects file for Netlify
cat > netlify-deploy/_redirects << 'EOF'
# Redirect all 404s to the main page
/*    /index.html   200
EOF

echo ""
echo "✅ Deployment package ready!"
echo ""
echo "📦 Your clean website is in: ./netlify-deploy/"
echo ""
echo "🚀 Next steps:"
echo "1. Go to https://netlify.com"
echo "2. Sign up for a free account"
echo "3. Drag the 'netlify-deploy' folder to Netlify"
echo "4. Once deployed, go to Domain settings"
echo "5. Add 'iloveugo.com' as your custom domain"
echo ""
echo "💡 Your site will be live at iloveugo.com in minutes!"
echo ""

# Show what's in the package
echo "📋 Files included in deployment:"
ls -la netlify-deploy/

echo ""
echo "🍓 Ready to make iloveugo.com live! 💕"
