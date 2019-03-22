defmodule BoilerplateWeb.LayoutView do
  use BoilerplateWeb, :view

  def current_session(conn) do
    Plug.Conn.get_session(conn, :phauxth_session_id)
  end
end
