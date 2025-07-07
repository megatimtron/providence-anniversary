#!/bin/bash

# Watch for file changes and auto-deploy
# Usage: ./watch_and_deploy.sh

echo "👀 Watching for file changes..."
echo "🍓 Will auto-deploy to Pi when files change"
echo "🛑 Press Ctrl+C to stop"
echo ""

# Check if fswatch is installed
if ! command -v fswatch &> /dev/null; then
    echo "📦 Installing fswatch for file monitoring..."
    brew install fswatch
fi

# Watch for changes and auto-deploy
fswatch -o . --exclude='.git' --exclude='node_modules' --exclude='.DS_Store' | while read num ; do
    echo "🔄 Files changed, deploying..."
    ./git_deploy.sh "Auto-deploy: Files changed at $(date '+%H:%M:%S')"
    echo "✅ Auto-deployment complete"
    echo ""
done
