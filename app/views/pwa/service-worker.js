// LawyerEC service worker — enables installable PWA behaviour.
const CACHE = "lawyerec-shell-v2";
const OFFLINE_ASSETS = [ "/offline.html", "/icon-512.png" ];

self.addEventListener("install", (event) => {
  event.waitUntil(caches.open(CACHE).then((cache) => cache.addAll(OFFLINE_ASSETS)));
  self.skipWaiting();
});

self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k))))
  );
  self.clients.claim();
});

// Network-first: always try the live app (it is authenticated and dynamic).
// When offline, page navigations fall back to a branded offline screen and
// other GET requests fall back to any cached static asset.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== "GET") return;
  event.respondWith(
    fetch(event.request).catch(async () => {
      if (event.request.mode === "navigate") {
        return (await caches.match("/offline.html")) || Response.error();
      }
      return (await caches.match(event.request)) || Response.error();
    })
  );
});
