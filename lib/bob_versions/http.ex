defmodule BobVersions.Http do
  def request(method, request, http_opts, opts) do
    :httpc.request(method, request, Keyword.merge([ssl: secure_ssl()], http_opts), opts)
  end

  if Mix.env() == :dev do
    defp secure_ssl() do
      [
        verify: :verify_peer,
        cacertfile: Application.app_dir(:bob_versions, "priv/certs.crt"),
        customize_hostname_check: [
          match_fun: :public_key.pkix_verify_hostname_match_fun(:https)
        ],
        reuse_sessions: false
      ]
    end
  else
    defp secure_ssl() do
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
end
