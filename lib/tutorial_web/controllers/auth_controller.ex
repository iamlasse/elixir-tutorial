defmodule TutorialWeb.AuthController do
  use TutorialWeb, :controller

  alias Tutorial.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_by_email_password(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> assign(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/wallets")
      {:error, :unauthorized} ->
        conn
        |> put_flash(:error, "Bad email/password combination")
        |> redirect(to: auth_path(conn, :new))
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> assign(:current_user, nil)
    |> redirect(to: auth_path(conn, :new))
  end
end