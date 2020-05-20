import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"

let timezone;
try {
  timezone = Intl.DateTimeFormat().resolvedOptions().timeZone
} catch (e) {
  timezone = "Etc/UTC"
}

// let csrfToken =
//   document
//     .querySelector("meta[name='csrf-token']")
//     .getAttribute("content");

let liveSocket = new LiveSocket("/live", Socket, {
  params: { timezone: timezone }
});

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket