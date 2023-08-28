import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

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

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)
window.liveSocket = liveSocket