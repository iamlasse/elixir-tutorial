defmodule TutorialWeb.RootController do
  use TutorialWeb, :controller

  def index(conn, _) do
    conn
    |> json("hello from api")
  end
end