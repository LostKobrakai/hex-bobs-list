# Since configuration is shared in umbrella projects, this file
# should only configure the :bob_versions application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :bob_versions, BobVersions.Repo,
  username: "postgres",
  password: "postgres",
  database: "bob_versions_dev",
  hostname: "localhost",
  pool_size: 10
