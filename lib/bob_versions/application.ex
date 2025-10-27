defmodule BobVersions.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BobVersionsWeb.Telemetry,
      # Finch http client pool
      BobVersions.Finch,
      # Start the PubSub system
      {Phoenix.PubSub, name: BobVersions.PubSub},
      # Cache for resource availability
      {BobVersions.EtagCachedResources, name: BobVersions.EtagCachedResources},
      # Resource availability checker
      BobVersions.Availability,
      # Start the Endpoint (http/https)
      BobVersionsWeb.Endpoint
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BobVersions.Supervisor)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BobVersionsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
