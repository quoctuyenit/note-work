console.log('File js loaded \n');
if ('serviceWorker' in navigator) {
  console.log('ServiceWorker is running... \n');
  navigator.serviceWorker.register('/flutter_service_worker.js').then((reg) => {
    // Lắng nghe khi có service worker mới
    console.log('Listening is running... \n');
    reg.onupdatefound = () => {
      const newWorker = reg.installing;
      newWorker.onstatechange = () => {
        console.log('Onstatechange is running... \n');
        if (newWorker.state === 'installed' && navigator.serviceWorker.controller) {
          // Gửi sự kiện custom cho Flutter
          console.log('DispatchEvent is running... \n');
          window.dispatchEvent(new Event('flutter_update_ready'));
        }
      };
    };
  });
}
