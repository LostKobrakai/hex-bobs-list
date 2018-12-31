# Since configuration is shared in umbrella projects, this file
# should only configure the :bob_versions application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :bob_versions,
  ecto_repos: [BobVersions.Repo]

import_config "#{Mix.env()}.exs"
