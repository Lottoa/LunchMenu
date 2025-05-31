// 캐시 이름 및 파일 목록
const CACHE_NAME = 'lunchmenu-cache-v1';
const urlsToCache = [
  '/',
  '/index.html',
  '/icon.png',
  '/og_image.png',
  '/mainfest.json',
  '/sw.js',
  'https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.2/gsap.min.js'
];

// 설치 이벤트: 캐시 생성
self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => {
      return cache.addAll(urlsToCache);
    })
  );
  self.skipWaiting();
});

// 활성화 이벤트: 오래된 캐시 정리
self.addEventListener('activate', event => {
  const cacheWhitelist = [CACHE_NAME];
  event.waitUntil(
    caches.keys().then(keyList =>
      Promise.all(
        keyList.map(key => {
          if (!cacheWhitelist.includes(key)) {
            return caches.delete(key);
          }
        })
      )
    )
  );
  self.clients.claim();
});

// fetch 이벤트: 캐시 우선, 네트워크가 안되면 캐시에서 읽기
self.addEventListener('fetch', event => {
  event.respondWith(
    caches.match(event.request).then(response => {
      return response || fetch(event.request);
    })
  );
});