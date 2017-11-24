defmodule Tutorial.AuthApi do
  @moduledoc """
    Puts current resource in session and assigns for API
  """
  import Plug.Conn
  import Phoenix.Controller
  import Guardian.Plug
  import Phoenix.Token
  alias Tutorial.Accounts

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, _repo) do
    case current_resource(conn) do
      nil ->
        conn
        |> assign(:current_user, nil)

      user ->
        with {:ok, user} <- Accounts.find_user(user.id) do
            put_current_user(conn, user)
        else
          nil ->
            conn
            |> assign(:current_user, nil)
        end
    end
  end

  defp put_current_user(conn, user) do
    token = sign(conn, "user salt", user.id)

    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end
end
