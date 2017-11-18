defmodule Tutorial.Auth do
  import Plug.Conn
  # import Phoenix.Controller

  def init(opts) do
    Keyword.fetch!(opts, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)

    cond do
      user = conn.assigns[:current_user] ->
        put_current_user(conn, user)
      user = user_id && repo.get(Tutorial.Accounts.User, user_id) ->
        put_current_user(conn, user)
      true ->
        assign(conn, :current_user, nil)
    end
  end

  defp put_current_user(conn, user) do
    token = Phoenix.Token.sign(conn, "user salt", user.id)
    conn
    |> assign(:current_user, user)
    |> assign(:user_token, token)
  end
end