defmodule TutorialWeb.HelloView do
  use TutorialWeb, :view

  def render("show.json", %{who: who}) do
    %{who: who}
  end
  def render("show.html", %{who: who}) do
    render "show.html", who: who
  end

  # def render("show.html", %{who: who}) do
  #   render(HelloView, "show.html", who: who)
  # end
  def handler_info(conn) do
    "Request Handled By: #{controller_module(conn)}.#{action_name(conn)}"
  end

  def connection_keys(conn) do
    conn
    |> Map.from_struct()
    |> Map.keys()
  end

  def message do
    "Hello from the view!"
  end
end
