import Config

config :logger, level: :info

config :bob_versions_web, BobVersionsWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT") || 4000],
  url: [port: 80],
  cache_static_manifest: "priv/static/cache_manifest.json",
  server: true,
  secret_key_base: "${SECRET_KEY_BASE}",
  force_ssl: [rewrite_on: [:x_forwarded_proto], host: nil]
