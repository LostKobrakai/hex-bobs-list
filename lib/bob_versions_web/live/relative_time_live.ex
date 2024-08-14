defmodule BobVersionsWeb.RelativeTimeLive do
  use Phoenix.LiveView

  def render(assigns) do
    ~H"""
    <time datetime={DateTime.to_iso8601(@datetime)} title={format_datetime(@datetime)}>
      <%= format_datetime(@datetime_shifted) %>
    </time>
    """
  end

  def mount(_params, %{"datetime" => datetime_iso}, socket) do
    timezone =
      if connected?(socket) do
        get_connect_params(socket)["timezone"]
      else
        "Etc/UTC"
      end

    {:ok, datetime, 0} = DateTime.from_iso8601(datetime_iso)
    {:ok, datetime_shifted} = DateTime.shift_zone(datetime, timezone)

    socket =
      assign(socket,
        datetime: datetime,
        datetime_shifted: datetime_shifted
      )

    {:ok, socket}
  end

  defp format_datetime(datetime) do
    [
      datetime |> Date.to_iso8601(),
      datetime |> Time.to_iso8601(),
      datetime.zone_abbr
    ]
    |> Enum.join(" ")
  end
end
