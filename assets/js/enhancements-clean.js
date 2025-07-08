// Providence Anniversary Website - Simplified Features
// Interactive Map, Photo Gallery, PWA Support

class AnniversaryEnhancements {
    constructor() {
        this.providenceCoords = { lat: 41.8240, lng: -71.4128 };
        this.initializeEnhancements();
    }

    async initializeEnhancements() {
        this.setupPhotoGallery();
        this.setupInteractiveMap();
        this.setupOfflineMode();
        this.setupPWAInstallPrompt();
        this.setupSpotifyPrep();
    }

    // 1. Enhanced Photo Gallery
    setupPhotoGallery() {
        const galleries = document.querySelectorAll('.photo-gallery img');
        
        galleries.forEach(img => {
            img.addEventListener('click', () => {
                this.openImageModal(img.src, img.alt);
            });
        });
    }

    openImageModal(src, alt) {
        const modal = document.getElementById('imageModal');
        const modalImg = document.getElementById('modalImage');
        const caption = document.getElementById('modalCaption');
        
        if (modal && modalImg) {
            modal.style.display = 'block';
            modalImg.src = src;
            modalImg.alt = alt;
            if (caption) caption.textContent = alt;
        }
    }

    // 2. Interactive Map (Keep Leaflet - you like it!)
    setupInteractiveMap() {
        if (typeof L === 'undefined') return;
        
        const mapContainer = document.getElementById('providence-map');
        if (!mapContainer) return;

        const map = L.map('providence-map').setView([this.providenceCoords.lat, this.providenceCoords.lng], 13);
        
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors'
        }).addTo(map);

        // Add restaurant markers
        this.addRestaurantMarkers(map);
    }

    addRestaurantMarkers(map) {
        const restaurants = [
            { name: "Gracie's", lat: 41.8240, lng: -71.4128, type: "Fine Dining" },
            { name: "Mill's Tavern", lat: 41.8236, lng: -71.4135, type: "American" },
            { name: "Bacaro", lat: 41.8220, lng: -71.4150, type: "Italian" },
            { name: "Hemenway's", lat: 41.8250, lng: -71.4100, type: "Seafood" }
        ];

        restaurants.forEach(restaurant => {
            const marker = L.marker([restaurant.lat, restaurant.lng]).addTo(map);
            marker.bindPopup(`
                <div class="restaurant-popup">
                    <h3>${restaurant.name}</h3>
                    <p>${restaurant.type}</p>
                </div>
            `);
        });
    }

    // 3. PWA Offline Mode
    setupOfflineMode() {
        if ('serviceWorker' in navigator) {
            navigator.serviceWorker.register('/sw.js')
                .then(registration => {
                    console.log('SW registered:', registration);
                })
                .catch(error => {
                    console.log('SW registration failed:', error);
                });
        }
    }

    // 4. PWA Install Prompt (Only show if not installed)
    setupPWAInstallPrompt() {
        let deferredPrompt;
        
        window.addEventListener('beforeinstallprompt', (e) => {
            e.preventDefault();
            deferredPrompt = e;
            this.showInstallBanner(deferredPrompt);
        });
    }

    showInstallBanner(deferredPrompt) {
        const existingBanner = document.getElementById('pwa-install-banner');
        if (existingBanner) return; // Don't show multiple banners

        const installBanner = document.createElement('div');
        installBanner.id = 'pwa-install-banner';
        installBanner.className = 'fixed bottom-4 left-4 right-4 bg-[#8B7355] text-white p-4 rounded-xl shadow-lg z-50 flex items-center justify-between max-w-md mx-auto';
        
        installBanner.innerHTML = `
            <div class="flex items-center">
                <span class="text-2xl mr-3">💕</span>
                <div>
                    <div class="font-semibold">Install Anniversary App</div>
                    <div class="text-sm opacity-90">Add to home screen for offline access</div>
                </div>
            </div>
            <div class="flex gap-2">
                <button id="install-app" class="bg-white text-[#8B7355] px-3 py-1 rounded-lg text-sm font-semibold">Install</button>
                <button id="dismiss-install" class="text-white/80 hover:text-white px-2">✕</button>
            </div>
        `;
        
        document.body.appendChild(installBanner);

        // Install button
        document.getElementById('install-app').addEventListener('click', async () => {
            if (deferredPrompt) {
                deferredPrompt.prompt();
                const { outcome } = await deferredPrompt.userChoice;
                console.log('Install prompt result:', outcome);
                deferredPrompt = null;
                installBanner.remove();
            }
        });

        // Dismiss button
        document.getElementById('dismiss-install').addEventListener('click', () => {
            installBanner.remove();
        });

        // Auto-dismiss after 10 seconds
        setTimeout(() => {
            if (installBanner.parentNode) {
                installBanner.remove();
            }
        }, 10000);
    }

    // 5. Spotify Integration Preparation
    setupSpotifyPrep() {
        // Prepare containers for future Spotify integration
        const musicContainers = document.querySelectorAll('.music-section, .song-memory-card');
        
        musicContainers.forEach(container => {
            container.setAttribute('data-spotify-ready', 'true');
        });

        // Add placeholder for Spotify player
        this.addSpotifyPlaceholder();
    }

    addSpotifyPlaceholder() {
        const musicSection = document.querySelector('#our-songs');
        if (!musicSection) return;

        const spotifyPlaceholder = document.createElement('div');
        spotifyPlaceholder.id = 'spotify-integration-ready';
        spotifyPlaceholder.className = 'hidden'; // Hidden until Spotify API is integrated
        spotifyPlaceholder.innerHTML = `
            <div class="bg-[#1DB954] text-white p-4 rounded-xl text-center">
                <h3 class="font-bold mb-2">🎵 Spotify Integration Ready</h3>
                <p class="text-sm opacity-90">This section is prepared for Spotify API integration</p>
            </div>
        `;
        
        musicSection.appendChild(spotifyPlaceholder);
    }
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new AnniversaryEnhancements();
});

// Handle image modal closing
document.addEventListener('click', (e) => {
    const modal = document.getElementById('imageModal');
    if (e.target === modal) {
        modal.style.display = 'none';
    }
});

// Close modal with Escape key
document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') {
        const modal = document.getElementById('imageModal');
        if (modal && modal.style.display === 'block') {
            modal.style.display = 'none';
        }
    }
});
