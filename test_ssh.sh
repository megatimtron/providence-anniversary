#!/bin/bash

echo "🔍 SSH Connection Test for Raspberry Pi"
echo "========================================="
echo ""

echo "Testing connection to: 192.168.68.69"
echo ""

echo "📋 Common Raspberry Pi default credentials to try:"
echo "   Username: pi, Password: raspberry"
echo "   Username: pi, Password: Fratesi7!"
echo "   Username: admin, Password: admin"
echo "   Username: root, Password: raspberry"
echo ""

echo "🚨 TROUBLESHOOTING TIPS:"
echo "1. Make sure Caps Lock is OFF"
echo "2. Type password slowly and carefully"
echo "3. Check if you're using the right keyboard layout"
echo "4. Try connecting from the Pi directly (if you have monitor/keyboard)"
echo ""

echo "Let's test the connection..."
echo "⚠️  When prompted, try these passwords in order:"
echo "   1. Fratesi7!"
echo "   2. raspberry"
echo "   3. (whatever you think the password might be)"
echo ""

read -p "Press Enter to test SSH connection..."

ssh -o ConnectTimeout=10 pi@192.168.68.69
