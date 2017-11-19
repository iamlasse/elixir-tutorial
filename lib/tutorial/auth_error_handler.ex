defmodule Tutorial.AuthErrorHandler do
  import Plug.Conn
  import Phoenix.Controller

  def auth_error(conn, {type, reason}, _opts) do
    conn
    |> put_flash(:error, "You're not logged in")
    |> redirect(to: "/auth/new")
  end
end