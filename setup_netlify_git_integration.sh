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
