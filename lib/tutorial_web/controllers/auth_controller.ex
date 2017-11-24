defmodule TutorialWeb.AuthController do
  use TutorialWeb, :controller

  alias Tutorial.Accounts
  import Tutorial.Guardian
  import Tutorial.Guardian.Plug
  import Tutorial.Facebook
  # import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def new(conn, _) do
    render(conn, "new." <> get_format(conn))
  end

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    # return_path = Plug.Conn.get_session(conn, :return_path)
    with {:ok, user} <- Accounts.verify_credentials(email, password) do
      conn
      |> sign_in(user)
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
      {:ok, jwt, claims} = encode_and_sign(user, %{})
      exp = Map.get(claims, "exp")

      # |> put_resp_header("Authorization", "Bearer #{jwt}")
      conn
      |> put_resp_header("x-expires", "#{exp}")
      |> assign(:current_user, user)
      |> assign(:current_token, jwt)
      |> render("token.json", token: jwt, user: user)
    else
      {:error, message} ->
        conn
        |> put_flash(:error, message)
        |> render("error.json", error: "Sign in error", reason: message)
    end
  end

  def authenticate(conn, %{"token" => token}) do
    IO.puts("Login with token from app ------------------->>>>")
    response = verify_user(token)
    # IO.inspect
    if Map.has_key?(response.body, "email") do
      with {:ok, user}
        <- Accounts.authenticate_by_email(Map.fetch!(response.body, "email")),
           {:ok, jwt, claims} <- encode_and_sign(user, %{}) do
        exp = Map.get(claims, "exp")

        conn
        |> put_resp_header("x-expires", "#{exp}")
        |> render("token.json", token: jwt, user: user)
      end
    else
      conn
      |> json(response.body)
    end
  end

  def authenticate(conn, _), do: conn |> json(%{error: "Token missing"})

  def me(conn, _) do
    current_user = current_resource(conn)
    with {:ok, user} <- Accounts.get_user!(current_user.id) do
      conn
      |> render(TutorialWeb.UserView, "user.json", user: user)
    else
      {:error, :no_resource} ->
        conn
        |> json(%{error: "No user logged in"})
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> assign(:current_user, nil)
    |> redirect(to: auth_path(conn, :new))
  end
end
