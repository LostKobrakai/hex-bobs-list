defmodule BobVersions.EtagCachedResources do
  @moduledoc """
  Retrieves a webbased resource by caching it for a given amount of time
  and then updating the local copy taking proper etags into account.

  ## Usage

      {:ok, pid} = BobVersions.EtagCachedResources.start_link()
      url = "https://builds.hex.pm/builds/elixir/builds.txt"
      # Downloads resource
      {:ok, _} = BobVersions.EtagCachedResources.resource(url)
      # Serves cached content
      {:ok, _} = BobVersions.EtagCachedResources.resource(url)
  """
  use GenServer
  require Logger

  @type url :: binary
  @type headers :: [{charlist(), term}]
  @type etag :: charlist

  @ets_table __MODULE__
  @default_opts [
    cache_timeout: 1800,
    method: :get
  ]

  @doc """
  Start the server to cache etag values
  """
  @spec start_link(Keyword.t()) :: GenServer.on_start()
  def start_link(opts \\ []) do
    Logger.debug("Start EtagCachedResources server")
    GenServer.start_link(__MODULE__, nil, opts)
  end

  @doc """
  Receive a resource from a givn url.
  """
  @spec resource(url, Keyword.t()) :: {:ok | :stale, binary} | :error
  @spec resource(GenServer.server(), url) :: {:ok | :stale, binary} | :error
  def resource(url, opts \\ [])

  def resource(url, opts) when is_list(opts) do
    resource(__MODULE__, url, opts)
  end

  def resource(pid, url) when is_binary(url) do
    resource(pid, url, [])
  end

  @spec resource(GenServer.server(), url, Keyword.t()) :: {:ok | :stale, binary} | :error
  def resource(pid, url, opts) do
    config = Keyword.merge(@default_opts, opts) |> Map.new()

    case retrieve_resource(url, config) do
      {:ok, content} ->
        Logger.debug("EtagCachedResources: Served file from cache for url #{url}")
        {:ok, content}

      {:stale, _etag, _content} ->
        try_updating(pid, url, config)

      :error ->
        try_updating(pid, url, config)
    end
  end

  @spec try_updating(GenServer.server(), url, Map.t()) :: {:ok | :stale, binary} | :error
  defp try_updating(pid, url, config) do
    Logger.debug("EtagCachedResources: Call for update on url #{url}")
    GenServer.call(pid, {:update, url, config})
  end

  @impl true
  def init(nil) do
    ets_opts = [:named_table, :ordered_set, :protected, read_concurrency: true]
    table = :ets.new(@ets_table, ets_opts)

    {:ok, %{table: table}}
  end

  @impl true
  def handle_call({:update, url, config}, _, state) do
    reply =
      case retrieve_resource(url, config) do
        {:ok, content} ->
          {:ok, content}

        {:stale, etag, content} ->
          case update(url, etag, config) do
            {:ok, :not_modified} -> {:ok, content}
            {:ok, content} -> {:ok, content}
            :error -> {:stale, content}
          end

        :error ->
          case update(url, nil, config) do
            {:ok, content} when is_binary(content) -> {:ok, content}
            :error -> :error
          end
      end

    {:reply, reply, state}
  end

  @spec retrieve_resource(url, map) :: {:ok, binary} | {:stale, etag, binary} | :error
  defp retrieve_resource(url, %{method: method} = config) do
    with [{{^url, ^method}, timestamp, etag, content}] <- :ets.lookup(@ets_table, {url, method}),
         {:ok, content} <- check_for_stale_content(timestamp, etag, content, config) do
      {:ok, content}
    else
      {:stale, _, _} = result -> result
      [] -> :error
    end
  end

  @spec check_for_stale_content(pos_integer, etag, content, map) ::
          {:ok, content} | {:stale, etag, content}
        when content: binary
  defp check_for_stale_content(timestamp, etag, content, %{cache_timeout: timeout}) do
    now = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    valid_until = timestamp + timeout

    cond do
      now > valid_until -> {:stale, etag, content}
      true -> {:ok, content}
    end
  end

  @spec update(url, etag | nil, map) :: {:ok, binary} | {:ok, :not_modified} | :error
  defp update(url, etag, %{method: method} = config) do
    headers = if_none_match_header(etag)
    url_char = String.to_charlist(url)

    result =
      case BobVersions.Http.request(method, {url_char, headers}, [], body_format: :binary) do
        {:ok, {{_version, 200, ~c"OK"}, headers, body}} ->
          {:ok, headers, body}

        {:ok, {{_version, 304, ~c"Not Modified"}, headers, _body}} ->
          {:ok, headers, :not_modified}

        _ ->
          :error
      end

    case result do
      {:ok, headers, body} -> update_table(url, headers, body, config)
      :error -> :error
    end
  end

  @spec update_table(url, headers, :not_modified, map) :: {:ok, :not_modified} | :error
  @spec update_table(url, headers, binary, map) :: {:ok, binary} | :error
  defp update_table(url, headers, :not_modified, %{method: method}) do
    etag = :proplists.get_value(~c"etag", headers)
    timestamp = DateTime.utc_now() |> DateTime.to_unix(:millisecond)

    if :ets.update_element(@ets_table, {url, method}, [{2, timestamp}, {3, etag}]) do
      {:ok, :not_modified}
    else
      :error
    end
  end

  defp update_table(url, headers, body, %{method: method}) do
    etag = :proplists.get_value(~c"etag", headers)
    timestamp = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    :ets.insert(@ets_table, {{url, method}, timestamp, etag, body})
    {:ok, body}
  end

  @spec if_none_match_header(nil | charlist) :: headers
  defp if_none_match_header(nil), do: []
  defp if_none_match_header(etag), do: [{~c"If-None-Match", etag}]
end
