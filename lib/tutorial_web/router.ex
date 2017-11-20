defmodule TutorialWeb.Router do
  use TutorialWeb, :router
  alias Tutorial.Accounts

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:put_secure_browser_headers)
    plug(Tutorial.Auth, repo: Tutorial.Repo)
  end

  pipeline :api do
    plug(:accepts, ["json"])
    plug(:fetch_session)
    plug(:fetch_flash)
  end

  pipeline :browser_auth do
    # plug(:requested_path)

    plug(
      Guardian.Plug.Pipeline,
      module: Tutorial.Guardian,
      error_handler: Tutorial.AuthErrorHandler
    )

    plug(Guardian.Plug.VerifySession)
    plug(Guardian.Plug.EnsureAuthenticated)
    plug(Guardian.Plug.LoadResource, allow_blank: false)
    plug(Tutorial.Auth, repo: Tutorial.Repo)
  end

  pipeline :api_pipe do
    plug(
      Guardian.Plug.Pipeline,
      module: Tutorial.Guardian,
      error_handler: Tutorial.AuthApiErrorHandler
    )

    plug(Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"})
    plug(Guardian.Plug.EnsureAuthenticated, realm: "Bearer")
    plug(Guardian.Plug.LoadResource, allow_blank: false)
    plug(Tutorial.AuthApi, repo: Tutorial.Repo)
  end

  pipeline :authorize do
    # plug(Guardian.Plug.VerifySession, claims: %{"typ" => "access"})
  end

  scope "/", TutorialWeb do
    # Use the default browser stack
    pipe_through([:browser])
    get("/", RootController, :index)

    get("/hello", HelloController, :index)
    get("/hello/:who", HelloController, :show)

    resources("/users", UserController)
    # CMS
    scope "/cms", CMS, as: :cms do
      pipe_through([:browser_auth, :authorize])
      resources("/floks", FlokController)
      resources("/wallets", WalletController)
    end

    # AUTH
    resources("/auth", AuthController, only: [:new, :create, :delete], singleton: true)
  end

  scope "/api", TutorialWeb, as: :api do
    pipe_through([:api])

    scope "/auth" do
      post("/", AuthController, :api_sign_in)
    end

    scope "/cms", CMS, as: :cms do
      pipe_through([:api_pipe, :authorize])
      resources("/floks", FlokController)
    end
  end

  # defp requested_path(conn, _) do
  #   IO.puts("PLUG requested path")
  #   IO.inspect(conn.request_path)

  #   redirect_to =
  #     case conn.request_path do
  #       "/auth" <> _ -> "/cms/floks"
  #       _ -> conn.request_path
  #     end

  #   conn
  #   |> put_session(:return_path, redirect_to)
  # end
end
