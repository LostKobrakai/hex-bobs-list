defmodule BobVersions.Availability.Workers do
  use DynamicSupervisor
  alias BobVersions.Availability.Worker

  def start_link(arg) do
    DynamicSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  def start_worker(url) do
    DynamicSupervisor.start_child(__MODULE__, {Worker, url})
  end
end
