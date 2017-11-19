defmodule Tutorial.AuthApi do
  import Plug.Conn
  import Phoenix.Controller
  alias Tutorial.Accounts

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, _repo) do
    case Guardian.Plug.current_resource(conn) do
      nil ->
        conn
        |> assign(:current_user, nil)

      user ->
        case Accounts.find_user(user.id) do
          {:ok, user} ->
            put_current_user(conn, user)

          nil ->
            conn
            |> assign(:current_user, nil)
        end
    end
  end

  defp put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user salt", user.id)

    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end
end
