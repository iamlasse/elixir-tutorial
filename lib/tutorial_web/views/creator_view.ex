defmodule TutorialWeb.CreatorView do
  use TutorialWeb, :view

  def render("creator.json", %{creator: creator}) do
    %{id: creator.id, username: creator.user.username}
  end
end
