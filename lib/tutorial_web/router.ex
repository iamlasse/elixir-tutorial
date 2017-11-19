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

  pipeline :browser_pipe do
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

    scope "/cms", CMS, as: :cms do
      pipe_through [:browser_pipe, :authorize]
      resources("/floks", FlokController)
    end

    resources(
      "/auth",
      AuthController,
      only: [:new, :create, :delete],
      singleton: true
    )

    # get "/", PageController, :index
    get("/hello", HelloController, :index)
    get("/hello/:who", HelloController, :show)
    pipe_through([:browser_pipe, :authorize])
    resources("/users", UserController)
    resources("/wallets", WalletController)
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
end
