defmodule BobVersionsWeb.PageController do
  use BobVersionsWeb, :controller

  def index(conn, _params) do
    case BobVersions.get_bob_builds_file() do
      {_, text} ->
        data = BobVersions.text_to_data(text)
        stable = BobVersions.current_stable()
        active = BobVersions.default_otp_version()
        render(conn, "index.html", data: data, active: active, stable: stable)

      :error ->
        conn
        |> put_view(BobVersionsWeb.ErrorView)
        |> render("no_resource.html")
    end
  end
end
