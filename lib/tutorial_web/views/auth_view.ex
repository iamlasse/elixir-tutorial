defmodule TutorialWeb.AuthView do
  use TutorialWeb, :view


  def render("token.json", %{token: token, user: user}) do
    %{
      jwt: token,
      user: render_one(user, TutorialWeb.UserView, "user.json")
    }
  end

  def render("login.json", %{error: error}) do
    %{error: error}
  end

  def render("error.json", %{error: error, reason: reason}) do
    %{error: error, reason: reason}
  end
end