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
