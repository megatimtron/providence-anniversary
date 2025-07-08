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
