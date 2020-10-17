defmodule BobVersions do
  @moduledoc """
  BobVersions keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  @cache_timeout :timer.minutes(15)
  @default_otp_version "Default"
  @current_stable "v1.11"

  def current_stable do
    @current_stable
  end

  def default_otp_version do
    @default_otp_version
  end

  @spec get_bob_elixir_builds_file() :: {:ok | :stale, binary} | :error
  def get_bob_elixir_builds_file do
    url = "https://repo.hex.pm/builds/elixir/builds.txt"
    BobVersions.EtagCachedResources.resource(url, cache_timeout: @cache_timeout)
  end

  @spec get_bob_erlang_builds_file(:ubuntu | :alpine) :: {:ok | :stale, binary} | :error
  def get_bob_erlang_builds_file(distro) do
    url =
      case distro do
        :ubuntu -> "https://repo.hex.pm/builds/otp/ubuntu-14.04/builds.txt"
        :alpine -> "https://repo.hex.pm/builds/otp/alpine-3.10/builds.txt"
      end

    BobVersions.EtagCachedResources.resource(url, cache_timeout: @cache_timeout)
  end

  def text_to_data(setup, string, opts \\ []) do
    setup =
      case setup do
        :elixir -> BobVersions.BuildSetup.Elixir
        {:erlang, :ubuntu} -> BobVersions.BuildSetup.Erlang.Ubuntu
        {:erlang, :alpine} -> BobVersions.BuildSetup.Erlang.Alpine
      end

    availability = Keyword.get(opts, :availability, &attach_availability/1)

    string
    |> lines_from_string()
    |> Enum.map(&line_to_data(setup, &1))
    |> availability.()
    |> Enum.filter(&is_map/1)
    |> Enum.filter(&is_map(&1.version))
    |> setup.group_by_version_and_sort()
  end

  defp lines_from_string(string) do
    string
    |> :binary.split(["\r", "\n", "\r\n"], [:global])
    |> Enum.reject(&(&1 in [""]))
  end

  defp line_to_data(setup, line) do
    case String.split(line, " ") do
      [branch, hex, timestamp, checksum | _] ->
        %{
          download: hex_pm_download_url(setup, branch),
          version: version_from_string(setup, branch),
          git: %{
            sha: hex,
            url: github_ref_url(setup, hex)
          },
          timestamp: parse_datetime(timestamp),
          checksum: checksum
        }

      [branch, hex, timestamp | _] ->
        %{
          download: hex_pm_download_url(setup, branch),
          version: version_from_string(setup, branch),
          git: %{
            sha: hex,
            url: github_ref_url(setup, hex)
          },
          timestamp: parse_datetime(timestamp),
          checksum: ""
        }
    end
  end

  defp attach_availability(list) do
    stream =
      Task.async_stream(
        list,
        fn %{download: download} = data ->
          Map.put(data, :availability, BobVersions.Availability.url_availability(download))
        end,
        max_concurrency: 1
      )

    for {:ok, executed} <- stream, do: executed
  end

  defp parse_datetime(timestamp) do
    {:ok, datetime, 0} = DateTime.from_iso8601(timestamp)
    datetime
  end

  defp version_from_string(setup, string) do
    setup.version_from_string(string)
  end

  defp minor_version(<<"v"::binary, rest::binary>> = version) do
    case Version.parse(rest) do
      {:ok, version} -> "v#{version.major}.#{version.minor}"
      _ -> version
    end
  end

  defp minor_version(other), do: other

  defp github_ref_url(_, ""), do: nil

  defp github_ref_url(setup, ref) do
    setup.github_ref_url(ref)
  end

  defp hex_pm_download_url(setup, branch) do
    setup.hex_pm_download_url(branch)
  end
end
