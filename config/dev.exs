import Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

config :bob_versions, BobVersions.Repo,
  username: "postgres",
  password: "postgres",
  database: "bob_versions_dev",
  hostname: "localhost",
  pool_size: 10

# Initialize plugs at runtime for faster development compilation
config :phoenix,
  plug_init_mode: :runtime,
  stacktrace_depth: 20

config :bob_versions_web, BobVersionsWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch-stdin",
      cd: Path.expand("../apps/bob_versions_web/assets", __DIR__)
    ]
  ],
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/bob_versions_web/views/.*(ex)$},
      ~r{lib/bob_versions_web/templates/.*(eex)$}
    ]
  ]
