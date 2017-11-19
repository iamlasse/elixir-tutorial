defmodule TutorialWeb.AuthController do
  use TutorialWeb, :controller

  alias Tutorial.Accounts
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def new(conn, _) do
    render(conn, "new." <> get_format(conn))
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.verify_credentials(email, password) do
      {:ok, user} ->
        conn
        |> Tutorial.Guardian.Plug.sign_in(user)
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> assign(:current_user, user)
        # |> assign(:current_token, token)
        # |> configure_session(renew: true)
        |> redirect(to: "/wallets")
      {:error, :invalid_password} ->
        conn
        |> put_flash(:error, "Missing or invalid password")
        |> redirect(to: auth_path(conn, :new))
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad email/password combination")
        |> redirect(to: auth_path(conn, :new))
    end
  end

  def api_sign_in(conn, %{"email" => email, "password" => password}) do
    case Accounts.verify_credentials(email, password) do
      {:ok, user} ->
        conn
        |> sign_in_user(user)
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad email/password combination")
        |> render("error.json", error: "Sign in error", reason: "Bad email/password combination")
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> assign(:current_user, nil)
    |> redirect(to: auth_path(conn, :new))
  end

  defp sign_in_user(conn, user) do
    new_conn = Tutorial.Guardian.Plug.sign_in(conn, user)
    jwt = Tutorial.Guardian.Plug.current_token(new_conn)
    claims = Tutorial.Guardian.Plug.current_claims(new_conn)
    exp = Map.get(claims, "exp")

    new_conn
    |> put_resp_header("Authorization", "Bearer #{jwt}")
    |> put_resp_header("x-expires", "#{exp}")
    |> assign(:current_user, user)
    |> assign(:current_token, jwt)
    |> render("token.json", token: jwt, user: user, exp: exp)
  end
end