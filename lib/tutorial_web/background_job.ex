defmodule TutorialWeb.BackgroundJob.Plug do
  @moduledoc """

  """
  import Plug.Conn
  import TutorialWeb.BackgroundJob.Router

  def init(opts), do: opts
  def call(conn, opts) do
    conn
    |> assign(:name, Keyword.get(opts, :name, "Background Job"))
    |> call(opts)
  end
end
