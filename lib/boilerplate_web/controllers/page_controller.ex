defmodule BoilerplateWeb.PageController do
  use BoilerplateWeb, :controller

  import BoilerplateWeb.Authorize

  plug :user_check when action in [:app]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def app(conn, _params) do
    render(conn, "app.html")
  end
end
