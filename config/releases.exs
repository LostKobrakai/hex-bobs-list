import Config

# No DB right now
# config :bob_versions, BobVersions.Repo,
#   url: System.fetch_env!("DATABASE_URL"),
#   database: "",
#   ssl: true,
#   pool_size: 2

config :bob_versions_web, BobVersionsWeb.Endpoint,
  url: [port: 443],
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")
