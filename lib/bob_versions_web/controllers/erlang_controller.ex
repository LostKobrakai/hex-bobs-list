defmodule BobVersionsWeb.ErlangController do
  use BobVersionsWeb, :controller

  plug :valid_distro_or_404,
       %{
         "ubuntu_14" => :ubuntu_14,
         "ubuntu_16" => :ubuntu_16,
         "ubuntu_18" => :ubuntu_18,
         "ubuntu_20" => :ubuntu_20,
         "ubuntu_22" => :ubuntu_22,
         "ubuntu_24" => :ubuntu_24
       }
       when action == :show

  def show(conn, _params) do
    case BobVersions.get_bob_erlang_builds_file(conn.assigns.distro) do
      {_, text} ->
        data = BobVersions.text_to_data({:erlang, conn.assigns.distro}, text)
        stable = BobVersions.current_stable()
        active = BobVersions.default_otp_version()

        conn
        |> put_view(BobVersionsWeb.ErlangView)
        |> render("index.html",
          data: data,
          active: active,
          stable: stable,
          title: "Erlang – #{distro_label(conn.assigns.distro)}",
          subtitle: "Overview of all available packages built by hex bob."
        )

      :error ->
        conn
        |> put_layout(false)
        |> put_view(BobVersionsWeb.ErrorHTML)
        |> render("no_resource.html")
    end
  end

  defp distro_label(:ubuntu_14), do: "Ubuntu 14.04"
  defp distro_label(:ubuntu_16), do: "Ubuntu 16.04"
  defp distro_label(:ubuntu_18), do: "Ubuntu 18.04"
  defp distro_label(:ubuntu_20), do: "Ubuntu 20.04"
  defp distro_label(:ubuntu_22), do: "Ubuntu 22.04"
  defp distro_label(:ubuntu_24), do: "Ubuntu 24.04"

  defp valid_distro_or_404(conn, valid) do
    distro = conn.params["distro"]

    case valid do
      %{^distro => distro} ->
        assign(conn, :distro, distro)

      _ ->
        conn
        |> put_view(BobVersionsWeb.ErrorHTML)
        |> render("404.html")
        |> halt()
    end
  end
end
