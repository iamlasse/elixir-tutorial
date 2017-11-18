defmodule TutorialWeb.HelloController do
  use TutorialWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"who" => who} = params) do
    # IO.inspect user
    # IO.inspect conn.assigns
    # who = Poison.encode!(%{who: who})
    conn
    |> assign(:message, "Welcome Back!")
    # |> put_flash(:info, "Welcome to Phoenix, from flash info!")
    # |> put_flash(:error, "Let's pretend we have an error.")
    # |> put_status(200)
    # |> put_resp_content_type)
    |> render(:show, who: who)
  end
end