defmodule TutorialWeb.CreatorView do
  use TutorialWeb, :view

  def render("creator.json", %{creator: creator}) do
    %{sport: creator.favorite_sport, bio: creator.bio}
  end
end
