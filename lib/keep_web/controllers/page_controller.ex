defmodule KeepWeb.PageController do
  use KeepWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
