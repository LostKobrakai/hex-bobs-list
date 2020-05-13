defmodule BobVersionsWeb.AvailabilityLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="status <%= status(@availability) %>"></div>
    """
  end

  defp status("available"), do: "status--success"
  defp status("unavailable"), do: "status--danger"
  defp status("undetermined"), do: "status--unknown"

  def mount(_params, %{"availability" => availability, "url" => url}, socket) do
    Phoenix.PubSub.subscribe(BobVersions.PubSub, "availability")

    availability =
      if connected?(socket) do
        BobVersions.Availability.url_availability(url)
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
