const CACHE_VERSION = 'finanzas-v1';
const CACHE_ASSETS = [
  '/',
  '/manifest.json',
  '/assets/tailwind.css',
  '/assets/application.css',
  '/assets/application.js'
];

// Install: cache assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_VERSION).then((cache) => {
      return cache.addAll(CACHE_ASSETS).catch(() => {
        // Some assets may fail to cache (like dynamic JS bundles)
        // This is OK - we'll fetch them on demand
      });
    })
  );
  self.skipWaiting();
});

// Activate: clean up old caches
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((name) => {
          if (name !== CACHE_VERSION) {
            return caches.delete(name);
          }
        })
      );
    })
  );
  self.clients.claim();
});

// Fetch: network-first for HTML, cache-first for assets
self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // Skip non-GET requests
  if (request.method !== 'GET') {
    return;
  }

  // Network-first for HTML pages and API calls
  if (request.headers.get('accept')?.includes('text/html') || url.pathname.startsWith('/api/')) {
    event.respondWith(
      fetch(request)
        .then((response) => {
          // Cache successful responses
          if (response.status === 200) {
            const cache = caches.open(CACHE_VERSION);
            cache.then((c) => c.put(request, response.clone()));
          }
          return response;
        })
        .catch(() => {
          // Fall back to cache
          return caches.match(request);
        })
    );
    return;
  }

  // Cache-first for assets (CSS, JS, images)
  event.respondWith(
    caches.match(request).then((response) => {
      if (response) {
        return response;
      }
      return fetch(request).then((response) => {
        if (response.status === 200) {
          const cache = caches.open(CACHE_VERSION);
          cache.then((c) => c.put(request, response.clone()));
        }
        return response;
      });
    })
  );
});
