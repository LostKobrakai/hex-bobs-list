import Config

config :logger, level: :warn

config :bob_versions, BobVersions.Repo,
  username: "postgres",
  password: "postgres",
  database: "bob_versions_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :bob_versions_web, BobVersionsWeb.Endpoint,
  http: [port: 4002],
  server: false
