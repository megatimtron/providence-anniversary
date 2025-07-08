#!/bin/bash

echo "📊 DEPLOYMENT STATUS CHECK"
echo "=========================="

echo ""
echo "🏠 Local Pi Status:"
if curl -s --connect-timeout 5 http://192.168.68.69 >/dev/null; then
    echo "✅ Pi is live at http://192.168.68.69"
else
    echo "❌ Pi is not accessible"
fi

echo ""
echo "🌐 GitHub Status:"
git remote -v
echo "Latest commit: $(git log -1 --pretty=format:'%h - %s (%cr)')"

echo ""
echo "📝 To sync changes:"
echo "  Manual: ./auto_sync_to_git.sh"
echo "  Auto:   ./watch_and_auto_sync.sh"
