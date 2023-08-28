defmodule BobVersions.BuildSetup do
  @callback version_from_string(version) ::
              %{elixir: version, otp: version} | %{erlang: version}
            when version: String.t()
  @callback github_ref_url(ref :: String.t()) :: url :: String.t()
  @callback hex_pm_download_url(branch :: String.t()) :: url :: String.t()
  @callback group_by_version_and_sort(list) :: list
end
