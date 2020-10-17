defmodule BobVersionsWeb.ErlangView do
  use BobVersionsWeb, :view

  def sort_by_minor(list) do
    Enum.sort(list, fn {k1, _v1}, {k2, _v2} ->
      sort_order(k1, k2, :desc)
    end)
  end

  def sort_by_version(list) do
    Enum.sort_by(list, &sort_versions(&1.version))
  end

  defp sort_versions("master"), do: :ok
  defp sort_versions("maint"), do: :ok

  defp sort_versions(version) do
    case Regex.named_captures(
           ~r/^(?>OTP-|maint-)(?<version>[0-9\.]*?)(?>-rc(?<rc>\d+))?$/,
           version
         ) do
      %{"version" => version, "rc" => rc} when rc != "" ->
        version =
          version
          |> String.split(".")
          |> Enum.map(&String.to_integer/1)
          |> Enum.map(&Kernel.*(&1, -1))

        [version, rc]

      %{"version" => version} ->
        version =
          version
          |> String.split(".")
          |> Enum.map(&String.to_integer/1)
          |> Enum.map(&Kernel.*(&1, -1))

        [version, 0]
    end
  end

  defp sort_order(k1, k2, direction) do
    false_version_order =
      case direction do
        :asc -> :gt
        :desc -> :lt
      end

    case {k1, k2} do
      {<<"OTP-"::binary, v1::binary>>, <<"OTP-"::binary, v2::binary>>} ->
        with {_, {:ok, v1}} <- {:v1, version_for_sure(v1)},
             {_, {:ok, v2}} <- {:v2, version_for_sure(v2)} do
          Version.compare(v1, v2) != false_version_order
        else
          {:v1, :error} -> true
          {:v2, :error} -> false
        end

      {"master", _} ->
        true

      {_, "master"} ->
        false

      {<<"v"::binary, _::binary>>, _} ->
        true

      {_, <<"v"::binary, _::binary>>} ->
        false

      {_, _} ->
        true
    end
  end

  defp version_for_sure(version) do
    with :error <- Version.parse(version),
         :error <- Version.parse("#{version}.999"),
         :error <- Version.parse("#{version}.999.999") do
      :error
    end
  end
end
