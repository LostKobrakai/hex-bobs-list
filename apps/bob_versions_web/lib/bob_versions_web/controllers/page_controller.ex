defmodule BobVersionsWeb.PageController do
  use BobVersionsWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html",
      title: "Bob's List",
      subtitle: "Overview of all available packages built by hex bob."
    )
  end
end
