import Config

config :logger, level: :warn

config :bob_versions_web, BobVersionsWeb.Endpoint,
  http: [port: 4002],
  server: false
