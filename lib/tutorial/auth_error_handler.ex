defmodule Tutorial.AuthErrorHandler do
  @moduledoc """
    Auth error handler
  """
  import Plug.Conn
  import Phoenix.Controller

  def auth_error(conn, {type, reason}, _opts) do
    conn
    |> put_flash(:error, "You're not logged in #{reason}")
    |> redirect(to: "/auth/new")
  end
end
