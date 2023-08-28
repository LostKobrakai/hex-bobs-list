defmodule BobVersionsWeb.Router do
  use BobVersionsWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    # plug :fetch_session
    # plug :fetch_live_flash
    plug :put_root_layout, html: {BobVersionsWeb.Layouts, :root}
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/", BobVersionsWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/elixir", ElixirController, :index
    get "/erlang/:distro", ErlangController, :show
    live_dashboard "/dashboard", metrics: BobVersionsWeb.Telemetry
  end
end
