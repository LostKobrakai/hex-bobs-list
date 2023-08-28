defmodule BobVersionsWeb.PageController do
  use BobVersionsWeb, :controller

  def index(conn, _params) do
    conn
    |> put_view(BobVersionsWeb.PageView)
    |> render("index.html",
      title: "Bob's List",
      subtitle: "Overview of all available packages built by hex bob."
    )
  end
end
