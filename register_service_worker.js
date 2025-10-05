if ("serviceWorker" in navigator) {
  const baseEl = document.querySelector("base");
  const baseHref =
    baseEl && baseEl.getAttribute("href") ? baseEl.getAttribute("href") : "/";
  const swUrl = baseHref + "flutter_service_worker.js";

  navigator.serviceWorker.register(swUrl).then((reg) => {
    // Lắng nghe khi có service worker mới
    reg.onupdatefound = () => {
      const newWorker = reg.installing;
      newWorker.onstatechange = () => {
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
