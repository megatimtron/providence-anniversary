#!/bin/bash

# Quick Git Deploy Script
# Usage: ./git_deploy.sh "Your commit message"

COMMIT_MSG=${1:-"Update Providence Anniversary website - $(date '+%Y-%m-%d %H:%M')"}

echo "🍓 Deploying Providence Anniversary website to Raspberry Pi..."
echo "📝 Commit message: ${COMMIT_MSG}"
echo ""

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    echo "❌ Not in a Git repository. Run setup_git_deployment.sh first!"
    exit 1
fi

# Check if pi remote exists
if ! git remote get-url pi > /dev/null 2>&1; then
    echo "❌ Pi remote not configured. Run setup_git_deployment.sh first!"
    exit 1
fi

# Stage all changes
echo "📦 Staging changes..."
git add .

# Check if there are changes to commit
if git diff --staged --quiet; then
    echo "⚠️  No changes to deploy"
    exit 0
fi

# Commit changes
echo "💾 Committing changes..."
git commit -m "${COMMIT_MSG}"

# Deploy to Pi
echo "🚀 Deploying to Raspberry Pi..."
git push pi main

echo ""
echo "✅ Deployment complete!"
echo "🌐 Check your website at your Pi's IP address"
