defmodule BobVersionsWeb.Router do
  use BobVersionsWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    # plug :fetch_session
    # plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BobVersionsWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/elixir", ElixirController, :index
    get "/erlang/:distro", ErlangController, :show
    live_dashboard "/dashboard", metrics: BobVersionsWeb.Telemetry
  end

  # Other scopes may use custom stacks.
  # scope "/api", BobVersionsWeb do
  #   pipe_through :api
  # end
end
