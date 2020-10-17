defmodule BobVersionsWeb.ErlangController do
  use BobVersionsWeb, :controller

  plug :valid_distro_or_404, %{"ubuntu" => :ubuntu, "alpine" => :alpine} when action == :show

  def show(conn, _params) do
    case BobVersions.get_bob_erlang_builds_file(conn.assigns.distro) do
      {_, text} ->
        data = BobVersions.text_to_data({:erlang, conn.assigns.distro}, text)
        stable = BobVersions.current_stable()
        active = BobVersions.default_otp_version()

        render(conn, "index.html",
          data: data,
          active: active,
          stable: stable,
          title: "Erlang – #{distro_label(conn.assigns.distro)}",
          subtitle: "Overview of all available packages built by hex bob."
        )

      :error ->
        conn
        |> put_view(BobVersionsWeb.ErrorView)
        |> render("no_resource.html")
    end
  end

  defp distro_label(:ubuntu), do: "Ubuntu 14.04"
  defp distro_label(:alpine), do: "Alpine 3.10"

  defp valid_distro_or_404(conn, valid) do
    distro = conn.params["distro"]

    case valid do
      %{^distro => distro} ->
        assign(conn, :distro, distro)

      _ ->
        conn
        |> put_view(BobVersionsWeb.ErrorView)
        |> render("404.html")
        |> halt()
    end
  end
end
