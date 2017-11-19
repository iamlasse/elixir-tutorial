defmodule TutorialWeb.AuthView do
  use TutorialWeb, :view


  def render("token.json", %{token: token, user: user, exp: exp}) do
    %{
      token: token,
      user: render_one(user, TutorialWeb.UserView, "user.json", user: user),
      exp: exp
    }
  end

  def render("login.json", %{error: error}) do
    %{error: error}
  end
end