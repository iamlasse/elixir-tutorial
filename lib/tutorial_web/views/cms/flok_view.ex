defmodule TutorialWeb.CMS.FlokView do
  use TutorialWeb, :view

  alias Tutorial.CMS.Flok

  def creator_name(%Flok{creator: creator}) do
    creator.user.username
  end
end
