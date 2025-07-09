#!/usr/bin/env python3
"""
Providence Anniversary API Server
Handles media uploads, data synchronization, and integration with the Pi
"""

from flask import Flask, request, jsonify, send_file, abort
from flask_cors import CORS
import os
import json
import sqlite3
import hashlib
import datetime
from werkzeug.utils import secure_filename
from PIL import Image
import io
import logging

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Create Flask app
app = Flask(__name__)
CORS(app)

# Configuration
UPLOAD_FOLDER = '/var/www/html/uploads'
MEDIA_FOLDER = '/var/www/html/media'
DATABASE_FILE = '/var/www/html/data/anniversary.db'
MAX_CONTENT_LENGTH = 16 * 1024 * 1024  # 16MB max file size

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['MEDIA_FOLDER'] = MEDIA_FOLDER
app.config['MAX_CONTENT_LENGTH'] = MAX_CONTENT_LENGTH

# Ensure directories exist
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(MEDIA_FOLDER, exist_ok=True)
os.makedirs(os.path.dirname(DATABASE_FILE), exist_ok=True)

# Initialize database
def init_db():
    conn = sqlite3.connect(DATABASE_FILE)
    cursor = conn.cursor()
    
    # Create tables
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS photos (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filename TEXT NOT NULL,
            caption TEXT,
            upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            file_hash TEXT,
            file_size INTEGER
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS songs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            filename TEXT NOT NULL,
            title TEXT,
            artist TEXT,
            upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            file_hash TEXT,
            file_size INTEGER
        )
    ''')
    
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS sync_data (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            data_type TEXT NOT NULL,
            data_json TEXT NOT NULL,
            sync_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    ''')
    
    conn.commit()
    conn.close()

# Helper functions
def get_file_hash(file_path):
    """Calculate SHA256 hash of a file"""
    hash_sha256 = hashlib.sha256()
    with open(file_path, "rb") as f:
        for chunk in iter(lambda: f.read(4096), b""):
            hash_sha256.update(chunk)
    return hash_sha256.hexdigest()

def allowed_file(filename, file_type='image'):
    """Check if file extension is allowed"""
    ALLOWED_EXTENSIONS = {
        'image': {'png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'},
        'audio': {'mp3', 'wav', 'ogg', 'flac', 'm4a'},
        'video': {'mp4', 'avi', 'mov', 'wmv', 'flv'}
    }
    
    if file_type not in ALLOWED_EXTENSIONS:
        return False
    
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS[file_type]

def optimize_image(image_path, max_size=(1920, 1080), quality=85):
    """Optimize image size and quality"""
    try:
        with Image.open(image_path) as img:
            # Convert to RGB if necessary
            if img.mode in ('RGBA', 'LA', 'P'):
                img = img.convert('RGB')
            
            # Resize if too large
            img.thumbnail(max_size, Image.Resampling.LANCZOS)
            
            # Save optimized image
            img.save(image_path, 'JPEG', quality=quality, optimize=True)
            
        return True
    except Exception as e:
        logger.error(f"Image optimization failed: {e}")
        return False

# API Routes
@app.route('/api/status', methods=['GET'])
def api_status():
    """Get API status and system info"""
    return jsonify({
        'status': 'online',
        'timestamp': datetime.datetime.now().isoformat(),
        'version': '1.0.0',
        'endpoints': {
            'upload_photo': '/api/upload/photo',
            'upload_song': '/api/upload/song',
            'sync': '/api/sync',
            'media': '/api/media',
            'photos': '/api/photos',
            'songs': '/api/songs'
        }
    })

@app.route('/api/upload/photo', methods=['POST'])
def upload_photo():
    """Upload and process a photo"""
    if 'photo' not in request.files:
        return jsonify({'error': 'No photo file provided'}), 400
    
    file = request.files['photo']
    caption = request.form.get('caption', '')
    
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    if not allowed_file(file.filename, 'image'):
        return jsonify({'error': 'Invalid file type'}), 400
    
    try:
        # Secure filename
        filename = secure_filename(file.filename)
        timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"{timestamp}_{filename}"
        
        # Save file
        file_path = os.path.join(UPLOAD_FOLDER, filename)
        file.save(file_path)
        
        # Optimize image
        if optimize_image(file_path):
            logger.info(f"Image optimized: {filename}")
        
        # Calculate file hash and size
        file_hash = get_file_hash(file_path)
        file_size = os.path.getsize(file_path)
        
        # Save to database
        conn = sqlite3.connect(DATABASE_FILE)
        cursor = conn.cursor()
        cursor.execute('''
            INSERT INTO photos (filename, caption, file_hash, file_size)
            VALUES (?, ?, ?, ?)
        ''', (filename, caption, file_hash, file_size))
        photo_id = cursor.lastrowid
        conn.commit()
        conn.close()
        
        return jsonify({
            'success': True,
            'photo_id': photo_id,
            'filename': filename,
            'caption': caption,
            'url': f'/api/media/photo/{filename}',
            'size': file_size
        })
        
    except Exception as e:
        logger.error(f"Photo upload failed: {e}")
        return jsonify({'error': 'Upload failed'}), 500

@app.route('/api/upload/song', methods=['POST'])
def upload_song():
    """Upload and process a song"""
    if 'song' not in request.files:
        return jsonify({'error': 'No song file provided'}), 400
    
    file = request.files['song']
    title = request.form.get('title', '')
    artist = request.form.get('artist', '')
    
    if file.filename == '':
        return jsonify({'error': 'No file selected'}), 400
    
    if not allowed_file(file.filename, 'audio'):
        return jsonify({'error': 'Invalid file type'}), 400
    
    try:
        # Secure filename
        filename = secure_filename(file.filename)
        timestamp = datetime.datetime.now().strftime('%Y%m%d_%H%M%S')
        filename = f"{timestamp}_{filename}"
        
        # Save file
        file_path = os.path.join(MEDIA_FOLDER, 'songs', filename)
        os.makedirs(os.path.dirname(file_path), exist_ok=True)
        file.save(file_path)
        
        # Calculate file hash and size
        file_hash = get_file_hash(file_path)
        file_size = os.path.getsize(file_path)
        
        # Save to database
        conn = sqlite3.connect(DATABASE_FILE)
        cursor = conn.cursor()
        cursor.execute('''
            INSERT INTO songs (filename, title, artist, file_hash, file_size)
            VALUES (?, ?, ?, ?, ?)
        ''', (filename, title, artist, file_hash, file_size))
        song_id = cursor.lastrowid
        conn.commit()
        conn.close()
        
        return jsonify({
            'success': True,
            'song_id': song_id,
            'filename': filename,
            'title': title,
            'artist': artist,
            'url': f'/api/media/song/{filename}',
            'size': file_size
        })
        
    except Exception as e:
        logger.error(f"Song upload failed: {e}")
        return jsonify({'error': 'Upload failed'}), 500

@app.route('/api/sync', methods=['POST'])
def sync_data():
    """Sync data from the client"""
    try:
        data = request.get_json()
        
        if not data:
            return jsonify({'error': 'No data provided'}), 400
        
        # Save sync data to database
        conn = sqlite3.connect(DATABASE_FILE)
        cursor = conn.cursor()
        
        for data_type, content in data.items():
            cursor.execute('''
                INSERT INTO sync_data (data_type, data_json)
                VALUES (?, ?)
            ''', (data_type, json.dumps(content)))
        
        conn.commit()
        conn.close()
        
        return jsonify({
            'success': True,
            'message': 'Data synced successfully',
            'timestamp': datetime.datetime.now().isoformat()
        })
        
    except Exception as e:
        logger.error(f"Sync failed: {e}")
        return jsonify({'error': 'Sync failed'}), 500

@app.route('/api/media/photo/<filename>')
def serve_photo(filename):
    """Serve uploaded photos"""
    try:
        file_path = os.path.join(UPLOAD_FOLDER, filename)
        if os.path.exists(file_path):
            return send_file(file_path)
        else:
            abort(404)
    except Exception as e:
        logger.error(f"Photo serve failed: {e}")
        abort(500)

@app.route('/api/media/song/<filename>')
def serve_song(filename):
    """Serve uploaded songs"""
    try:
        file_path = os.path.join(MEDIA_FOLDER, 'songs', filename)
        if os.path.exists(file_path):
            return send_file(file_path)
        else:
            abort(404)
    except Exception as e:
        logger.error(f"Song serve failed: {e}")
        abort(500)

@app.route('/api/photos', methods=['GET'])
def get_photos():
    """Get list of all photos"""
    try:
        conn = sqlite3.connect(DATABASE_FILE)
        cursor = conn.cursor()
        cursor.execute('''
            SELECT id, filename, caption, upload_date, file_size
            FROM photos
            ORDER BY upload_date DESC
        ''')
        
        photos = []
        for row in cursor.fetchall():
            photos.append({
                'id': row[0],
                'filename': row[1],
                'caption': row[2],
                'upload_date': row[3],
                'file_size': row[4],
                'url': f'/api/media/photo/{row[1]}'
            })
        
        conn.close()
        
        return jsonify({
            'success': True,
            'photos': photos,
            'count': len(photos)
        })
        
    except Exception as e:
        logger.error(f"Get photos failed: {e}")
        return jsonify({'error': 'Failed to get photos'}), 500

@app.route('/api/songs', methods=['GET'])
def get_songs():
    """Get list of all songs"""
    try:
        conn = sqlite3.connect(DATABASE_FILE)
        cursor = conn.cursor()
        cursor.execute('''
            SELECT id, filename, title, artist, upload_date, file_size
            FROM songs
            ORDER BY upload_date DESC
        ''')
        
        songs = []
        for row in cursor.fetchall():
            songs.append({
                'id': row[0],
                'filename': row[1],
                'title': row[2],
                'artist': row[3],
                'upload_date': row[4],
                'file_size': row[5],
                'url': f'/api/media/song/{row[1]}'
            })
        
        conn.close()
        
        return jsonify({
            'success': True,
            'songs': songs,
            'count': len(songs)
        })
        
    except Exception as e:
        logger.error(f"Get songs failed: {e}")
        return jsonify({'error': 'Failed to get songs'}), 500

@app.route('/api/backup', methods=['GET'])
def create_backup():
    """Create a backup of all data"""
    try:
        import zipfile
        import tempfile
        
        # Create temporary zip file
        temp_zip = tempfile.NamedTemporaryFile(delete=False, suffix='.zip')
        
        with zipfile.ZipFile(temp_zip.name, 'w') as zipf:
            # Add database
            zipf.write(DATABASE_FILE, 'anniversary.db')
            
            # Add all uploaded files
            for root, dirs, files in os.walk(UPLOAD_FOLDER):
                for file in files:
                    file_path = os.path.join(root, file)
                    zipf.write(file_path, f'uploads/{file}')
            
            # Add all media files
            for root, dirs, files in os.walk(MEDIA_FOLDER):
                for file in files:
                    file_path = os.path.join(root, file)
                    rel_path = os.path.relpath(file_path, MEDIA_FOLDER)
                    zipf.write(file_path, f'media/{rel_path}')
        
        return send_file(temp_zip.name, as_attachment=True, 
                        download_name=f'anniversary_backup_{datetime.datetime.now().strftime("%Y%m%d_%H%M%S")}.zip')
        
    except Exception as e:
        logger.error(f"Backup failed: {e}")
        return jsonify({'error': 'Backup failed'}), 500

@app.route('/api/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    return jsonify({
        'status': 'healthy',
        'timestamp': datetime.datetime.now().isoformat(),
        'disk_usage': {
            'uploads': len(os.listdir(UPLOAD_FOLDER)) if os.path.exists(UPLOAD_FOLDER) else 0,
            'media': len(os.listdir(MEDIA_FOLDER)) if os.path.exists(MEDIA_FOLDER) else 0
        }
    })

# Error handlers
@app.errorhandler(404)
def not_found(error):
    return jsonify({'error': 'Endpoint not found'}), 404

@app.errorhandler(500)
def internal_error(error):
    return jsonify({'error': 'Internal server error'}), 500

@app.errorhandler(413)
def file_too_large(error):
    return jsonify({'error': 'File too large'}), 413

# Initialize database on startup
if __name__ == '__main__':
    init_db()
    logger.info("Providence Anniversary API Server starting...")
    app.run(host='0.0.0.0', port=8080, debug=False)
