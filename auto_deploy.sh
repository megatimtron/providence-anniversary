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
