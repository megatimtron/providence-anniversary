// Service Worker for Providence Anniversary Website
// Enables offline functionality and caching

const CACHE_NAME = 'providence-anniversary-v1.2';
const urlsToCache = [
    '/',
    '/index.html',
    '/assets/css/style.css',
    '/assets/js/main.js',
    '/assets/js/enhancements.js',
    '/assets/images/ugo1.jpg',
    '/assets/images/ugo2.jpg',
    '/assets/images/ugo3.jpg',
    '/assets/images/ugo4.jpg',
    '/assets/icons/heart-icon.png',
    '/manifest.json'
];

// Install event - cache resources
self.addEventListener('install', event => {
    console.log('Service Worker installing...');
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => {
                console.log('Caching app resources');
                return cache.addAll(urlsToCache);
            })
            .then(() => self.skipWaiting())
    );
});

// Activate event - clean up old caches
self.addEventListener('activate', event => {
    console.log('Service Worker activating...');
    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames.map(cacheName => {
                    if (cacheName !== CACHE_NAME) {
                        console.log('Deleting old cache:', cacheName);
                        return caches.delete(cacheName);
                    }
                })
            );
        }).then(() => self.clients.claim())
    );
});

// Fetch event - serve from cache, fallback to network
self.addEventListener('fetch', event => {
    event.respondWith(
        caches.match(event.request)
            .then(response => {
                // Return cached version or fetch from network
                if (response) {
                    return response;
                }
                
                return fetch(event.request).then(response => {
                    // Don't cache non-successful responses
                    if (!response || response.status !== 200 || response.type !== 'basic') {
                        return response;
                    }
                    
                    // Clone the response
                    const responseToCache = response.clone();
                    
                    caches.open(CACHE_NAME)
                        .then(cache => {
                            cache.put(event.request, responseToCache);
                        });
                    
                    return response;
                });
            })
            .catch(() => {
                // Offline fallback for HTML pages
                if (event.request.destination === 'document') {
                    return caches.match('/index.html');
                }
            })
    );
});

// Background sync for offline data
self.addEventListener('sync', event => {
    if (event.tag === 'background-sync') {
        event.waitUntil(doBackgroundSync());
    }
});

async function doBackgroundSync() {
    // Sync any offline data when connection returns
    console.log('Background sync triggered');
    
    // Here you could sync offline notes, photos, etc.
    const offlineData = await getOfflineData();
    if (offlineData.length > 0) {
        await syncOfflineData(offlineData);
    }
}

async function getOfflineData() {
    // Get data stored while offline
    const cache = await caches.open('offline-data');
    return []; // Placeholder
}

async function syncOfflineData(data) {
    // Sync data to server
    console.log('Syncing offline data...');
}

// Push notifications (if needed)
self.addEventListener('push', event => {
    const options = {
        body: event.data ? event.data.text() : 'New anniversary update!',
        icon: '/assets/icons/heart-icon.png',
        badge: '/assets/icons/anniversary-badge.png',
        vibrate: [100, 50, 100],
        data: {
            dateOfArrival: Date.now(),
            primaryKey: '2'
        },
        actions: [
            {
                action: 'explore',
                title: 'View Update',
                icon: '/assets/icons/view-icon.png'
            },
            {
                action: 'close',
                title: 'Close',
                icon: '/assets/icons/close-icon.png'
            }
        ]
    };
    
    event.waitUntil(
        self.registration.showNotification('Providence Anniversary', options)
    );
});

// Handle notification clicks
self.addEventListener('notificationclick', event => {
    event.notification.close();
    
    if (event.action === 'explore') {
        event.waitUntil(
            clients.openWindow('/')
        );
    }
});
