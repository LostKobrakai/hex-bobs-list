defmodule BobVersions.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: BobVersions.PubSub},
      {BobVersions.EtagCachedResources, name: BobVersions.EtagCachedResources},
      BobVersions.Availability
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: BobVersions.Supervisor)
  end
end
