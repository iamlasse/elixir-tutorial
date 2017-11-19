defmodule TutorialWeb.HelloController do
  use TutorialWeb, :controller

  plug Guardian.Plug.EnsureAuthenticated

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"who" => who} = params) do
    conn
    |> assign(:message, "Welcome Back!")
    |> render(:show, who: who)
  end
end