defmodule BobVersions.BuildSetup.Erlang.Alpine do
  @moduledoc false
  @behaviour BobVersions.BuildSetup

  defdelegate group_by_version_and_sort(list), to: BobVersions.BuildSetup.Erlang
  defdelegate version_from_string(ref), to: BobVersions.BuildSetup.Erlang
  defdelegate github_ref_url(ref), to: BobVersions.BuildSetup.Erlang

  def hex_pm_download_url(branch) do
    "https://repo.hex.pm/builds/otp/alpine-3.10/#{branch}.tar.gz"
  end
end
