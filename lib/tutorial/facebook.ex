defmodule Tutorial.Facebook do
  use Tesla, only: [:get]

  plug(Tesla.Middleware.BaseUrl, "https://graph.facebook.com/")
  # plug Tesla.Middleware.Headers, %{"Authorization" => "token xyz"}
  plug(Tesla.Middleware.JSON)
  # plug Tesla.Middleware.DecodeJson

  def verify_user(token) do
    # get("/user/" <> login <> "/repos")
    get("me", query: [fields: "email,name,picture", access_token: token])
    # get("me?fields=name,email,picture&access_token=" <> token)
  end
end
