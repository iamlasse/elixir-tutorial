defmodule TutorialWeb.LayoutView do
  use TutorialWeb, :view

  def current_user(conn) do
    Guardian.Plug.current_resource(conn)
  end

  def title do
    "Awesome New Title!"
  end
end
