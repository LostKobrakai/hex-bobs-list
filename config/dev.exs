import Config

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

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
    # Start the esbuild watcher by calling Esbuild.install_and_run(:default, args)
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    sass:
      {DartSass, :install_and_run,
       [:default, ~w(--embed-source-map --source-map-urls=absolute --watch)]}
  ],
  live_reload: [
    patterns: [
      ~r{priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$},
      ~r{priv/gettext/.*(po)$},
      ~r{lib/bob_versions_web/views/.*(ex)$},
      ~r{lib/bob_versions_web/templates/.*(eex)$}
    ]
  ]
