defmodule BobVersions.Availability do
  use Supervisor
  alias BobVersions.Availability.Worker
  alias BobVersions.Availability.Workers
  alias BobVersions.Availability.Registry, as: WorkerRegistry

  def start_link(arg) do
    Supervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    children = [
      Workers,
      WorkerRegistry
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  def url_availability(url) do
    Worker.availability(url)
  end
end
