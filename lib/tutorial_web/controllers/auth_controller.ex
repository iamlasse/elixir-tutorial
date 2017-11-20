defmodule TutorialWeb.AuthController do
  use TutorialWeb, :controller

  alias Tutorial.Accounts
  # import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def new(conn, _) do
    render(conn, "new." <> get_format(conn))
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    # return_path = Plug.Conn.get_session(conn, :return_path)
    with {:ok, user} <- Accounts.verify_credentials(email, password) do
      conn
      |> Tutorial.Guardian.Plug.sign_in(user)
      |> put_flash(:info, "Welcome back!")
      |> put_session(:user_id, user.id)
      |> assign(:current_user, user)
      |> redirect(to: cms_wallet_path(conn, :index))
    else
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> redirect(to: auth_path(conn, :new))
    end
  end

  def api_sign_in(conn, %{"email" => email, "password" => password}) do
    with {:ok, user} <- Accounts.verify_credentials(email, password) do
      conn = Tutorial.Guardian.Plug.sign_in(conn, user)
      jwt = Tutorial.Guardian.Plug.current_token(conn)
      claims = Tutorial.Guardian.Plug.current_claims(conn)
      exp = Map.get(claims, "exp")

      conn
      |> put_resp_header("Authorization", "Bearer #{jwt}")
      |> put_resp_header("x-expires", "#{exp}")
      |> assign(:current_user, user)
      |> assign(:current_token, jwt)
      |> render("token.json", token: jwt, user: user, exp: exp)
    else
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> render("error.json", error: "Sign in error", reason: message)
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> assign(:current_user, nil)
    |> redirect(to: auth_path(conn, :new))
  end
end
