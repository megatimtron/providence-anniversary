#!/bin/bash
# 🎵 Providence Anniversary Media Server Setup
# Sets up the Raspberry Pi to serve songs, videos, photos, and data

echo "🚀 Setting up Providence Anniversary Media Server..."

# Create media directories on Pi
echo "📁 Creating media directories..."
mkdir -p media/songs
mkdir -p media/videos  
mkdir -p media/photos
mkdir -p media/uploads
mkdir -p data/memories
mkdir -p data/playlists

# Copy existing videos to media directory
echo "📹 Organizing existing videos..."
cp assets/videos/*.mp4 media/videos/ 2>/dev/null || echo "No videos to copy"

# Create sample song files (you'll add real songs later)
echo "🎵 Setting up music directory..."
cat > media/songs/playlist.json << 'EOF'
{
  "anniversary_playlist": [
    {
      "id": "song1",
      "title": "Our Song",
      "artist": "Your Favorite Artist",
      "file": "our-song.mp3",
      "memory": "The song that was playing when we first met"
    },
    {
      "id": "song2", 
      "title": "Wedding Dance",
      "artist": "Romantic Artist",
      "file": "wedding-dance.mp3",
      "memory": "Our first dance song"
    },
    {
      "id": "song3",
      "title": "Road Trip Anthem",
      "artist": "Fun Band",
      "file": "road-trip.mp3", 
      "memory": "The song we always sing on road trips"
    }
  ]
}
EOF

# Create photo gallery metadata
echo "📸 Setting up photo gallery..."
cat > media/photos/gallery.json << 'EOF'
{
  "albums": [
    {
      "id": "providence_memories",
      "title": "Providence Adventures",
      "description": "Our amazing times in Providence",
      "photos": []
    },
    {
      "id": "anniversary_photos",
      "title": "Anniversary Celebrations", 
      "description": "Special moments together",
      "photos": []
    }
  ]
}
EOF

# Create memories database
echo "💭 Setting up memories database..."
cat > data/memories/memories.json << 'EOF'
{
  "memories": [
    {
      "id": "mem1",
      "date": "2024-07-07",
      "title": "Planning Our Providence Trip",
      "description": "We spent hours researching the perfect restaurants and activities",
      "location": "Home",
      "photos": [],
      "mood": "excited"
    }
  ]
}
EOF

# Create simple media server script
echo "🖥️ Creating media server..."
cat > media_server.py << 'EOF'
#!/usr/bin/env python3
"""
Providence Anniversary Media Server
Serves songs, videos, photos, and manages memories
"""
import json
import os
from http.server import HTTPServer, SimpleHTTPRequestHandler
from urllib.parse import urlparse, parse_qs
import threading
import webbrowser

class MediaHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        parsed = urlparse(self.path)
        
        # API endpoints
        if parsed.path.startswith('/api/'):
            self.handle_api(parsed)
        # Media files
        elif parsed.path.startswith('/media/'):
            self.serve_media(parsed.path)
        # Default web content
        else:
            super().do_GET()
    
    def handle_api(self, parsed):
        """Handle API requests for data"""
        path = parsed.path[5:]  # Remove /api/
        
        if path == 'playlist':
            self.serve_json('media/songs/playlist.json')
        elif path == 'gallery':
            self.serve_json('media/photos/gallery.json')
        elif path == 'memories':
            self.serve_json('data/memories/memories.json')
        elif path == 'upload_photo':
            self.handle_photo_upload()
        else:
            self.send_error(404, "API endpoint not found")
    
    def serve_json(self, filepath):
        """Serve JSON file with proper headers"""
        try:
            with open(filepath, 'r') as f:
                data = f.read()
            
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.send_header('Access-Control-Allow-Origin', '*')
            self.end_headers()
            self.wfile.write(data.encode())
        except FileNotFoundError:
            self.send_error(404, f"File {filepath} not found")
    
    def serve_media(self, path):
        """Serve media files with proper headers"""
        filepath = path[1:]  # Remove leading /
        
        if not os.path.exists(filepath):
            self.send_error(404, "Media file not found")
            return
        
        # Determine content type
        if filepath.endswith('.mp3'):
            content_type = 'audio/mpeg'
        elif filepath.endswith('.mp4'):
            content_type = 'video/mp4'
        elif filepath.endswith(('.jpg', '.jpeg')):
            content_type = 'image/jpeg'
        elif filepath.endswith('.png'):
            content_type = 'image/png'
        else:
            content_type = 'application/octet-stream'
        
        try:
            with open(filepath, 'rb') as f:
                content = f.read()
            
            self.send_response(200)
            self.send_header('Content-Type', content_type)
            self.send_header('Access-Control-Allow-Origin', '*')
            self.send_header('Content-Length', str(len(content)))
            self.end_headers()
            self.wfile.write(content)
        except Exception as e:
            self.send_error(500, f"Error serving file: {e}")

def start_media_server(port=8080):
    """Start the media server"""
    server = HTTPServer(('0.0.0.0', port), MediaHandler)
    print(f"🎵 Media Server running on http://192.168.68.69:{port}")
    print(f"📱 Access from any device on your network!")
    server.serve_forever()

if __name__ == '__main__':
    start_media_server()
EOF

chmod +x media_server.py

# Create systemd service for auto-start
echo "⚙️ Creating auto-start service..."
cat > anniversary-media.service << 'EOF'
[Unit]
Description=Providence Anniversary Media Server
After=network.target

[Service]
Type=simple
User=pi
WorkingDirectory=/home/pi/anniversary-website
ExecStart=/usr/bin/python3 /home/pi/anniversary-website/media_server.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

echo "✅ Media server setup complete!"
echo ""
echo "📋 Next steps:"
echo "1. Copy your favorite songs to media/songs/ (as .mp3 files)"
echo "2. Add photos to media/photos/"
echo "3. Run: python3 media_server.py (for testing)"
echo "4. Install service: sudo cp anniversary-media.service /etc/systemd/system/"
echo "5. Enable service: sudo systemctl enable anniversary-media"
echo ""
echo "🎯 Your media will be available at:"
echo "   - Songs: http://192.168.68.69:8080/media/songs/"
echo "   - Videos: http://192.168.68.69:8080/media/videos/"
echo "   - Photos: http://192.168.68.69:8080/media/photos/"
echo "   - API: http://192.168.68.69:8080/api/playlist"
