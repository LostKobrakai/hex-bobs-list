defmodule BobVersions.Http do
  @env Mix.env()

  def request(method, request, http_opts, opts) do
    :httpc.request(method, request, Keyword.merge([ssl: secure_ssl(@env)], http_opts), opts)
  end

  defp secure_ssl(:dev) do
    [
      verify: :verify_peer,
      cacertfile: Application.app_dir(:bob_versions, "priv/certs.crt"),
      customize_hostname_check: [
        match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
      ],
      reuse_sessions: false
    ]
  end

  defp secure_ssl(_) do
    [
      verify: :verify_peer,
      cacertfile: "/etc/ssl/certs/ca-certificates.crt",
      customize_hostname_check: [
        match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
      ],
      reuse_sessions: true
    ]
  end
end
