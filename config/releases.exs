import Config

config :bob_versions, BobVersions.Repo,
  url: System.fetch_env!("DATABASE_URL"),
  database: "",
  ssl: true,
  pool_size: 2

config :bob_versions_web, BobVersionsWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 4000],
  url: [port: 443],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  secret_key_base: System.fetch_env!("SECRET_KEY_BASE")
