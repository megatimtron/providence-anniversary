// Providence Anniversary Website - Complete Enhanced Features
// All button functions, interactive features, and Pi server integration

class ProvidenceAnniversaryApp {
    constructor() {
        this.providenceCoords = { lat: 41.8240, lng: -71.4128 };
        this.map = null;
        this.isEditMode = false;
        this.currentAudio = null;
        this.playlist = [];
        this.playlistIndex = 0;
        this.isPlaying = false;
        
        // Load data from localStorage
        this.itineraryData = this.loadData('anniversary_itinerary', this.getDefaultItinerary());
        this.notesData = this.loadData('anniversary_notes', {});
        this.customMapPoints = this.loadData('anniversary_custom_points', []);
        this.budgetData = this.loadData('anniversary_budget', { meals: 200, drinks: 100, extras: 150 });
        this.userPlaylists = this.loadData('anniversary_playlists', []);
        this.songMemories = this.loadData('anniversary_song_memories', []);
        
        this.initializeApp();
    }

    async initializeApp() {
        this.setupEventListeners();
        this.setupButtonFunctions();
        this.setupPhotoGallery();
        this.setupInteractiveMap();
        this.setupOfflineMode();
        this.setupPWAInstallPrompt();
        this.restoreUserData();
        this.initializeMusic();
        console.log('🎉 Providence Anniversary App initialized!');
    }

    // =================================================================
    // BUTTON FUNCTIONS - All missing onclick handlers
    // =================================================================

    setupButtonFunctions() {
        // Make functions globally available for onclick handlers
        window.scrollToSection = this.scrollToSection.bind(this);
        window.showLoveNote = this.showLoveNote.bind(this);
        window.generateBudgetPlan = this.generateBudgetPlan.bind(this);
        window.focusMapLocation = this.focusMapLocation.bind(this);
        window.startAddingCustomPoint = this.startAddingCustomPoint.bind(this);
        window.viewCustomPoints = this.viewCustomPoints.bind(this);
        window.clearCustomPoints = this.clearCustomPoints.bind(this);
        window.showMusicServicesModal = this.showMusicServicesModal.bind(this);
        window.toggleMusic = this.toggleMusic.bind(this);
        window.openModal = this.openModal.bind(this);
        window.closeModal = this.closeModal.bind(this);
        
        // Missing map functions
        window.showLocationDetails = this.showLocationDetails.bind(this);
        window.hideLocationPanel = this.hideLocationPanel.bind(this);
        window.getDirections = this.getDirections.bind(this);
        window.requestUber = this.requestUber.bind(this);
        window.showMoreInfo = this.showMoreInfo.bind(this);
        
        // Missing music functions
        window.playSoundCloudSong = this.playSoundCloudSong.bind(this);
        window.uploadAudioFile = this.uploadAudioFile.bind(this);
        window.shufflePlaylist = this.shufflePlaylist.bind(this);
        window.playAll = this.playAll.bind(this);
        window.stopAll = this.stopAll.bind(this);
        window.removeSong = this.removeSong.bind(this);
        
        // Missing playlist functions
        window.createFromTemplate = this.createFromTemplate.bind(this);
        window.generateActivityPlaylist = this.generateActivityPlaylist.bind(this);
        window.generateMoodPlaylist = this.generateMoodPlaylist.bind(this);
        window.exploreLocalArtists = this.exploreLocalArtists.bind(this);
        window.generateVenuePlaylist = this.generateVenuePlaylist.bind(this);
        window.getLocalRadioHits = this.getLocalRadioHits.bind(this);
        window.shareToSocial = this.shareToSocial.bind(this);
        window.exportPlaylist = this.exportPlaylist.bind(this);
        window.simulateCollaboration = this.simulateCollaboration.bind(this);
        window.openCreatePlaylistModal = this.openCreatePlaylistModal.bind(this);
        window.sharePlaylist = this.sharePlaylist.bind(this);
        
        // Enhanced functions
        window.toggleEditMode = this.toggleEditMode.bind(this);
        window.addItineraryItem = this.addItineraryItem.bind(this);
        window.saveItinerary = this.saveItinerary.bind(this);
        window.resetItinerary = this.resetItinerary.bind(this);
        window.showPhotoUploadModal = this.showPhotoUploadModal.bind(this);
        window.syncWithPiServer = this.syncWithPiServer.bind(this);
    }

    // =================================================================
    // CORE UTILITY FUNCTIONS
    // =================================================================

    loadData(key, defaultValue) {
        try {
            const data = localStorage.getItem(key);
            return data ? JSON.parse(data) : defaultValue;
        } catch (error) {
            console.error(`Error loading ${key}:`, error);
            return defaultValue;
        }
    }

    saveData(key, data) {
        try {
            localStorage.setItem(key, JSON.stringify(data));
        } catch (error) {
            console.error(`Error saving ${key}:`, error);
        }
    }

    showNotification(message, type = 'success') {
        const notification = document.createElement('div');
        notification.className = `fixed top-4 right-4 z-50 p-4 rounded-lg shadow-lg transition-all duration-300 ${
            type === 'success' ? 'bg-green-500 text-white' : 
            type === 'error' ? 'bg-red-500 text-white' : 
            'bg-blue-500 text-white'
        }`;
        notification.innerHTML = `
            <div class="flex items-center gap-2">
                <span>${type === 'success' ? '✅' : type === 'error' ? '❌' : 'ℹ️'}</span>
                <span>${message}</span>
            </div>
        `;
        document.body.appendChild(notification);
        
        setTimeout(() => {
            notification.style.opacity = '0';
            setTimeout(() => notification.remove(), 300);
        }, 3000);
    }

    // =================================================================
    // MAP FUNCTIONS
    // =================================================================

    showLocationDetails(locationId) {
        const locations = {
            'gracies': {
                name: "Gracie's Restaurant",
                address: "194 Washington St, Providence, RI",
                phone: "(401) 272-7811",
                hours: "Tue-Sat 5:30-10:00 PM",
                description: "Upscale New American cuisine in an intimate setting",
                website: "https://www.graciesrestaurant.com"
            },
            'federal-hill': {
                name: "Federal Hill",
                address: "Atwells Ave, Providence, RI",
                description: "Little Italy of Providence with authentic Italian restaurants",
                highlights: ["Authentic Italian cuisine", "Historic neighborhood", "Festival atmosphere"]
            },
            'waterfront': {
                name: "Providence Waterfront",
                address: "India Point Park, Providence, RI",
                description: "Scenic waterfront with walking paths and harbor views",
                highlights: ["Harbor views", "Walking paths", "Sunset photography"]
            },
            'downtown': {
                name: "Downtown Providence",
                address: "Downtown Providence, RI",
                description: "Historic downtown with shopping, dining, and entertainment",
                highlights: ["Historic architecture", "Shopping", "Nightlife"]
            }
        };

        const location = locations[locationId];
        if (!location) {
            this.showNotification('Location not found', 'error');
            return;
        }

        // Show location panel
        const panel = document.getElementById('location-panel');
        if (panel) {
            panel.classList.remove('hidden');
            
            // Update panel content
            document.getElementById('location-name').textContent = location.name;
            document.getElementById('location-address').textContent = location.address;
            document.getElementById('location-description').textContent = location.description;
            
            // Update buttons with location-specific data
            const directionsBtn = document.getElementById('directions-btn');
            const uberBtn = document.getElementById('uber-btn');
            
            if (directionsBtn) directionsBtn.dataset.location = locationId;
            if (uberBtn) uberBtn.dataset.location = locationId;
        }

        this.showNotification(`Showing details for ${location.name}`, 'info');
    }

    hideLocationPanel() {
        const panel = document.getElementById('location-panel');
        if (panel) {
            panel.classList.add('hidden');
        }
    }

    getDirections() {
        const activeLocation = document.getElementById('directions-btn')?.dataset.location;
        if (!activeLocation) return;
        
        const addresses = {
            'gracies': "194 Washington St, Providence, RI",
            'federal-hill': "Atwells Ave, Providence, RI",
            'waterfront': "India Point Park, Providence, RI",
            'downtown': "Downtown Providence, RI"
        };
        
        const address = addresses[activeLocation];
        if (address) {
            const googleMapsUrl = `https://www.google.com/maps/dir/?api=1&destination=${encodeURIComponent(address)}`;
            window.open(googleMapsUrl, '_blank');
            this.showNotification('Opening directions in Google Maps', 'info');
        }
    }

    requestUber() {
        const activeLocation = document.getElementById('uber-btn')?.dataset.location;
        if (!activeLocation) return;
        
        const addresses = {
            'gracies': "194 Washington St, Providence, RI",
            'federal-hill': "Atwells Ave, Providence, RI",
            'waterfront': "India Point Park, Providence, RI",
            'downtown': "Downtown Providence, RI"
        };
        
        const address = addresses[activeLocation];
        if (address) {
            const uberUrl = `https://m.uber.com/ul/?action=setPickup&dropoff[formatted_address]=${encodeURIComponent(address)}`;
            window.open(uberUrl, '_blank');
            this.showNotification('Opening Uber for ride request', 'info');
        }
    }

    showMoreInfo() {
        const activeLocation = document.getElementById('info-btn')?.dataset.location;
        if (!activeLocation) return;
        
        const websites = {
            'gracies': "https://www.graciesrestaurant.com",
            'federal-hill': "https://www.federalhillprov.com",
            'waterfront': "https://www.providence.gov/parks",
            'downtown': "https://www.goprovidence.com"
        };
        
        const website = websites[activeLocation];
        if (website) {
            window.open(website, '_blank');
            this.showNotification('Opening website for more information', 'info');
        }
    }

    // =================================================================
    // MUSIC FUNCTIONS
    // =================================================================

    initializeMusic() {
        // Initialize default playlist
        this.playlist = [
            {
                id: 'burning-blue',
                title: 'Burning Blue',
                artist: 'Mariah the Scientist',
                url: 'https://soundcloud.com/mariahthescientist/burning-blue',
                type: 'soundcloud'
            },
            {
                id: 'little-things',
                title: 'Little Things',
                artist: 'Ella Mai',
                url: 'https://soundcloud.com/ellamai/little-things',
                type: 'soundcloud'
            }
        ];
    }

    playSoundCloudSong(title, artist, url) {
        this.showNotification(`Playing: ${title} by ${artist}`, 'info');
        
        // Stop current audio
        if (this.currentAudio) {
            this.currentAudio.pause();
            this.currentAudio = null;
        }
        
        // Update UI
        document.getElementById('current-song-title').textContent = title;
        document.getElementById('current-song-artist').textContent = artist;
        
        // Since we can't directly play SoundCloud, show embedded player
        const player = document.getElementById('music-player');
        if (player) {
            player.innerHTML = `
                <iframe width="100%" height="166" scrolling="no" frameborder="no" allow="autoplay" 
                        src="https://w.soundcloud.com/player/?url=${encodeURIComponent(url)}&color=%23ff5500&auto_play=true&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true">
                </iframe>
            `;
            player.classList.remove('hidden');
        }
        
        this.isPlaying = true;
        this.updatePlayButtons();
    }

    uploadAudioFile() {
        const input = document.createElement('input');
        input.type = 'file';
        input.accept = 'audio/*';
        input.onchange = (e) => {
            const file = e.target.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = (e) => {
                    const audioUrl = e.target.result;
                    const newSong = {
                        id: Date.now().toString(),
                        title: file.name.replace(/\.[^/.]+$/, ""),
                        artist: 'Your Upload',
                        url: audioUrl,
                        type: 'upload'
                    };
                    
                    this.playlist.push(newSong);
                    this.saveData('anniversary_playlist', this.playlist);
                    this.showNotification(`Added ${newSong.title} to your collection`, 'success');
                    this.updateSongsList();
                };
                reader.readAsDataURL(file);
            }
        };
        input.click();
    }

    shufflePlaylist() {
        if (this.playlist.length === 0) {
            this.showNotification('No songs in playlist', 'error');
            return;
        }
        
        for (let i = this.playlist.length - 1; i > 0; i--) {
            const j = Math.floor(Math.random() * (i + 1));
            [this.playlist[i], this.playlist[j]] = [this.playlist[j], this.playlist[i]];
        }
        
        this.showNotification('Playlist shuffled! 🔀', 'success');
        this.updateSongsList();
    }

    playAll() {
        if (this.playlist.length === 0) {
            this.showNotification('No songs in playlist', 'error');
            return;
        }
        
        this.playlistIndex = 0;
        this.playCurrentSong();
        this.showNotification('Playing all songs! 🎵', 'success');
    }

    stopAll() {
        if (this.currentAudio) {
            this.currentAudio.pause();
            this.currentAudio = null;
        }
        
        this.isPlaying = false;
        this.updatePlayButtons();
        
        // Hide music player
        const player = document.getElementById('music-player');
        if (player) {
            player.classList.add('hidden');
        }
        
        this.showNotification('All music stopped', 'info');
    }

    removeSong(button) {
        const songItem = button.closest('.song-item');
        if (songItem) {
            const title = songItem.querySelector('.text-white').textContent;
            
            // Find and remove from playlist
            this.playlist = this.playlist.filter(song => song.title !== title);
            this.saveData('anniversary_playlist', this.playlist);
            
            // Remove from DOM
            songItem.remove();
            this.showNotification(`Removed ${title} from playlist`, 'success');
        }
    }

    playCurrentSong() {
        if (this.playlistIndex >= this.playlist.length) {
            this.showNotification('End of playlist reached', 'info');
            return;
        }
        
        const song = this.playlist[this.playlistIndex];
        this.playSoundCloudSong(song.title, song.artist, song.url);
    }

    updatePlayButtons() {
        document.querySelectorAll('.play-button').forEach(btn => {
            btn.innerHTML = this.isPlaying ? '⏸️' : '▶️';
        });
    }

    updateSongsList() {
        const songsList = document.getElementById('songs-list');
        if (!songsList) return;
        
        songsList.innerHTML = this.playlist.map(song => `
            <div class="song-item bg-white/10 rounded-lg p-4 flex items-center justify-between hover:bg-white/20 transition-colors">
                <div class="flex items-center space-x-4">
                    <div class="text-orange-400 text-2xl">🎵</div>
                    <div>
                        <div class="text-white font-medium">${song.title}</div>
                        <div class="text-white/70 text-sm">${song.artist}</div>
                    </div>
                </div>
                <div class="flex gap-2">
                    <button onclick="playSoundCloudSong('${song.title}', '${song.artist}', '${song.url}')" 
                            class="bg-orange-500 text-white px-3 py-1 rounded text-sm hover:bg-orange-600 transition-colors">
                        ▶️ Play
                    </button>
                    <button onclick="removeSong(this)" class="text-white/60 hover:text-red-400 text-sm px-2">❌</button>
                </div>
            </div>
        `).join('');
    }

    // =================================================================
    // PLAYLIST FUNCTIONS
    // =================================================================

    createFromTemplate(templateType) {
        const templates = {
            'romantic': [
                { title: 'Perfect', artist: 'Ed Sheeran', mood: 'romantic' },
                { title: 'All of Me', artist: 'John Legend', mood: 'romantic' },
                { title: 'Thinking Out Loud', artist: 'Ed Sheeran', mood: 'romantic' }
            ],
            'dinner': [
                { title: 'Fly Me to the Moon', artist: 'Frank Sinatra', mood: 'jazz' },
                { title: 'The Way You Look Tonight', artist: 'Tony Bennett', mood: 'jazz' },
                { title: 'Unforgettable', artist: 'Nat King Cole', mood: 'jazz' }
            ],
            'roadtrip': [
                { title: 'Life is a Highway', artist: 'Tom Cochrane', mood: 'energetic' },
                { title: 'Born to Be Wild', artist: 'Steppenwolf', mood: 'energetic' },
                { title: 'Take It Easy', artist: 'Eagles', mood: 'chill' }
            ]
        };

        const template = templates[templateType];
        if (!template) {
            this.showNotification('Template not found', 'error');
            return;
        }

        const newPlaylist = {
            id: Date.now().toString(),
            name: `${templateType.charAt(0).toUpperCase() + templateType.slice(1)} Playlist`,
            songs: template,
            created: new Date().toISOString(),
            type: templateType
        };

        this.userPlaylists.push(newPlaylist);
        this.saveData('anniversary_playlists', this.userPlaylists);
        this.showNotification(`Created ${newPlaylist.name}!`, 'success');
        this.updatePlaylistsGrid();
    }

    generateActivityPlaylist(activity) {
        const activityPlaylists = {
            'gracies': {
                name: "Dinner at Gracie's",
                songs: [
                    { title: 'Autumn Leaves', artist: 'Miles Davis', mood: 'jazz' },
                    { title: 'Summertime', artist: 'Ella Fitzgerald', mood: 'jazz' },
                    { title: 'Blue Moon', artist: 'Billie Holiday', mood: 'jazz' }
                ]
            },
            'waterfront': {
                name: "Waterfront Cruise",
                songs: [
                    { title: 'Sailing', artist: 'Christopher Cross', mood: 'chill' },
                    { title: 'Come Monday', artist: 'Jimmy Buffett', mood: 'chill' },
                    { title: 'Banana Pancakes', artist: 'Jack Johnson', mood: 'chill' }
                ]
            },
            'museum': {
                name: "Museum Visit",
                songs: [
                    { title: 'Clair de Lune', artist: 'Claude Debussy', mood: 'classical' },
                    { title: 'Canon in D', artist: 'Pachelbel', mood: 'classical' },
                    { title: 'Ave Maria', artist: 'Franz Schubert', mood: 'classical' }
                ]
            },
            'arrival': {
                name: "Arrival Journey",
                songs: [
                    { title: 'Good as Hell', artist: 'Lizzo', mood: 'energetic' },
                    { title: 'Uptown Funk', artist: 'Bruno Mars', mood: 'energetic' },
                    { title: 'Can\'t Stop the Feeling!', artist: 'Justin Timberlake', mood: 'energetic' }
                ]
            }
        };

        const playlistData = activityPlaylists[activity];
        if (!playlistData) {
            this.showNotification('Activity playlist not found', 'error');
            return;
        }

        const newPlaylist = {
            id: Date.now().toString(),
            name: playlistData.name,
            songs: playlistData.songs,
            created: new Date().toISOString(),
            type: 'activity',
            activity: activity
        };

        this.userPlaylists.push(newPlaylist);
        this.saveData('anniversary_playlists', this.userPlaylists);
        this.showNotification(`Generated ${playlistData.name} playlist!`, 'success');
        this.updatePlaylistsGrid();
    }

    generateMoodPlaylist(mood) {
        const moodPlaylists = {
            'romantic': [
                { title: 'Perfect', artist: 'Ed Sheeran' },
                { title: 'All of Me', artist: 'John Legend' },
                { title: 'Thinking Out Loud', artist: 'Ed Sheeran' },
                { title: 'Make You Feel My Love', artist: 'Adele' }
            ],
            'adventurous': [
                { title: 'Adventure of a Lifetime', artist: 'Coldplay' },
                { title: 'Thunder', artist: 'Imagine Dragons' },
                { title: 'High Hopes', artist: 'Panic! At The Disco' },
                { title: 'Shut Up and Dance', artist: 'Walk the Moon' }
            ],
            'chill': [
                { title: 'Banana Pancakes', artist: 'Jack Johnson' },
                { title: 'Better Days', artist: 'OneRepublic' },
                { title: 'Riptide', artist: 'Vance Joy' },
                { title: 'Ho Hey', artist: 'The Lumineers' }
            ],
            'energetic': [
                { title: 'Uptown Funk', artist: 'Bruno Mars' },
                { title: 'Can\'t Stop the Feeling!', artist: 'Justin Timberlake' },
                { title: 'Good as Hell', artist: 'Lizzo' },
                { title: 'Levitating', artist: 'Dua Lipa' }
            ]
        };

        const songs = moodPlaylists[mood];
        if (!songs) {
            this.showNotification('Mood playlist not found', 'error');
            return;
        }

        const newPlaylist = {
            id: Date.now().toString(),
            name: `${mood.charAt(0).toUpperCase() + mood.slice(1)} Vibes`,
            songs: songs,
            created: new Date().toISOString(),
            type: 'mood',
            mood: mood
        };

        this.userPlaylists.push(newPlaylist);
        this.saveData('anniversary_playlists', this.userPlaylists);
        this.showNotification(`Generated ${newPlaylist.name} playlist!`, 'success');
        this.updatePlaylistsGrid();
    }

    exploreLocalArtists() {
        const localArtists = [
            { name: 'The Low Anthem', genre: 'Folk', from: 'Providence, RI' },
            { name: 'Deer Tick', genre: 'Alt-Country', from: 'Providence, RI' },
            { name: 'Brown Bird', genre: 'American Folk', from: 'Providence, RI' },
            { name: 'Roz Raskin', genre: 'Folk', from: 'Providence, RI' }
        ];

        const modal = this.createModal('Local Providence Artists', `
            <div class="space-y-4">
                ${localArtists.map(artist => `
                    <div class="bg-gray-50 p-4 rounded-lg">
                        <h4 class="font-semibold text-lg">${artist.name}</h4>
                        <p class="text-gray-600">${artist.genre} • ${artist.from}</p>
                    </div>
                `).join('')}
                <p class="text-sm text-gray-500 mt-4">
                    These artists represent the vibrant local music scene in Providence!
                </p>
            </div>
        `);
        
        document.body.appendChild(modal);
        this.showNotification('Discovering local Providence artists!', 'info');
    }

    generateVenuePlaylist() {
        const venuePlaylist = {
            id: Date.now().toString(),
            name: 'Providence Venue Mix',
            songs: [
                { title: 'Venue Song 1', artist: 'Local Band', venue: 'The Met' },
                { title: 'Venue Song 2', artist: 'Local Band', venue: 'Lupo\'s' },
                { title: 'Venue Song 3', artist: 'Local Band', venue: 'The Columbus Theatre' }
            ],
            created: new Date().toISOString(),
            type: 'venue'
        };

        this.userPlaylists.push(venuePlaylist);
        this.saveData('anniversary_playlists', this.userPlaylists);
        this.showNotification('Generated Providence venue playlist!', 'success');
        this.updatePlaylistsGrid();
    }

    getLocalRadioHits() {
        const radioHits = [
            { title: 'Current Hit 1', artist: 'Popular Artist', station: 'WBRU' },
            { title: 'Current Hit 2', artist: 'Popular Artist', station: '94HJY' },
            { title: 'Current Hit 3', artist: 'Popular Artist', station: 'KISS 95.1' }
        ];

        const radioPlaylist = {
            id: Date.now().toString(),
            name: 'Providence Radio Hits',
            songs: radioHits,
            created: new Date().toISOString(),
            type: 'radio'
        };

        this.userPlaylists.push(radioPlaylist);
        this.saveData('anniversary_playlists', this.userPlaylists);
        this.showNotification('Added current radio hits to your collection!', 'success');
        this.updatePlaylistsGrid();
    }

    shareToSocial(platform) {
        const currentPlaylist = this.userPlaylists[0]; // Get current playlist
        if (!currentPlaylist) {
            this.showNotification('No playlist to share', 'error');
            return;
        }

        const shareText = `Check out my "${currentPlaylist.name}" playlist from our Providence Anniversary! 🎵💕`;
        const shareUrl = window.location.href;

        const socialUrls = {
            'twitter': `https://twitter.com/intent/tweet?text=${encodeURIComponent(shareText)}&url=${encodeURIComponent(shareUrl)}`,
            'facebook': `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(shareUrl)}`,
            'instagram': `https://www.instagram.com/` // Instagram doesn't support direct sharing
        };

        if (platform === 'instagram') {
            this.showNotification('Screenshot this playlist to share on Instagram!', 'info');
            return;
        }

        const url = socialUrls[platform];
        if (url) {
            window.open(url, '_blank');
            this.showNotification(`Sharing to ${platform}!`, 'success');
        }
    }

    exportPlaylist(service) {
        const currentPlaylist = this.userPlaylists[0];
        if (!currentPlaylist) {
            this.showNotification('No playlist to export', 'error');
            return;
        }

        const exportUrls = {
            'spotify': 'https://open.spotify.com/',
            'youtube': 'https://music.youtube.com/',
            'apple': 'https://music.apple.com/'
        };

        const url = exportUrls[service];
        if (url) {
            window.open(url, '_blank');
            this.showNotification(`Opening ${service} to create your playlist!`, 'info');
        }
    }

    simulateCollaboration() {
        const activities = [
            'Partner added "Perfect" by Ed Sheeran',
            'You added "All of Me" by John Legend',
            'Partner removed "Song Title"',
            'You created new playlist "Dinner Music"',
            'Partner liked your playlist',
            'You commented on "Romantic Vibes"'
        ];

        const feedElement = document.getElementById('collaboration-feed');
        if (!feedElement) return;

        feedElement.innerHTML = '';
        
        activities.forEach((activity, index) => {
            setTimeout(() => {
                const activityItem = document.createElement('div');
                activityItem.className = 'text-sm text-white/80 py-2 border-b border-white/10';
                activityItem.innerHTML = `
                    <div class="flex items-center gap-2">
                        <span class="text-xs text-white/60">${new Date().toLocaleTimeString()}</span>
                        <span>${activity}</span>
                    </div>
                `;
                feedElement.appendChild(activityItem);
                feedElement.scrollTop = feedElement.scrollHeight;
            }, index * 1000);
        });

        this.showNotification('Collaboration demo started!', 'success');
    }

    openCreatePlaylistModal() {
        const modal = this.createModal('Create New Playlist', `
            <form id="create-playlist-form" class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Playlist Name</label>
                    <input type="text" id="playlist-name" class="w-full p-2 border rounded-lg" placeholder="My Awesome Playlist" required>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                    <textarea id="playlist-description" class="w-full p-2 border rounded-lg h-24" placeholder="Describe your playlist..."></textarea>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Mood</label>
                    <select id="playlist-mood" class="w-full p-2 border rounded-lg">
                        <option value="romantic">Romantic</option>
                        <option value="energetic">Energetic</option>
                        <option value="chill">Chill</option>
                        <option value="adventurous">Adventurous</option>
                    </select>
                </div>
                <div class="flex gap-2">
                    <button type="button" onclick="this.closest('.fixed').remove()" class="flex-1 bg-gray-300 text-gray-700 py-2 rounded-lg hover:bg-gray-400 transition-colors">
                        Cancel
                    </button>
                    <button type="submit" class="flex-1 bg-blue-500 text-white py-2 rounded-lg hover:bg-blue-600 transition-colors">
                        Create Playlist
                    </button>
                </div>
            </form>
        `);

        document.body.appendChild(modal);

        // Handle form submission
        document.getElementById('create-playlist-form').addEventListener('submit', (e) => {
            e.preventDefault();
            const name = document.getElementById('playlist-name').value;
            const description = document.getElementById('playlist-description').value;
            const mood = document.getElementById('playlist-mood').value;

            const newPlaylist = {
                id: Date.now().toString(),
                name: name,
                description: description,
                mood: mood,
                songs: [],
                created: new Date().toISOString(),
                type: 'custom'
            };

            this.userPlaylists.push(newPlaylist);
            this.saveData('anniversary_playlists', this.userPlaylists);
            this.showNotification(`Created "${name}" playlist!`, 'success');
            this.updatePlaylistsGrid();
            modal.remove();
        });
    }

    sharePlaylist(playlistId) {
        const playlist = this.userPlaylists.find(p => p.id === playlistId);
        if (!playlist) {
            this.showNotification('Playlist not found', 'error');
            return;
        }

        const shareUrl = `${window.location.href}#playlist=${playlistId}`;
        
        if (navigator.share) {
            navigator.share({
                title: playlist.name,
                text: `Check out my "${playlist.name}" playlist!`,
                url: shareUrl
            });
        } else {
            // Fallback to clipboard
            navigator.clipboard.writeText(shareUrl).then(() => {
                this.showNotification('Playlist link copied to clipboard!', 'success');
            });
        }
    }

    updatePlaylistsGrid() {
        const grid = document.getElementById('playlists-grid');
        if (!grid) return;

        // Keep existing playlists and add new ones
        const existingPlaylists = grid.querySelectorAll('.playlist-card');
        
        this.userPlaylists.forEach(playlist => {
            const playlistCard = document.createElement('div');
            playlistCard.className = 'playlist-card bg-white/10 backdrop-blur-sm rounded-xl overflow-hidden border border-white/20 hover:border-purple-400/50 transition-all duration-300';
            playlistCard.innerHTML = `
                <div class="playlist-cover bg-gradient-to-br from-purple-500 to-pink-500 h-48 flex items-center justify-center">
                    <div class="text-6xl">${this.getPlaylistEmoji(playlist.type)}</div>
                </div>
                <div class="p-4">
                    <h4 class="text-lg font-bold text-white mb-1">${playlist.name}</h4>
                    <p class="text-white/70 text-sm mb-2">${playlist.description || 'Custom playlist'}</p>
                    <div class="flex justify-between items-center text-xs text-white/60 mb-4">
                        <span>${playlist.songs.length} songs • ${Math.round(playlist.songs.length * 3.5)} min</span>
                        <span>🎵 ${playlist.type}</span>
                    </div>
                    <div class="flex gap-2">
                        <button onclick="playPlaylist('${playlist.id}')" class="flex-1 bg-purple-500 text-white py-2 rounded-lg text-sm hover:bg-purple-600 transition-colors">
                            ▶️ Play
                        </button>
                        <button onclick="sharePlaylist('${playlist.id}')" class="bg-white/10 text-white px-3 py-2 rounded-lg text-sm hover:bg-white/20 transition-colors">
                            🔗
                        </button>
                    </div>
                </div>
            `;
            grid.appendChild(playlistCard);
        });
    }

    getPlaylistEmoji(type) {
        const emojis = {
            'romantic': '💕',
            'energetic': '⚡',
            'chill': '🌿',
            'adventurous': '🚀',
            'activity': '🎯',
            'mood': '💭',
            'venue': '🎪',
            'radio': '📻',
            'custom': '🎵'
        };
        return emojis[type] || '🎵';
    }

    // =================================================================
    // CORE FUNCTIONALITY
    // =================================================================

    scrollToSection(sectionId) {
        const element = document.getElementById(sectionId);
        if (element) {
            element.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    }

    showLoveNote() {
        const loveNotes = [
            "💕 Every moment with you is a beautiful adventure!",
            "🌹 You make Providence even more magical!",
            "💫 Looking forward to our romantic getaway!",
            "❤️ You're my favorite person to explore with!",
            "🥰 Can't wait to make more memories together!",
            "💖 Providence + You = Perfect Weekend!"
        ];
        
        const randomNote = loveNotes[Math.floor(Math.random() * loveNotes.length)];
        
        const modal = this.createModal('Love Note', `
            <div class="text-center">
                <div class="text-4xl mb-4">💕</div>
                <p class="text-lg mb-4">${randomNote}</p>
                <button onclick="this.closest('.fixed').remove()" class="bg-pink-500 text-white px-6 py-2 rounded-lg hover:bg-pink-600 transition-colors">
                    Aww, thank you! 💫
                </button>
            </div>
        `);
        
        document.body.appendChild(modal);
        
        // Auto-close after 5 seconds
        setTimeout(() => {
            if (modal.parentElement) modal.remove();
        }, 5000);
    }

    generateBudgetPlan() {
        const totalEstimate = this.budgetData.meals + this.budgetData.drinks + this.budgetData.extras;
        const withTaxTip = totalEstimate * 1.25;
        
        const modal = this.createModal('Budget Plan', `
            <div class="space-y-4">
                <div class="bg-gray-50 p-4 rounded-lg">
                    <h4 class="font-semibold mb-2">Estimated Costs</h4>
                    <div class="space-y-2">
                        <div class="flex justify-between">
                            <span>Meals:</span>
                            <span class="font-semibold">$${this.budgetData.meals}</span>
                        </div>
                        <div class="flex justify-between">
                            <span>Drinks:</span>
                            <span class="font-semibold">$${this.budgetData.drinks}</span>
                        </div>
                        <div class="flex justify-between">
                            <span>Extras:</span>
                            <span class="font-semibold">$${this.budgetData.extras}</span>
                        </div>
                        <div class="border-t pt-2 flex justify-between font-bold">
                            <span>Total (with tax/tip):</span>
                            <span class="text-green-600">$${Math.round(withTaxTip)}</span>
                        </div>
                    </div>
                </div>
                <div class="text-center">
                    <button onclick="this.closest('.fixed').remove()" class="bg-blue-500 text-white px-6 py-2 rounded-lg hover:bg-blue-600 transition-colors">
                        Got it!
                    </button>
                </div>
            </div>
        `);
        
        document.body.appendChild(modal);
    }

    openModal(imageSrc, imageAlt) {
        const modal = document.createElement('div');
        modal.className = 'fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50';
        modal.innerHTML = `
            <div class="relative max-w-4xl max-h-full p-4">
                <img src="${imageSrc}" alt="${imageAlt}" class="max-w-full max-h-full object-contain rounded-lg">
                <button onclick="this.closest('.fixed').remove()" class="absolute top-2 right-2 text-white text-2xl bg-black bg-opacity-50 rounded-full w-8 h-8 flex items-center justify-center hover:bg-opacity-75 transition-opacity">
                    ×
                </button>
                <div class="text-white text-center mt-2 bg-black bg-opacity-50 rounded px-3 py-1">
                    ${imageAlt}
                </div>
            </div>
        `;
        document.body.appendChild(modal);
    }

    closeModal() {
        document.querySelectorAll('.fixed').forEach(modal => {
            if (modal.querySelector('img')) {
                modal.remove();
            }
        });
    }

    createModal(title, content) {
        const modal = document.createElement('div');
        modal.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
        modal.innerHTML = `
            <div class="bg-white rounded-xl p-6 max-w-md mx-4 max-h-96 overflow-y-auto">
                <h3 class="text-xl font-bold mb-4">${title}</h3>
                ${content}
            </div>
        `;
        return modal;
    }

    // =================================================================
    // ADDITIONAL FUNCTIONALITY
    // =================================================================

    setupEventListeners() {
        // Close modals on escape key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                document.querySelectorAll('.fixed').forEach(modal => modal.remove());
            }
        });

        // Close modals on background click
        document.addEventListener('click', (e) => {
            if (e.target.classList.contains('fixed')) {
                e.target.remove();
            }
        });
    }

    setupPhotoGallery() {
        // Enhanced photo gallery functionality
        document.querySelectorAll('.photo-gallery img').forEach(img => {
            img.addEventListener('click', () => {
                this.openModal(img.src, img.alt);
            });
        });
    }

    setupInteractiveMap() {
        // Initialize Leaflet map if container exists
        const mapContainer = document.getElementById('map');
        if (mapContainer && typeof L !== 'undefined') {
            this.map = L.map('map').setView([this.providenceCoords.lat, this.providenceCoords.lng], 13);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(this.map);
            
            // Add markers for key locations
            this.addLocationMarkers();
        }
    }

    addLocationMarkers() {
        const locations = [
            { name: "Gracie's Restaurant", lat: 41.8236, lng: -71.4118, type: 'restaurant' },
            { name: "Federal Hill", lat: 41.8186, lng: -71.4188, type: 'area' },
            { name: "Waterfront", lat: 41.8173, lng: -71.4012, type: 'scenic' },
            { name: "Downtown", lat: 41.8236, lng: -71.4128, type: 'area' }
        ];

        locations.forEach(location => {
            const marker = L.marker([location.lat, location.lng]).addTo(this.map);
            marker.bindPopup(`<b>${location.name}</b><br>Type: ${location.type}`);
        });
    }

    setupOfflineMode() {
        // Service worker registration for offline functionality
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.register('/sw.js').then((registration) => {
                console.log('SW registered: ', registration);
            }).catch((registrationError) => {
                console.log('SW registration failed: ', registrationError);
            });
        }
    }

    setupPWAInstallPrompt() {
        // PWA installation prompt
        let deferredPrompt;
        
        window.addEventListener('beforeinstallprompt', (e) => {
            e.preventDefault();
            deferredPrompt = e;
            
            // Show install button after delay
            setTimeout(() => {
                if (deferredPrompt) {
                    this.showInstallPrompt(deferredPrompt);
                }
            }, 5000);
        });
    }

    showInstallPrompt(deferredPrompt) {
        const installBanner = document.createElement('div');
        installBanner.className = 'fixed bottom-4 left-4 right-4 bg-blue-500 text-white p-4 rounded-xl shadow-lg z-50 flex items-center justify-between';
        installBanner.innerHTML = `
            <span>Install this app for the best experience!</span>
            <div class="flex gap-2">
                <button id="install-app" class="bg-white text-blue-500 px-3 py-1 rounded-lg text-sm font-semibold">Install</button>
                <button id="dismiss-install" class="text-white/80 hover:text-white px-2">✕</button>
            </div>
        `;
        
        document.body.appendChild(installBanner);

        document.getElementById('install-app').addEventListener('click', async () => {
            deferredPrompt.prompt();
            const { outcome } = await deferredPrompt.userChoice;
            deferredPrompt = null;
            installBanner.remove();
        });

        document.getElementById('dismiss-install').addEventListener('click', () => {
            installBanner.remove();
        });
    }

    restoreUserData() {
        // Restore any saved user preferences and data
        const savedTab = localStorage.getItem('anniversary_current_tab');
        if (savedTab) {
            const tabBtn = document.querySelector(`[data-tab="${savedTab}"]`);
            if (tabBtn) tabBtn.click();
        }
    }

    // =================================================================
    // ITINERARY MANAGEMENT
    // =================================================================

    toggleEditMode() {
        this.isEditMode = !this.isEditMode;
        this.showNotification(this.isEditMode ? 'Edit mode enabled' : 'Edit mode disabled', 'info');
    }

    addItineraryItem() {
        this.showNotification('Add itinerary item functionality - open modal here', 'info');
    }

    saveItinerary() {
        this.saveData('anniversary_itinerary', this.itineraryData);
        this.showNotification('Itinerary saved successfully!', 'success');
    }

    resetItinerary() {
        this.itineraryData = this.getDefaultItinerary();
        this.saveData('anniversary_itinerary', this.itineraryData);
        this.showNotification('Itinerary reset to default', 'info');
    }

    getDefaultItinerary() {
        return {
            day1: [
                { time: '2:00 PM', activity: 'Arrive in Providence', icon: '✈️' },
                { time: '3:00 PM', activity: 'Check into hotel', icon: '🏨' },
                { time: '6:00 PM', activity: 'Dinner at Gracie\'s', icon: '🍽️' }
            ],
            day2: [
                { time: '9:00 AM', activity: 'Breakfast at hotel', icon: '☕' },
                { time: '10:30 AM', activity: 'Explore Federal Hill', icon: '🏛️' },
                { time: '1:00 PM', activity: 'Lunch at Italian restaurant', icon: '🍝' }
            ]
        };
    }

    // =================================================================
    // PHOTO & MEDIA MANAGEMENT
    // =================================================================

    showPhotoUploadModal() {
        const modal = this.createModal('Upload Photo', `
            <form id="photo-upload-form" class="space-y-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Select Photo</label>
                    <input type="file" id="photo-input" accept="image/*" class="w-full p-2 border rounded-lg" required>
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Caption</label>
                    <input type="text" id="photo-caption" class="w-full p-2 border rounded-lg" placeholder="A beautiful moment...">
                </div>
                <div class="flex gap-2">
                    <button type="button" onclick="this.closest('.fixed').remove()" class="flex-1 bg-gray-300 text-gray-700 py-2 rounded-lg hover:bg-gray-400 transition-colors">
                        Cancel
                    </button>
                    <button type="submit" class="flex-1 bg-blue-500 text-white py-2 rounded-lg hover:bg-blue-600 transition-colors">
                        Upload
                    </button>
                </div>
            </form>
        `);

        document.body.appendChild(modal);

        document.getElementById('photo-upload-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.handlePhotoUpload();
            modal.remove();
        });
    }

    handlePhotoUpload() {
        const fileInput = document.getElementById('photo-input');
        const caption = document.getElementById('photo-caption').value;
        
        if (fileInput.files.length > 0) {
            const file = fileInput.files[0];
            const reader = new FileReader();
            
            reader.onload = (e) => {
                const photoData = {
                    src: e.target.result,
                    caption: caption,
                    timestamp: new Date().toISOString()
                };
                
                // Save to localStorage
                let photos = this.loadData('anniversary_photos', []);
                photos.push(photoData);
                this.saveData('anniversary_photos', photos);
                
                this.showNotification('Photo uploaded successfully!', 'success');
            };
            
            reader.readAsDataURL(file);
        }
    }

    // =================================================================
    // PI SERVER INTEGRATION
    // =================================================================

    async syncWithPiServer() {
        try {
            this.showNotification('Syncing with Pi server...', 'info');
            
            // Simulate API call to Pi server
            const response = await fetch('http://192.168.68.69:8080/api/sync', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                },
                body: JSON.stringify({
                    itinerary: this.itineraryData,
                    notes: this.notesData,
                    photos: this.loadData('anniversary_photos', []),
                    playlists: this.userPlaylists
                })
            });
            
            if (response.ok) {
                this.showNotification('Synced successfully with Pi server!', 'success');
            } else {
                throw new Error('Sync failed');
            }
        } catch (error) {
            console.error('Sync error:', error);
            this.showNotification('Pi server sync failed (server may be offline)', 'error');
        }
    }

    // =================================================================
    // UTILITY FUNCTIONS
    // =================================================================

    focusMapLocation(locationId) {
        if (!this.map) return;
        
        const locations = {
            'gracies': [41.8236, -71.4118],
            'federal-hill': [41.8186, -71.4188],
            'waterfront': [41.8173, -71.4012],
            'downtown': [41.8236, -71.4128]
        };
        
        const coords = locations[locationId];
        if (coords) {
            this.map.setView(coords, 16);
            this.showNotification(`Focused on ${locationId}`, 'info');
        }
    }

    startAddingCustomPoint() {
        if (!this.map) return;
        
        this.showNotification('Click on the map to add a custom point', 'info');
        this.map.on('click', (e) => {
            const { lat, lng } = e.latlng;
            const name = prompt('Enter a name for this location:');
            if (name) {
                this.addCustomPoint(lat, lng, name);
            }
        });
    }

    addCustomPoint(lat, lng, name) {
        const customPoint = { lat, lng, name, id: Date.now().toString() };
        this.customMapPoints.push(customPoint);
        this.saveData('anniversary_custom_points', this.customMapPoints);
        
        // Add marker to map
        const marker = L.marker([lat, lng]).addTo(this.map);
        marker.bindPopup(`<b>${name}</b><br>Custom point`);
        
        this.showNotification(`Added custom point: ${name}`, 'success');
    }

    viewCustomPoints() {
        if (this.customMapPoints.length === 0) {
            this.showNotification('No custom points added yet', 'info');
            return;
        }
        
        const pointsList = this.customMapPoints.map(point => `
            <div class="flex justify-between items-center p-2 bg-gray-50 rounded">
                <span>${point.name}</span>
                <button onclick="removeCustomPoint('${point.id}')" class="text-red-500 text-sm">Remove</button>
            </div>
        `).join('');
        
        const modal = this.createModal('Custom Points', `
            <div class="space-y-2">
                ${pointsList}
            </div>
        `);
        
        document.body.appendChild(modal);
    }

    clearCustomPoints() {
        this.customMapPoints = [];
        this.saveData('anniversary_custom_points', []);
        this.showNotification('All custom points cleared', 'info');
    }

    showMusicServicesModal() {
        const modal = this.createModal('Music Services', `
            <div class="space-y-4">
                <p class="text-gray-600">Connect your music services to sync playlists:</p>
                <div class="space-y-2">
                    <button class="w-full bg-green-500 text-white py-2 rounded-lg hover:bg-green-600 transition-colors">
                        🎵 Connect Spotify
                    </button>
                    <button class="w-full bg-red-500 text-white py-2 rounded-lg hover:bg-red-600 transition-colors">
                        📺 Connect YouTube Music
                    </button>
                    <button class="w-full bg-gray-700 text-white py-2 rounded-lg hover:bg-gray-800 transition-colors">
                        🍎 Connect Apple Music
                    </button>
                </div>
                <p class="text-sm text-gray-500">Music integration coming soon!</p>
            </div>
        `);
        
        document.body.appendChild(modal);
    }

    toggleMusic(trackId) {
        if (this.isPlaying) {
            this.stopAll();
        } else {
            this.showNotification(`Playing track ${trackId}`, 'info');
            this.isPlaying = true;
            this.updatePlayButtons();
        }
    }
}

// Initialize the app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    window.providenceApp = new ProvidenceAnniversaryApp();
});

// Global utility functions
window.closeModal = () => {
    document.querySelectorAll('.fixed').forEach(modal => {
        if (modal.querySelector('img') || modal.querySelector('h3')) {
            modal.remove();
        }
    });
};

// Handle image modal closing
document.addEventListener('click', (e) => {
    if (e.target.classList.contains('fixed') && e.target.style.backgroundColor.includes('black')) {
        e.target.remove();
    }
});

// Close modals with Escape key
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        document.querySelectorAll('.fixed').forEach(modal => modal.remove());
    }
});
