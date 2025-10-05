console.log("File js loaded \n");
if ("serviceWorker" in navigator) {
  console.log("ServiceWorker is running... \n");
  const baseEl = document.querySelector("base");
  const baseHref =
    baseEl && baseEl.getAttribute("href") ? baseEl.getAttribute("href") : "/";
  const swUrl = baseHref + "flutter_service_worker.js";
  console.log("[SW] Registering service worker at", swUrl);

  navigator.serviceWorker.register(swUrl).then((reg) => {
    // Lắng nghe khi có service worker mới
    console.log("Listening is running... \n");
    reg.onupdatefound = () => {
      const newWorker = reg.installing;
      newWorker.onstatechange = () => {
        console.log("Onstatechange is running... \n");
        if (
          newWorker.state === "installed" &&
          navigator.serviceWorker.controller
        ) {
          // Gửi sự kiện custom cho Flutter
          console.log("DispatchEvent is running... \n");
          window.dispatchEvent(new Event("flutter_update_ready"));
        }
      };
    };
  });
}
