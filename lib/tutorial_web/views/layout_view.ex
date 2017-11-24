defmodule TutorialWeb.LayoutView do
  use TutorialWeb, :view
  import Guardian.Plug

  def current_user(conn) do
    current_resource(conn)
  end

  def title do
    "Awesome New Title!"
  end
end
