defmodule BobVersions.BuildSetup.Elixir do
  @moduledoc false
  @behaviour BobVersions.BuildSetup

  @default_otp_version "Default"

  def version_from_string(string) do
    case Regex.named_captures(~r/^(?<elixir>.*?)(-otp-(?<otp>\d+))?$/, string) do
      %{"elixir" => elixir, "otp" => otp} when otp != "" ->
        %{elixir: elixir, otp: otp}

      %{"elixir" => elixir} ->
        %{elixir: elixir, otp: @default_otp_version}
    end
  end

  def group_by_version_and_sort(list) do
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

  defp minor_version(<<"v"::binary, rest::binary>> = version) do
    case Version.parse(rest) do
      {:ok, version} -> "v#{version.major}.#{version.minor}"
      _ -> version
    end
  end

  defp minor_version(other), do: other

  def github_ref_url(ref) do
    "https://github.com/elixir-lang/elixir/commit/#{ref}"
  end

  def hex_pm_download_url(branch) do
    "https://builds.hex.pm/builds/elixir/#{branch}.zip"
  end
end
