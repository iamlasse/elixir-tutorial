defmodule TutorialWeb.UserView do
  use TutorialWeb, :view

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email,
      profile: render_one(user.creator, TutorialWeb.CreatorView, "creator.json")
    }
  end
end
