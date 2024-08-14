defmodule BobVersionsWeb.AvailabilityLive do
  use Phoenix.LiveView
  require Logger

  def render(assigns) do
    ~H"""
    <div class={"status #{status(@availability)}"}></div>
    """
  end

  defp status("available"), do: "status--success"
  defp status("unavailable"), do: "status--danger"
  defp status("undetermined"), do: "status--unknown"

  defp status(status) do
    Logger.warning("Invalid status: #{status}")
    "status--unknown"
  end

  def mount(_params, %{"availability" => availability, "url" => url}, socket) do
    Phoenix.PubSub.subscribe(BobVersions.PubSub, "availability")

    availability =
      if connected?(socket) do
        BobVersions.Availability.url_availability(url) |> Atom.to_string()
      else
        availability
      end

    socket = assign(socket, availability: availability, url: url)

    {:ok, socket}
  end

  def handle_info(%{url: url, availability: availability}, %{assigns: %{url: url}} = socket) do
    socket = assign(socket, availability: availability |> Atom.to_string())
    {:noreply, socket}
  end

  def handle_info(%{url: _, availability: _}, socket) do
    {:noreply, socket}
  end
end
