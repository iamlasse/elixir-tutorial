defmodule TutorialWeb.Router do
  use TutorialWeb, :router
  alias Tutorial.Accounts

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    plug(Tutorial.Auth, repo: Tutorial.Repo)
    plug(:put_user_token)
  end

  pipeline :review_checks do
    # plug :ensure_authenticated_user
    # plug :ensure_user_owns_review
    plug(Plug.RequestId)
    # plug(Plug.Logger)

    plug(
      Plug.Session,
      store: :cookie,
      key: "_hello_key",
      signing_salt: "change_me"
    )
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
    plug(:fetch_flash)
    # plug :authorize
    # plug :current_user
    plug(Tutorial.Auth, repo: Tutorial.Repo)
  end



  scope "/", TutorialWeb do
    # Use the default browser stack
    pipe_through([:browser])
    get("/", RootController, :index)

    resources(
      "/auth",
      AuthController,
      only: [:new, :create, :delete],
      singleton: true
    )

    # get "/", PageController, :index
    resources("/users", UserController)
    resources("/wallets", WalletController)
    get("/hello", HelloController, :index)
    get("/hello/:who", HelloController, :show)
  end

  # Other scopes may use custom stacks.
  scope "/api", TutorialWeb do
    pipe_through([:api, :review_checks])
    get("/hello", HelloController, :index)
    get("/hello/:who", HelloController, :show)
    forward("/jobs", BackgroundJob.Plug)

    scope "/cms", CMS, as: :cms do
      resources "/floks", FlokController
    end
  end

  defp put_user_token(conn, _) do
    if current_user = conn.assigns[:current_user] do
      token = Phoenix.Token.sign(conn, "user salt", current_user.id)
      assign(conn, :user_token, token)
    else
      conn
    end
  end

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> Phoenix.Controller.put_flash(:error, "Login required")
        |> Phoenix.Controller.redirect(to: "/")
        |> halt()

      user_id ->
        assign(conn, :current_user, Tutorial.Accounts.get_user!(user_id))
    end
  end

  # defp authorize(conn, _opts) do
  #   conn
  #   |> send_resp(401, "unauthorized")
  #   |> halt()
  # end
end