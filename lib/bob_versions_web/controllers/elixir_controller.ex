defmodule BobVersionsWeb.ElixirController do
  use BobVersionsWeb, :controller

  def index(conn, _params) do
    case BobVersions.get_bob_elixir_builds_file() do
      {_, text} ->
        data = BobVersions.text_to_data(:elixir, text)
        stable = BobVersions.current_stable()
        active = BobVersions.default_otp_version()

        conn
        |> put_view(BobVersionsWeb.ElixirView)
        |> render("index.html",
          data: data,
          active: active,
          stable: stable,
          title: "Elixir",
          subtitle: "Overview of all available packages built by hex bob."
        )

      :error ->
        conn
        |> put_view(BobVersionsWeb.ErrorView)
        |> render("no_resource.html")
    end
  end
end
