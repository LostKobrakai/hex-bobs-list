# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Set timezone database
config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Configures the endpoint
config :bob_versions, BobVersionsWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: BobVersionsWeb.ErrorHTML],
    layout: false
  ],
  pubsub_server: BobVersions.PubSub,
  live_view: [signing_salt: "v6n8wRA8"]

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  default: [
    args:
      ~w(js/app.js js/storybook.js  --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
# config :tailwind,
#   version: "3.3.2",
#   default: [
#     args: ~w(
#       --config=tailwind.config.js
#       --input=css/app.css
#       --output=../priv/static/assets/app.css
#     ),
#     cd: Path.expand("../assets", __DIR__)
#   ]

config :dart_sass,
  version: "1.66.1",
  default: [
    args: ~w(css/app.sass ../priv/static/assets/app.css),
    cd: Path.expand("../assets", __DIR__),
    env: %{"SASS_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :tailwind,
  version: "3.2.7",
  storybook: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/storybook.css
      --output=../priv/static/assets/storybook.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
