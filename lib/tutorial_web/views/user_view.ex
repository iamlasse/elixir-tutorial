defmodule TutorialWeb.UserView do
  use TutorialWeb, :view

  def render("user.json", %{user: user}) do
    %{
      id: user.id
    }
  end
end
