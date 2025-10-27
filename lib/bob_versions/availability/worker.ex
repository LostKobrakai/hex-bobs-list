defmodule BobVersions.Availability.Worker do
  use GenServer
  require Logger
  alias BobVersions.Availability.Workers
  alias BobVersions.Availability.Registry

  @timeout :timer.hours(24)
  @interval :timer.minutes(5)

  # Client

  def start_link(url) do
    GenServer.start_link(__MODULE__, url, name: Registry.via_tuple(url))
  end

  def availability(url) do
    case get_pid(url) do
      {:ok, pid} -> GenServer.call(pid, :availability)
      _ -> :undetermined
    end
  end

  defp get_pid(url) do
    case Workers.start_worker(url) do
      {:error, {:already_started, pid}} -> {:ok, pid}
      other -> other
    end
  end

  # Server

  def init(url) do
    Process.send_after(self(), :check_availability, 0)
    {:ok, %{url: url, availability: :undetermined, timeout: @timeout}}
  end

  def handle_call(:availability, _, state) do
    state = reset_timeout(state)
    {:reply, state.availability, state, state.timeout}
  end

  def handle_info(:check_availability, state) do
    state = update_availability(state)
    state = subtract_timeout(state)
    Process.send_after(self(), :check_availability, @interval)
    {:noreply, state, state.timeout}
  end

  def handle_info(:timeout, state) do
    Logger.debug("Stopping worker for #{state.url}")
    {:stop, {:shutdown, :timeout}, state}
  end

  # Helper

  defp reset_timeout(state) do
    Map.put(state, :timeout, @timeout)
  end

  defp subtract_timeout(state) do
    Map.update!(state, :timeout, fn x ->
      max(x - @interval, 0)
    end)
  end

  defp update_availability(state) do
    Logger.debug("Update url #{state.url}")

    availability =
      case Req.head(url: state.url, finch: BobVersions.Finch) do
        {:ok, %Req.Response{status: 200}} -> :available
        _ -> :unavailable
      end

    if state.availability != availability do
      Phoenix.PubSub.broadcast(BobVersions.PubSub, "availability", %{
        url: state.url,
        availability: availability
      })
    end

    Map.put(state, :availability, availability)
  end
end
