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

  @spec get_bob_builds_file() :: {:ok | :stale, binary} | :error
  def get_bob_builds_file do
    url = "https://repo.hex.pm/builds/elixir/builds.txt"
    BobVersions.EtagCachedResources.resource(url, cache_timeout: @cache_timeout)
  end

  def text_to_data(string, opts \\ []) do
    availability = Keyword.get(opts, :availability, &attach_availability/1)

    string
    |> lines_from_string()
    |> Enum.map(&line_to_data/1)
    |> availability.()
    |> Enum.filter(&is_map/1)
    |> Enum.filter(&is_map(&1.version))
    |> group_by_version_and_sort
  end

  defp lines_from_string(string) do
    string
    |> :binary.split(["\r", "\n", "\r\n"], [:global])
    |> Enum.reject(&(&1 in [""]))
  end

  defp line_to_data(line) do
    case String.split(line, " ") do
      [branch, hex, timestamp, checksum | _] ->
        %{
          download: hex_pm_download_url(branch),
          version: version_from_string(branch),
          git: %{
            sha: hex,
            url: github_ref_url(hex)
          },
          timestamp: parse_datetime(timestamp),
          checksum: checksum
        }

      [branch, hex, timestamp | _] ->
        %{
          download: hex_pm_download_url(branch),
          version: version_from_string(branch),
          git: %{
            sha: hex,
            url: github_ref_url(hex)
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
        max_concurrency: System.schedulers_online() * 4
      )

    for {:ok, executed} <- stream, do: executed
  end

  defp parse_datetime(timestamp) do
    {:ok, datetime, 0} = DateTime.from_iso8601(timestamp)
    datetime
  end

  defp version_from_string(string) do
    case Regex.named_captures(~r/^(?<elixir>.*?)(-otp-(?<otp>\d+))?$/, string) do
      %{"elixir" => elixir, "otp" => otp} when otp != "" ->
        %{elixir: elixir, otp: otp}

      %{"elixir" => elixir} ->
        %{elixir: elixir, otp: @default_otp_version}
    end
  end

  defp minor_version(<<"v"::binary, rest::binary>> = version) do
    case Version.parse(rest) do
      {:ok, version} -> "v#{version.major}.#{version.minor}"
      _ -> version
    end
  end

  defp minor_version(other), do: other

  defp group_by_version_and_sort(list) do
    list
    |> Enum.group_by(& &1.version.elixir)
    |> Enum.map(fn {elixir_version, values} ->
      %{
        version: elixir_version,
        minor_version: minor_version(elixir_version),
        git: values |> List.first() |> Map.get(:git),
        versions: values
      }
    end)
    |> Enum.group_by(fn
      %{minor_version: <<"v"::binary, _::binary>> = version} -> version
      %{minor_version: "master"} -> "master"
      _ -> "others"
    end)
  end

  defp github_ref_url(""), do: nil

  defp github_ref_url(ref) do
    "https://github.com/elixir-lang/elixir/commit/#{ref}"
  end

  defp hex_pm_download_url(branch) do
    "https://repo.hex.pm/builds/elixir/#{branch}.zip"
  end
end
