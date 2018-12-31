defmodule BobVersions.Repo do
  use Ecto.Repo,
    otp_app: :bob_versions,
    adapter: Ecto.Adapters.Postgres
end
