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
cp login.html netlify-deploy/
cp -r assets netlify-deploy/
cp -r menus netlify-deploy/

# Create a simple README for the deployed site
cat > netlify-deploy/README.md << 'EOF'
# 🍓 Providence Anniversary Website

This is the beautiful anniversary website for Tim & Ugo's Providence memories.

## Features
- Interactive restaurant exploration
- Memory timeline
- Beautiful romantic design
- Mobile responsive

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
