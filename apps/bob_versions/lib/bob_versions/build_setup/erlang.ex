defmodule BobVersions.BuildSetup.Erlang do
  @moduledoc false
  def version_from_string(string) do
    %{erlang: string}
  end

  def github_ref_url(ref) do
    "https://github.com/erlang/otp/commit/#{ref}"
  end

  def group_by_version_and_sort(list) do
    list
    |> Enum.group_by(&minor_version(&1.version.erlang))
    |> Enum.map(fn {minor_version, values} ->
      %{
        version: minor_version,
        minor_version: major_version(minor_version),
        git: values |> List.first() |> Map.get(:git),
        versions: values
      }
    end)
    |> Enum.group_by(fn
      %{minor_version: <<"OTP-"::binary, _::binary>> = version} -> version
      %{minor_version: "master"} -> "master"
      %{minor_version: "maint"} -> "master"
      _ -> "others"
    end)
  end

  defp major_version(<<"maint-"::binary, major::binary-size(2)>>), do: "OTP-" <> major
  defp major_version(<<"OTP-"::binary, major::binary-size(2), rest::binary>>), do: "OTP-" <> major
  defp major_version(other), do: other

  defp minor_version(<<"OTP-"::binary, rest::binary>> = version) do
    with [major, minor | _] <- String.split(rest, ".") do
      "OTP-#{major}.#{minor}"
    else
      _ -> version
    end
  end

  defp minor_version(other), do: other
end
