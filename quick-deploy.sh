#!/bin/bash

# 🚀 Quick Deploy Script - Deploy changes immediately
# Use this to push changes and trigger automatic deployment

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Get commit message
if [ -z "$1" ]; then
    echo -e "${YELLOW}💬 Enter commit message:${NC}"
    read -p "> " COMMIT_MSG
else
    COMMIT_MSG="$1"
fi

if [ -z "$COMMIT_MSG" ]; then
    COMMIT_MSG="Update site content"
fi

echo -e "${BLUE}🚀 Deploying changes...${NC}"
echo ""

# Stage changes
echo -e "${BLUE}📦 Staging changes...${NC}"
git add .

# Commit changes
echo -e "${BLUE}💾 Committing changes...${NC}"
git commit -m "$COMMIT_MSG" || echo "No changes to commit"

# Push to GitHub (triggers automatic deployment)
echo -e "${BLUE}🚀 Pushing to GitHub...${NC}"
git push origin main

echo ""
echo -e "${GREEN}✅ Deployment triggered!${NC}"
echo ""
echo -e "${BLUE}📋 What's happening:${NC}"
echo "• GitHub Actions is building your site"
echo "• Automatic deployment to Netlify"
echo "• Site will be live at https://iloveugo.com"
echo ""
echo -e "${BLUE}🔗 Check deployment status:${NC}"
echo "• GitHub Actions: https://github.com/$(git config --get remote.origin.url | sed 's|https://github.com/||' | sed 's|.git||')/actions"
echo "• Netlify: https://app.netlify.com/sites/$(git config --get remote.origin.url | sed 's|.*/||' | sed 's|\.git||')/deploys"
echo ""
echo -e "${GREEN}🎉 No drag and drop needed - fully automated!${NC}"
