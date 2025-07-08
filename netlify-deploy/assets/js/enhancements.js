// Providence Anniversary Website - Enhanced Features
// Interactive Map, Photo Gallery, PWA Support, All Button Functions with Real Logic

class AnniversaryEnhancements {
    constructor() {
        this.providenceCoords = { lat: 41.8240, lng: -71.4128 };
        this.map = null;
        this.isEditMode = false;
        this.itineraryData = this.loadItinerary();
        this.notesData = this.loadNotes();
        this.customMapPoints = this.loadCustomPoints();
        this.budgetData = this.loadBudgetData();
        
        this.initializeEnhancements();
    }

    async initializeEnhancements() {
        this.setupPhotoGallery();
        this.setupInteractiveMap();
        this.setupOfflineMode();
        this.setupPWAInstallPrompt();
        this.setupSpotifyPrep();
        this.setupButtonFunctions();
        this.setupItineraryManagement();
        this.setupBudgetCalculator();
        this.setupNotesSystem();
        this.setupFilteringSystems();
        this.setupTabSwitching();
        this.restoreUserData();
    }

    // Setup all button functions
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
        
        // New enhanced functions
        window.toggleEditMode = this.toggleEditMode.bind(this);
        window.addItineraryItem = this.addItineraryItem.bind(this);
        window.saveItinerary = this.saveItinerary.bind(this);
        window.resetItinerary = this.resetItinerary.bind(this);
        window.updateBudgetCalculation = this.updateBudgetCalculation.bind(this);
        window.saveNotes = this.saveNotes.bind(this);
        window.addQuickNote = this.addQuickNote.bind(this);
        window.shareItinerary = this.shareItinerary.bind(this);
        window.addToCalendar = this.addToCalendar.bind(this);
        window.focusCustomPoint = this.focusCustomPoint.bind(this);
        window.removeCustomPoint = this.removeCustomPoint.bind(this);
    }

    // Smooth scroll to section
    scrollToSection(sectionId) {
        const element = document.getElementById(sectionId);
        if (element) {
            element.scrollIntoView({ 
                behavior: 'smooth',
                block: 'start'
            });
        }
    }

    // Show love note
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
        
        const loveNote = document.createElement('div');
        loveNote.className = 'fixed top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 bg-white rounded-xl shadow-2xl p-6 z-50 max-w-sm text-center border border-[#8B7355]';
        loveNote.innerHTML = `
            <div class="text-4xl mb-3">💕</div>
            <p class="text-lg text-[#8B7355] mb-4 font-medium">${randomNote}</p>
            <button onclick="this.parentElement.remove()" class="bg-[#8B7355] text-white px-6 py-2 rounded-lg hover:bg-[#A0926B] transition-colors">
                Aww, thank you! 💫
            </button>
        `;
        document.body.appendChild(loveNote);
        
        setTimeout(() => {
            if (loveNote.parentElement) {
                loveNote.remove();
            }
        }, 5000);
    }

    // Generate budget plan with real data and calculations
    generateBudgetPlan() {
        const currentBudget = this.budgetData;
        const totalEstimate = currentBudget.meals + currentBudget.drinks + currentBudget.extras + 
                            (currentBudget.meals + currentBudget.drinks + currentBudget.extras) * 0.25; // 25% tax+tip
        
        const restaurants = [
            { name: "Gracie's", price: 85, type: "Fine Dining", romantic: 5 },
            { name: "Mill's Tavern", price: 65, type: "American", romantic: 4 },
            { name: "Bacaro", price: 55, type: "Italian", romantic: 4 },
            { name: "Hemenway's", price: 70, type: "Seafood", romantic: 4 }
        ];
        
        // Generate personalized recommendations based on budget
        let recommendations = [];
        if (totalEstimate < 150) {
            recommendations = restaurants.filter(r => r.price <= 60).slice(0, 2);
        } else if (totalEstimate < 250) {
            recommendations = restaurants.filter(r => r.price <= 70).slice(0, 3);
        } else {
            recommendations = restaurants.slice(0, 4);
        }
        
        const budgetModal = document.createElement('div');
        budgetModal.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
        budgetModal.innerHTML = `
            <div class="bg-white rounded-xl p-6 max-w-lg mx-4 max-h-96 overflow-y-auto">
                <h3 class="text-xl font-bold text-[#8B7355] mb-4">💰 Personalized Budget Plan</h3>
                
                <div class="space-y-3 mb-4">
                    <div class="flex justify-between">
                        <span>Estimated Meals:</span>
                        <span class="font-semibold">$${currentBudget.meals}</span>
                    </div>
                    <div class="flex justify-between">
                        <span>Drinks & Cocktails:</span>
                        <span class="font-semibold">$${currentBudget.drinks}</span>
                    </div>
                    <div class="flex justify-between">
                        <span>Activities & Extras:</span>
                        <span class="font-semibold">$${currentBudget.extras}</span>
                    </div>
                    <div class="border-t pt-2 flex justify-between font-bold">
                        <span>Total Estimate:</span>
                        <span class="text-[#8B7355]">$${Math.round(totalEstimate)}</span>
                    </div>
                </div>
                
                <div class="mb-4">
                    <h4 class="font-semibold mb-2">🍽️ Recommended Restaurants:</h4>
                    <div class="space-y-2">
                        ${recommendations.map(r => `
                            <div class="flex justify-between items-center p-2 bg-gray-50 rounded">
                                <div>
                                    <span class="font-medium">${r.name}</span>
                                    <span class="text-sm text-gray-600"> - ${r.type}</span>
                                </div>
                                <div class="text-right">
                                    <div class="font-semibold">$${r.price}</div>
                                    <div class="text-xs">${'★'.repeat(r.romantic)} Romance</div>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                </div>
                
                <div class="flex gap-2">
                    <button onclick="this.closest('.fixed').remove()" class="flex-1 bg-gray-200 text-gray-800 py-2 rounded-lg hover:bg-gray-300 transition-colors">
                        Close
                    </button>
                    <button onclick="window.addToCalendar('budget-review')" class="flex-1 bg-[#8B7355] text-white py-2 rounded-lg hover:bg-[#A0926B] transition-colors">
                        Add to Calendar �
                    </button>
                </div>
            </div>
        `;
        document.body.appendChild(budgetModal);
        
        // Save the generated plan
        this.budgetData.lastPlan = {
            total: Math.round(totalEstimate),
            recommendations: recommendations,
            generated: new Date().toISOString()
        };
        this.saveBudgetData();
    }

    // Focus map location
    focusMapLocation(locationId) {
        if (!this.map) {
            console.log('Map not initialized yet');
            return;
        }

        const locations = {
            'gracies': { lat: 41.8240, lng: -71.4128, name: "Gracie's Restaurant" },
            'mills-tavern': { lat: 41.8236, lng: -71.4135, name: "Mill's Tavern" },
            'riverwalk': { lat: 41.8220, lng: -71.4100, name: "Providence Riverwalk" },
            'federal-hill': { lat: 41.8180, lng: -71.4200, name: "Federal Hill" },
            'benefit-street': { lat: 41.8270, lng: -71.4080, name: "Benefit Street" },
            'waterfire': { lat: 41.8200, lng: -71.4120, name: "WaterFire Location" },
            'downtown': { lat: 41.8240, lng: -71.4128, name: "Downtown Providence" },
            'east-side': { lat: 41.8300, lng: -71.4000, name: "East Side" },
            'hill': { lat: 41.8180, lng: -71.4200, name: "The Hill" },
            'waterfront': { lat: 41.8200, lng: -71.4100, name: "Waterfront" }
        };

        const location = locations[locationId];
        if (location) {
            this.map.setView([location.lat, location.lng], 16);
            
            // Add a temporary highlight marker
            const marker = L.marker([location.lat, location.lng])
                .addTo(this.map)
                .bindPopup(`<strong>${location.name}</strong>`)
                .openPopup();
            
            // Remove marker after 5 seconds
            setTimeout(() => {
                this.map.removeLayer(marker);
            }, 5000);
        }
    }

    // Custom map point functions with persistence
    startAddingCustomPoint() {
        if (!this.map) {
            alert('Map not available. Please try again in a moment.');
            return;
        }
        
        const notification = document.createElement('div');
        notification.className = 'fixed top-4 left-1/2 transform -translate-x-1/2 bg-[#8B7355] text-white px-6 py-3 rounded-lg shadow-lg z-50';
        notification.innerHTML = '📍 Click anywhere on the map to add a custom point!';
        document.body.appendChild(notification);
        
        this.map.once('click', (e) => {
            notification.remove();
            
            const pointName = prompt('Name this location:', 'My Special Place');
            if (!pointName) return;
            
            const customPoint = L.marker([e.latlng.lat, e.latlng.lng])
                .addTo(this.map)
                .bindPopup(`
                    <div class="text-center">
                        <strong>${pointName}</strong><br>
                        <small>Custom point</small><br>
                        <button onclick="window.removeCustomPoint(${e.latlng.lat}, ${e.latlng.lng})" 
                                class="mt-2 bg-red-500 text-white px-2 py-1 rounded text-xs">
                            Remove
                        </button>
                    </div>
                `)
                .openPopup();
            
            // Store custom points with persistence
            if (!this.customMapPoints) this.customMapPoints = [];
            this.customMapPoints.push({
                lat: e.latlng.lat,
                lng: e.latlng.lng,
                name: pointName,
                id: Date.now()
            });
            
            this.saveCustomPoints();
            
            // Show success message
            this.showSuccessMessage(`Added "${pointName}" to your map! 📍`);
        });
    }

    viewCustomPoints() {
        if (!this.customMapPoints || this.customMapPoints.length === 0) {
            alert('No custom points added yet. Click "Add Custom Point" to mark special places!');
            return;
        }
        
        const pointsList = this.customMapPoints.map((point, index) => 
            `<div class="flex justify-between items-center p-2 bg-gray-50 rounded mb-2">
                <span class="font-medium">${point.name}</span>
                <div class="flex gap-2">
                    <button onclick="window.focusCustomPoint(${point.lat}, ${point.lng})" 
                            class="bg-blue-500 text-white px-2 py-1 rounded text-xs">
                        View
                    </button>
                    <button onclick="window.removeCustomPoint(${point.lat}, ${point.lng})" 
                            class="bg-red-500 text-white px-2 py-1 rounded text-xs">
                        Remove
                    </button>
                </div>
            </div>`
        ).join('');
        
        const modal = document.createElement('div');
        modal.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
        modal.innerHTML = `
            <div class="bg-white rounded-xl p-6 max-w-md mx-4 max-h-96 overflow-y-auto">
                <h3 class="text-xl font-bold text-[#8B7355] mb-4">📍 Your Custom Points (${this.customMapPoints.length})</h3>
                <div class="space-y-2 mb-4">
                    ${pointsList}
                </div>
                <button onclick="this.closest('.fixed').remove()" 
                        class="w-full bg-[#8B7355] text-white py-2 rounded-lg hover:bg-[#A0926B] transition-colors">
                    Close
                </button>
            </div>
        `;
        document.body.appendChild(modal);
    }

    clearCustomPoints() {
        if (!this.customMapPoints || this.customMapPoints.length === 0) {
            alert('No custom points to clear.');
            return;
        }
        
        if (confirm(`Are you sure you want to remove all ${this.customMapPoints.length} custom points? This cannot be undone.`)) {
            // Remove all markers from map
            this.customMapPoints.forEach(point => {
                this.map.eachLayer(layer => {
                    if (layer instanceof L.Marker && 
                        layer.getLatLng().lat === point.lat && 
                        layer.getLatLng().lng === point.lng) {
                        this.map.removeLayer(layer);
                    }
                });
            });
            
            this.customMapPoints = [];
            this.saveCustomPoints();
            this.showSuccessMessage('All custom points cleared! 🗑️');
        }
    }

    // Music services modal
    showMusicServicesModal() {
        const modal = document.createElement('div');
        modal.className = 'fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50';
        modal.innerHTML = `
            <div class="bg-white rounded-xl p-6 max-w-md mx-4">
                <h3 class="text-xl font-bold text-[#8B7355] mb-4">🎵 Music Services</h3>
                <p class="text-gray-600 mb-4">Music integration coming soon! We'll support:</p>
                <div class="space-y-2 mb-4">
                    <div class="flex items-center space-x-3">
                        <div class="w-3 h-3 bg-green-400 rounded-full"></div>
                        <span>Spotify</span>
                    </div>
                    <div class="flex items-center space-x-3">
                        <div class="w-3 h-3 bg-red-400 rounded-full"></div>
                        <span>Apple Music (planned)</span>
                    </div>
                    <div class="flex items-center space-x-3">
                        <div class="w-3 h-3 bg-red-400 rounded-full"></div>
                        <span>YouTube Music (planned)</span>
                    </div>
                </div>
                <button onclick="this.closest('.fixed').remove()" class="w-full bg-[#8B7355] text-white py-2 rounded-lg hover:bg-[#A0926B] transition-colors">
                    Close
                </button>
            </div>
        `;
        document.body.appendChild(modal);
    }

    // Toggle music
    toggleMusic(trackId) {
        const button = document.getElementById(`music-play-btn-${trackId}`);
        if (!button) return;
        
        const isPlaying = button.classList.contains('playing');
        
        if (isPlaying) {
            button.innerHTML = '▶️';
            button.classList.remove('playing');
            console.log(`Stopped music track ${trackId}`);
        } else {
            button.innerHTML = '⏸️';
            button.classList.add('playing');
            console.log(`Playing music track ${trackId}`);
            
            // Stop other playing tracks
            document.querySelectorAll('.play-button.playing').forEach(btn => {
                if (btn.id !== `music-play-btn-${trackId}`) {
                    btn.innerHTML = '▶️';
                    btn.classList.remove('playing');
                }
            });
        }
    }

    // Open image modal
    openModal(imageSrc, imageAlt) {
        const modal = document.createElement('div');
        modal.id = 'imageModal';
        modal.className = 'fixed inset-0 bg-black bg-opacity-75 flex items-center justify-center z-50';
        modal.innerHTML = `
            <div class="relative max-w-4xl max-h-full p-4">
                <img id="modalImage" src="${imageSrc}" alt="${imageAlt}" class="max-w-full max-h-full object-contain rounded-lg">
                <button onclick="this.closest('.fixed').remove()" class="absolute top-2 right-2 text-white text-2xl bg-black bg-opacity-50 rounded-full w-8 h-8 flex items-center justify-center hover:bg-opacity-75 transition-opacity">
                    ×
                </button>
                <div class="text-white text-center mt-2 bg-black bg-opacity-50 rounded px-3 py-1">
                    ${imageAlt}
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        // Close on background click
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.remove();
            }
        });
        
        // Close on Escape key
        const handleEscape = (e) => {
            if (e.key === 'Escape') {
                modal.remove();
                document.removeEventListener('keydown', handleEscape);
            }
        };
        document.addEventListener('keydown', handleEscape);
    }

    // 1. Enhanced Photo Gallery
    setupPhotoGallery() {
        const galleries = document.querySelectorAll('.photo-gallery img');
        
        galleries.forEach(img => {
            img.addEventListener('click', () => {
                this.openModal(img.src, img.alt);
            });
        });
    }

    // 2. Interactive Map (Keep Leaflet - you like it!)
    setupInteractiveMap() {
        if (typeof L === 'undefined') return;
        
        const mapContainer = document.getElementById('providence-map');
        if (!mapContainer) return;

        this.map = L.map('providence-map').setView([this.providenceCoords.lat, this.providenceCoords.lng], 13);
        
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '© OpenStreetMap contributors'
        }).addTo(this.map);

        // Add restaurant markers
        this.addRestaurantMarkers(this.map);
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

    // ===== NEW ENHANCED FUNCTIONALITY =====

    // Data persistence methods
    loadItinerary() {
        try {
            return JSON.parse(localStorage.getItem('anniversary_itinerary')) || {
                day1: [], day2: [], day3: [], day4: [],
                customItems: [], lastModified: null
            };
        } catch (e) {
            return { day1: [], day2: [], day3: [], day4: [], customItems: [], lastModified: null };
        }
    }

    saveItinerary() {
        this.itineraryData.lastModified = new Date().toISOString();
        localStorage.setItem('anniversary_itinerary', JSON.stringify(this.itineraryData));
        this.showSuccessMessage('Itinerary saved successfully! 💾');
    }

    loadNotes() {
        try {
            return JSON.parse(localStorage.getItem('anniversary_notes')) || {
                day1: '', day2: '', day3: '', day4: '',
                memories: [], lastModified: null
            };
        } catch (e) {
            return { day1: '', day2: '', day3: '', day4: '', memories: [], lastModified: null };
        }
    }

    saveNotes(dayId, content) {
        if (dayId && content !== undefined) {
            this.notesData[dayId] = content;
        }
        this.notesData.lastModified = new Date().toISOString();
        localStorage.setItem('anniversary_notes', JSON.stringify(this.notesData));
        this.showSuccessMessage('Notes saved! 📝');
    }

    loadCustomPoints() {
        try {
            return JSON.parse(localStorage.getItem('anniversary_custom_points')) || [];
        } catch (e) {
            return [];
        }
    }

    saveCustomPoints() {
        localStorage.setItem('anniversary_custom_points', JSON.stringify(this.customMapPoints));
    }

    loadBudgetData() {
        try {
            return JSON.parse(localStorage.getItem('anniversary_budget')) || {
                meals: 120, drinks: 80, extras: 50, lastPlan: null
            };
        } catch (e) {
            return { meals: 120, drinks: 80, extras: 50, lastPlan: null };
        }
    }

    saveBudgetData() {
        localStorage.setItem('anniversary_budget', JSON.stringify(this.budgetData));
    }

    // Itinerary Management System
    setupItineraryManagement() {
        // Toggle edit mode
        const editToggle = document.getElementById('toggle-edit-mode');
        if (editToggle) {
            editToggle.addEventListener('click', () => this.toggleEditMode());
        }

        // Add item button
        const addItemBtn = document.getElementById('add-item-btn');
        if (addItemBtn) {
            addItemBtn.addEventListener('click', () => this.addItineraryItem());
        }

        // Save itinerary button
        const saveBtn = document.getElementById('save-itinerary');
        if (saveBtn) {
            saveBtn.addEventListener('click', () => this.saveItinerary());
        }

        // Reset itinerary button
        const resetBtn = document.getElementById('reset-itinerary');
        if (resetBtn) {
            resetBtn.addEventListener('click', () => this.resetItinerary());
        }
    }

    toggleEditMode() {
        this.isEditMode = !this.isEditMode;
        const toggleBtn = document.getElementById('toggle-edit-mode');
        const addBtn = document.getElementById('add-item-btn');
        
        if (this.isEditMode) {
            toggleBtn.textContent = '✅ Exit Edit Mode';
            toggleBtn.classList.add('bg-green-600', 'text-white');
            addBtn.style.display = 'block';
            this.showSuccessMessage('Edit mode enabled! You can now modify your itinerary. ✏️');
        } else {
            toggleBtn.textContent = '✏️ Edit Itinerary';
            toggleBtn.classList.remove('bg-green-600', 'text-white');
            addBtn.style.display = 'none';
            this.showSuccessMessage('Edit mode disabled. Your changes are preserved. 🔒');
        }
        
        // Enable/disable editing on itinerary items
        document.querySelectorAll('.itinerary-item').forEach(item => {
            if (this.isEditMode) {
                item.classList.add('editable');
                item.contentEditable = true;
            } else {
                item.classList.remove('editable');
                item.contentEditable = false;
            }
        });
    }

    addItineraryItem() {
        const currentTab = document.querySelector('.tab-btn.active-tab')?.dataset.tab || 'day1';
        const itemText = prompt('Add a new item to your itinerary:', 'Visit a special place');
        
        if (itemText && itemText.trim()) {
            const newItem = {
                id: Date.now(),
                text: itemText.trim(),
                time: new Date().toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'}),
                completed: false
            };
            
            this.itineraryData[currentTab].push(newItem);
            this.refreshItineraryDisplay(currentTab);
            this.showSuccessMessage(`Added "${itemText}" to ${currentTab.toUpperCase()}! 📝`);
        }
    }

    resetItinerary() {
        if (confirm('Are you sure you want to reset your entire itinerary? This cannot be undone.')) {
            this.itineraryData = { day1: [], day2: [], day3: [], day4: [], customItems: [], lastModified: null };
            localStorage.removeItem('anniversary_itinerary');
            this.refreshAllItineraryDisplays();
            this.showSuccessMessage('Itinerary reset successfully! 🔄');
        }
    }

    refreshItineraryDisplay(dayId) {
        // This would update the display for a specific day
        // Implementation depends on the specific HTML structure
        console.log(`Refreshing itinerary display for ${dayId}`, this.itineraryData[dayId]);
    }

    refreshAllItineraryDisplays() {
        ['day1', 'day2', 'day3', 'day4'].forEach(day => {
            this.refreshItineraryDisplay(day);
        });
    }

    // Budget Calculator Enhancement
    setupBudgetCalculator() {
        // Set up budget input listeners
        const budgetInputs = document.querySelectorAll('#budget-meals, #budget-drinks, #budget-extras');
        budgetInputs.forEach(input => {
            if (input) {
                input.addEventListener('input', () => this.updateBudgetCalculation());
            }
        });
    }

    updateBudgetCalculation() {
        const meals = parseFloat(document.getElementById('budget-meals')?.value) || 0;
        const drinks = parseFloat(document.getElementById('budget-drinks')?.value) || 0;
        const extras = parseFloat(document.getElementById('budget-extras')?.value) || 0;
        
        const subtotal = meals + drinks + extras;
        const taxTip = subtotal * 0.25; // 25% for tax and tip
        const total = subtotal + taxTip;
        
        // Update display
        document.getElementById('calc-base-cost').textContent = `$${meals}`;
        document.getElementById('calc-drinks-cost').textContent = `$${drinks}`;
        document.getElementById('calc-extras-cost').textContent = `$${extras}`;
        document.getElementById('calc-tax-cost').textContent = `$${Math.round(taxTip)}`;
        document.getElementById('calc-total-cost').textContent = `$${Math.round(total)}`;
        
        // Update recommendation
        let recommendation = '';
        if (total < 150) recommendation = 'Perfect for a cozy, intimate anniversary! 💕';
        else if (total < 250) recommendation = 'Great balance of romance and experiences! ✨';
        else if (total < 400) recommendation = 'Luxury anniversary weekend! 🥂';
        else recommendation = 'Ultimate romantic getaway! 💎';
        
        const recEl = document.getElementById('calc-recommendation');
        if (recEl) recEl.textContent = recommendation;
        
        // Save budget data
        this.budgetData = { meals, drinks, extras, lastPlan: this.budgetData.lastPlan };
        this.saveBudgetData();
    }

    // Notes System Enhancement
    setupNotesSystem() {
        // Set up note saving
        document.querySelectorAll('.save-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const notesId = e.target.id.replace('save-notes-', 'notes');
                const textarea = document.querySelector(`#${notesId} textarea`);
                if (textarea) {
                    this.saveNotes(`day${notesId.slice(-1)}`, textarea.value);
                }
            });
        });

        // Set up quick note buttons
        document.querySelectorAll('.quick-note-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const noteText = e.target.dataset.text;
                if (noteText) {
                    this.addQuickNote(noteText);
                }
            });
        });

        // Set up notes tab switching
        document.querySelectorAll('.notes-tab-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.switchNotesTab(e.target.dataset.notesTab);
            });
        });
    }

    addQuickNote(text) {
        const activeTab = document.querySelector('.notes-tab-btn.active-tab')?.dataset.notesTab;
        const dayId = activeTab ? `day${activeTab.slice(-1)}` : 'day1';
        
        const currentNotes = this.notesData[dayId] || '';
        const timestamp = new Date().toLocaleString();
        const newNote = `${currentNotes}\n[${timestamp}] ${text}\n`;
        
        this.saveNotes(dayId, newNote);
        
        // Update textarea if visible
        const textarea = document.querySelector(`#${activeTab} textarea`);
        if (textarea) {
            textarea.value = newNote;
        }
    }

    switchNotesTab(tabId) {
        // Update tab appearance
        document.querySelectorAll('.notes-tab-btn').forEach(btn => {
            btn.classList.remove('active-tab', 'bg-[#C07F63]', 'text-white');
            btn.classList.add('text-[#2C1A1E]/70');
        });
        
        const activeBtn = document.querySelector(`[data-notes-tab="${tabId}"]`);
        if (activeBtn) {
            activeBtn.classList.add('active-tab', 'bg-[#C07F63]', 'text-white');
            activeBtn.classList.remove('text-[#2C1A1E]/70');
        }
        
        // Show/hide content
        document.querySelectorAll('.notes-content').forEach(content => {
            content.style.display = 'none';
        });
        
        const activeContent = document.getElementById(tabId);
        if (activeContent) {
            activeContent.style.display = 'block';
        }
    }

    // Filtering Systems Enhancement
    setupFilteringSystems() {
        // Restaurant filtering
        document.querySelectorAll('.restaurant-filter').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.filterRestaurants(e.target.dataset.category);
                this.updateFilterButtonStates(e.target, '.restaurant-filter');
            });
        });

        // Comparison table filtering
        document.querySelectorAll('.comparison-filter').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.filterComparisonTable(e.target.dataset.sort);
                this.updateFilterButtonStates(e.target, '.comparison-filter');
            });
        });

        // General activity filtering
        document.querySelectorAll('.btn-filter').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.filterActivities(e.target.dataset.filter);
                this.updateFilterButtonStates(e.target, '.btn-filter');
            });
        });
    }

    filterRestaurants(category) {
        const restaurants = document.querySelectorAll('.restaurant-card, .restaurant-item');
        restaurants.forEach(restaurant => {
            const categories = restaurant.dataset.categories || '';
            if (category === 'all' || categories.includes(category)) {
                restaurant.style.display = 'block';
                restaurant.classList.remove('hidden');
            } else {
                restaurant.style.display = 'none';
                restaurant.classList.add('hidden');
            }
        });
        
        this.showSuccessMessage(`Filtered to show ${category === 'all' ? 'all' : category} restaurants! 🍽️`);
    }

    filterComparisonTable(sortType) {
        const tableBody = document.querySelector('.restaurant-comparison-row')?.parentElement;
        if (!tableBody) return;
        
        const rows = Array.from(tableBody.querySelectorAll('.restaurant-comparison-row'));
        
        let sortedRows;
        switch (sortType) {
            case 'romantic':
                sortedRows = rows.filter(row => row.dataset.categories?.includes('romantic'));
                break;
            case 'price-low':
                sortedRows = rows.sort((a, b) => {
                    const priceA = parseFloat(a.querySelector('.font-semibold').textContent.replace('$', ''));
                    const priceB = parseFloat(b.querySelector('.font-semibold').textContent.replace('$', ''));
                    return priceA - priceB;
                });
                break;
            case 'price-high':
                sortedRows = rows.sort((a, b) => {
                    const priceA = parseFloat(a.querySelector('.font-semibold').textContent.replace('$', ''));
                    const priceB = parseFloat(b.querySelector('.font-semibold').textContent.replace('$', ''));
                    return priceB - priceA;
                });
                break;
            default:
                sortedRows = rows;
        }
        
        // Re-append sorted rows
        sortedRows.forEach(row => tableBody.appendChild(row));
        this.showSuccessMessage(`Table sorted by ${sortType}! 📊`);
    }

    filterActivities(filter) {
        const activities = document.querySelectorAll('.activity-item, .itinerary-item');
        activities.forEach(activity => {
            const category = activity.dataset.category || '';
            if (filter === 'all' || category === filter) {
                activity.style.display = 'block';
                activity.classList.remove('hidden');
            } else {
                activity.style.display = 'none';
                activity.classList.add('hidden');
            }
        });
        
        this.showSuccessMessage(`Showing ${filter === 'all' ? 'all' : filter} activities! 🎯`);
    }

    updateFilterButtonStates(activeBtn, selector) {
        document.querySelectorAll(selector).forEach(btn => {
            btn.classList.remove('active', 'bg-[#C07F63]', 'text-white');
            btn.classList.add('bg-white', 'text-[#2C1A1E]');
        });
        
        activeBtn.classList.add('active', 'bg-[#C07F63]', 'text-white');
        activeBtn.classList.remove('bg-white', 'text-[#2C1A1E]');
    }

    // Tab Switching Enhancement
    setupTabSwitching() {
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.addEventListener('click', (e) => {
                this.switchTab(e.target.dataset.tab);
            });
        });
    }

    switchTab(tabId) {
        // Update tab appearance
        document.querySelectorAll('.tab-btn').forEach(btn => {
            btn.classList.remove('active-tab', 'border-[#8B7355]', 'text-[#8B7355]');
            btn.classList.add('text-gray-500', 'border-transparent');
        });
        
        const activeBtn = document.querySelector(`[data-tab="${tabId}"]`);
        if (activeBtn) {
            activeBtn.classList.add('active-tab', 'border-[#8B7355]', 'text-[#8B7355]');
            activeBtn.classList.remove('text-gray-500', 'border-transparent');
        }
        
        // Show/hide content
        document.querySelectorAll('.tab-content').forEach(content => {
            content.classList.add('hidden');
        });
        
        const activeContent = document.getElementById(tabId);
        if (activeContent) {
            activeContent.classList.remove('hidden');
        }
        
        // Save current tab preference
        localStorage.setItem('anniversary_current_tab', tabId);
    }

    // Utility functions
    showSuccessMessage(message) {
        const successMsg = document.createElement('div');
        successMsg.className = 'fixed top-4 right-4 bg-green-500 text-white px-6 py-3 rounded-lg shadow-lg z-50 transform transition-transform duration-300';
        successMsg.innerHTML = `
            <div class="flex items-center">
                <span class="mr-2">✅</span>
                <span>${message}</span>
            </div>
        `;
        
        document.body.appendChild(successMsg);
        
        setTimeout(() => {
            successMsg.style.transform = 'translateX(400px)';
            setTimeout(() => successMsg.remove(), 300);
        }, 3000);
    }

    // Additional helper functions
    focusCustomPoint(lat, lng) {
        if (this.map) {
            this.map.setView([lat, lng], 17);
        }
    }

    removeCustomPoint(lat, lng) {
        // Remove from map
        this.map.eachLayer(layer => {
            if (layer instanceof L.Marker && 
                Math.abs(layer.getLatLng().lat - lat) < 0.0001 && 
                Math.abs(layer.getLatLng().lng - lng) < 0.0001) {
                this.map.removeLayer(layer);
            }
        });
        
        // Remove from data
        this.customMapPoints = this.customMapPoints.filter(point => 
            Math.abs(point.lat - lat) > 0.0001 || Math.abs(point.lng - lng) > 0.0001
        );
        
        this.saveCustomPoints();
        this.showSuccessMessage('Custom point removed! 🗑️');
    }

    shareItinerary() {
        const shareData = {
            title: 'Providence Anniversary Weekend',
            text: 'Check out our romantic anniversary itinerary!',
            url: window.location.href
        };
        
        if (navigator.share) {
            navigator.share(shareData);
        } else {
            // Fallback: copy to clipboard
            navigator.clipboard.writeText(window.location.href).then(() => {
                this.showSuccessMessage('Link copied to clipboard! 📋');
            });
        }
    }

    addToCalendar(eventType = 'anniversary') {
        const events = {
            'anniversary': {
                title: 'Providence Anniversary Weekend',
                start: '2024-07-11T19:00:00',
                end: '2024-07-14T12:00:00',
                description: 'Romantic anniversary getaway in Providence, RI'
            },
            'budget-review': {
                title: 'Review Anniversary Budget',
                start: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(),
                end: new Date(Date.now() + 24 * 60 * 60 * 1000 + 60 * 60 * 1000).toISOString(),
                description: 'Review and finalize budget for Providence anniversary weekend'
            }
        };
        
        const event = events[eventType];
        if (!event) return;
        
        const calendarUrl = `https://calendar.google.com/calendar/render?action=TEMPLATE&text=${encodeURIComponent(event.title)}&dates=${event.start.replace(/[-:]/g, '').split('.')[0]}Z/${event.end.replace(/[-:]/g, '').split('.')[0]}Z&details=${encodeURIComponent(event.description)}`;
        
        window.open(calendarUrl, '_blank');
        this.showSuccessMessage('Opening Google Calendar... 📅');
    }

    restoreUserData() {
        // Restore saved tab
        const savedTab = localStorage.getItem('anniversary_current_tab');
        if (savedTab) {
            this.switchTab(savedTab);
        }
        
        // Restore custom map points
        if (this.customMapPoints && this.customMapPoints.length > 0 && this.map) {
            this.customMapPoints.forEach(point => {
                L.marker([point.lat, point.lng])
                    .addTo(this.map)
                    .bindPopup(`
                        <div class="text-center">
                            <strong>${point.name}</strong><br>
                            <small>Custom point</small><br>
                            <button onclick="window.removeCustomPoint(${point.lat}, ${point.lng})" 
                                    class="mt-2 bg-red-500 text-white px-2 py-1 rounded text-xs">
                                Remove
                            </button>
                        </div>
                    `);
            });
        }
        
        // Restore notes content
        Object.keys(this.notesData).forEach(dayId => {
            if (dayId.startsWith('day')) {
                const textarea = document.querySelector(`#notes${dayId.slice(-1)} textarea`);
                if (textarea && this.notesData[dayId]) {
                    textarea.value = this.notesData[dayId];
                }
            }
        });
        
        // Update budget display if elements exist
        if (this.budgetData.meals || this.budgetData.drinks || this.budgetData.extras) {
            setTimeout(() => this.updateBudgetCalculation(), 500);
        }
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
