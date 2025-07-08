#!/bin/bash

echo "👀 Watching for file changes..."
echo "Press Ctrl+C to stop"

# Install fswatch if not available (macOS)
if ! command -v fswatch &> /dev/null; then
    echo "📦 Installing fswatch..."
    brew install fswatch
fi

# Watch for changes and auto-sync
fswatch -o . \
    --exclude='.git' \
    --exclude='node_modules' \
    --exclude='*.log' \
    --exclude='auto_sync_to_git.sh' \
    --exclude='watch_and_auto_sync.sh' | while read f; do
    
    echo "🔄 Changes detected, syncing..."
    sleep 2  # Brief delay to avoid rapid-fire syncs
    ./auto_sync_to_git.sh
done
