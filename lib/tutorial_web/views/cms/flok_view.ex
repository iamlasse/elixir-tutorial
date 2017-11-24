defmodule TutorialWeb.CMS.FlokView do
  use TutorialWeb, :view

  alias Tutorial.CMS.Flok

  def render("index.json", %{floks: floks}) do
    %{data: render_many(floks, __MODULE__, "flok.json", floks: floks)}
  end

  def render("show.json", %{flok: flok}) do
    %{data: render_one(flok, __MODULE__, "flok.json", flok: flok)}
  end

  def render("flok.json", %{flok: flok}) do
    %{
      id: flok.id,
      title: flok.title,
      description: flok.description,
      creator:
        render_one(flok.creator,
          TutorialWeb.CreatorView,
          "creator.json",
          creator: flok.creator
        )
    }
  end

  def creator_name(%Flok{creator: creator}) do
    creator.user.username
  end
end
