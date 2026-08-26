defmodule BobVersionsWeb.Router do
  use BobVersionsWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :put_root_layout, html: {BobVersionsWeb.Layouts, :root}
    plug :put_secure_browser_headers
  end

  scope "/", BobVersionsWeb do
    pipe_through :browser

    get "/", PageController, :index
  end
end
