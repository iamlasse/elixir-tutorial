defmodule Tutorial.AuthApiErrorHandler do
  @moduledoc """
    Api error handler
  """
  import Plug.Conn
  import Phoenix.Controller

  def auth_error(conn, {type, reason}, _opts) do
    conn
    |> render(TutorialWeb.AuthView, "login.json", error: "You're not authneticated")
  end
end
