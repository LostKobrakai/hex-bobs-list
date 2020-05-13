import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :bob_versions,
  ecto_repos: []

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bob_versions_web,
  generators: [context_app: :bob_versions]

# Configures the endpoint
config :bob_versions_web, BobVersionsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EjjiUUSgq61KNFCQmCsEI1FZarRz8rw3sKZEZ46I6BctZbjgUDPBfL98GqyfgaUG",
  render_errors: [view: BobVersionsWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: BobVersions.PubSub,
  live_view: [signing_salt: "N3nxrR5NPzhdvM1TzkDlqd7GpK1hdq+A"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
