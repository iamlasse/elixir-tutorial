defmodule TutorialWeb.BackgroundJob.Plug do
  @moduledoc """

  """
  import Plug.Conn
  alias TutorialWeb.BackgroundJob.Router
  def init(opts), do: opts
  def call(conn, opts) do
    conn
    |> assign(:name, Keyword.get(opts, :name, "Background Job"))
    |> Router.call(opts)
  end
end
