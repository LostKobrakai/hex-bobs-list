import Config

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :bob_versions,
  ecto_repos: []

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :bob_versions_web,
  ecto_repos: [BobVersions.Repo],
  generators: [context_app: :bob_versions]

# Configures the endpoint
config :bob_versions_web, BobVersionsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "EjjiUUSgq61KNFCQmCsEI1FZarRz8rw3sKZEZ46I6BctZbjgUDPBfL98GqyfgaUG",
  render_errors: [view: BobVersionsWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BobVersionsWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
