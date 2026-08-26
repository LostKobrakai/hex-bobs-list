defmodule BobVersions.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: BobVersions.PubSub},
      BobVersionsWeb.Endpoint
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BobVersions.Supervisor)
  end

  @impl true
  def config_change(changed, _new, removed) do
    BobVersionsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
