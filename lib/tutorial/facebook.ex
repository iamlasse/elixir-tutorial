defmodule Tutorial.Facebook do
  @moduledoc """
    Helps verifyng facebook tokens
  """
  use Tesla, only: [:get]

  plug(Tesla.Middleware.BaseUrl, "https://graph.facebook.com/")
  # plug Tesla.Middleware.Headers, %{"Authorization" => "token xyz"}
  plug(Tesla.Middleware.JSON)
  # plug Tesla.Middleware.DecodeJson

  def verify_user(token) do
    case get("me", query: [fields: "email,name,picture", access_token: token]) do
      %{body: %{"error"=> error}} -> {:error, error}
      %{body: body} -> {:ok, body}
    end
  end
end
